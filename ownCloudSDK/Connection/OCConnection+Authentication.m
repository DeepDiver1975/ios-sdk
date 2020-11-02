//
//  OCConnection+Authentication.m
//  ownCloudSDK
//
//  Created by Felix Schwarz on 01.03.18.
//  Copyright © 2018 ownCloud GmbH. All rights reserved.
//

/*
 * Copyright (C) 2018, ownCloud GmbH.
 *
 * This code is covered by the GNU Public License Version 3.
 *
 * For distribution utilizing Apple mechanisms please see https://owncloud.org/contribute/iOS-license-exception/
 * You should have received a copy of this license along with this program. If not, see <http://www.gnu.org/licenses/gpl-3.0.en.html>.
 *
 */

#import "OCConnection.h"
#import "NSError+OCError.h"

@implementation OCConnection (Authentication)

#pragma mark - Authentication
- (void)requestSupportedAuthenticationMethodsWithOptions:(OCAuthenticationMethodDetectionOptions)options completionHandler:(void(^)(NSError *error, NSArray <OCAuthenticationMethodIdentifier> *supportedMethods))completionHandler
{
	NSArray <Class> *authenticationMethodClasses = [OCAuthenticationMethod registeredAuthenticationMethodClasses];
	NSMutableSet <NSURL *> *detectionURLs = [NSMutableSet set];
	NSMutableDictionary <NSString *, NSArray <NSURL *> *> *detectionURLsByMethod = [NSMutableDictionary dictionary];
	NSMutableDictionary <NSURL *, OCHTTPRequest *> *detectionRequestsByDetectionURL = [NSMutableDictionary dictionary];
	
	if (completionHandler==nil) { return; }
	
	// Add OCAuthenticationMethodAllowURLProtocolUpgrades support
	completionHandler = ^(NSError *error, NSArray <OCAuthenticationMethodIdentifier> *supportedMethods){
		if ((error!=nil) && [error isOCErrorWithCode:OCErrorAuthorizationRedirect] &&
		    (options!=nil) && (options[OCAuthenticationMethodAllowURLProtocolUpgradesKey]!=nil) && ((NSNumber *)options[OCAuthenticationMethodAllowURLProtocolUpgradesKey]).boolValue)
		{
			NSURL *redirectURLBase;

			if ((redirectURLBase = [error ocErrorInfoDictionary][OCAuthorizationMethodAlternativeServerURLKey]) != nil)
			{
				if ([self _isAlternativeBaseURLSafeUpgrade:redirectURLBase])
				{
					self->_bookmark.url = redirectURLBase;
					
					[self requestSupportedAuthenticationMethodsWithOptions:options completionHandler:completionHandler];

					return;
				}
			}
		}
		
		completionHandler(error, supportedMethods);
	};
	
	// Collect detection URLs for pre-loading
	for (Class authenticationMethodClass in authenticationMethodClasses)
	{
		OCAuthenticationMethodIdentifier authMethodIdentifier;
		
		if ((authMethodIdentifier = [authenticationMethodClass identifier]) != nil)
		{
			NSArray <NSURL *> *authMethodDetectionURLs;
			
			if ((authMethodDetectionURLs = [authenticationMethodClass detectionURLsForConnection:self]) != nil)
			{
				[detectionURLs addObjectsFromArray:authMethodDetectionURLs];
				
				detectionURLsByMethod[authMethodIdentifier] = authMethodDetectionURLs;
			}
		}
	}
	
	// Pre-load detection URLs
	dispatch_group_t preloadCompletionGroup = dispatch_group_create();
	
	for (NSURL *detectionURL in detectionURLs)
	{
		OCHTTPRequest *request = [OCHTTPRequest requestWithURL:detectionURL];

		request.redirectPolicy = OCHTTPRequestRedirectPolicyForbidden;
		
		dispatch_group_enter(preloadCompletionGroup);
		
		request.ephermalResultHandler = ^(OCHTTPRequest *request, OCHTTPResponse *response, NSError *error) {
			dispatch_group_leave(preloadCompletionGroup);
		};
		
		detectionRequestsByDetectionURL[detectionURL] = request;

		// Attach to pipelines
		[self attachToPipelines];

		request.forceCertificateDecisionDelegation = NO;

		// Force-allow any certificate for detection requests
		request.ephermalRequestCertificateProceedHandler = ^(OCHTTPRequest * _Nonnull request, OCCertificate * _Nonnull certificate, OCCertificateValidationResult validationResult, NSError * _Nonnull certificateValidationError, OCConnectionCertificateProceedHandler  _Nonnull proceedHandler) {
			proceedHandler(YES, nil);
		};

		[self.ephermalPipeline enqueueRequest:request forPartitionID:self.partitionID];
	}

	// Schedule block for when all detection URL pre-loads have finished
	dispatch_group_notify(preloadCompletionGroup, dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
		// Pass result to authentication methods
		NSMutableArray<OCAuthenticationMethodIdentifier> *supportedAuthMethodIdentifiers = [NSMutableArray array];

		dispatch_group_t detectionCompletionGroup = dispatch_group_create();

		for (Class authenticationMethodClass in authenticationMethodClasses)
		{
			OCAuthenticationMethodIdentifier authMethodIdentifier;
			
			if ((authMethodIdentifier = [authenticationMethodClass identifier]) != nil)
			{
				NSMutableDictionary <NSURL *, OCHTTPRequest *> *resultsByURL = [NSMutableDictionary dictionary];
				
				// Compile pre-load results
				for (NSURL *detectionURL in detectionURLsByMethod[authMethodIdentifier])
				{
					OCHTTPRequest *request;
					
					if ((request = [detectionRequestsByDetectionURL objectForKey:detectionURL]) != nil)
					{
						resultsByURL[detectionURL] = request;
					}
				}
				
				dispatch_group_enter(detectionCompletionGroup);
				
				[authenticationMethodClass detectAuthenticationMethodSupportForConnection:self withServerResponses:resultsByURL options:options completionHandler:^(OCAuthenticationMethodIdentifier identifier, BOOL supported) {
					if (supported)
					{
						[supportedAuthMethodIdentifiers addObject:identifier];
					}

					dispatch_group_leave(detectionCompletionGroup);
				}];
			}
		}
		
		// Schedule block for when all methods have completed detection
		dispatch_group_notify(detectionCompletionGroup, dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
			__block NSError *error = nil;
			
			if ((supportedAuthMethodIdentifiers.count == 0) && (detectionRequestsByDetectionURL.count > 0))
			{
				[detectionRequestsByDetectionURL enumerateKeysAndObjectsUsingBlock:^(NSURL *url, OCHTTPRequest *request, BOOL * _Nonnull stop) {
					if (request.httpResponse.redirectURL != nil)
					{
						NSURL *alternativeBaseURL;
				
						if ((alternativeBaseURL = [self extractBaseURLFromRedirectionTargetURL:request.httpResponse.redirectURL originalURL:request.url]) != nil)
						{
							error = OCErrorWithInfo(OCErrorAuthorizationRedirect, @{ OCAuthorizationMethodAlternativeServerURLKey : alternativeBaseURL });
						}
						else
						{
							error = OCErrorWithInfo(OCErrorAuthorizationFailed, @{ OCAuthorizationMethodAlternativeServerURLKey : request.httpResponse.redirectURL });
						}
					}
					else if (request.error != nil)
					{
						error = request.error;
					}
				}];
			}
		
			completionHandler(error, supportedAuthMethodIdentifiers);
		});
	});
}

- (void)generateAuthenticationDataWithMethod:(OCAuthenticationMethodIdentifier)methodIdentifier options:(OCAuthenticationMethodBookmarkAuthenticationDataGenerationOptions)options completionHandler:(void(^)(NSError *error, OCAuthenticationMethodIdentifier authenticationMethodIdentifier, NSData *authenticationData))completionHandler
{
	Class authenticationMethodClass;
	
	if ((authenticationMethodClass = [OCAuthenticationMethod registeredAuthenticationMethodForIdentifier:methodIdentifier]) != Nil)
	{
		OCAuthenticationMethod *authenticationMethod = [[authenticationMethodClass alloc] init];

		self.authenticationMethod = authenticationMethod;

		[authenticationMethod generateBookmarkAuthenticationDataWithConnection:self options:options completionHandler:^(NSError *error, OCAuthenticationMethodIdentifier authenticationMethodIdentifier, NSData *authenticationData) {
			if ((error != nil) && [error isOCErrorWithCode:OCErrorAuthorizationRedirect])
			{
				NSNumber *allowURLProtocolUpgrades = options[OCAuthenticationMethodAllowURLProtocolUpgradesKey];
			
				if ((allowURLProtocolUpgrades!=nil) && allowURLProtocolUpgrades.boolValue)
				{
					NSURL *redirectURLBase;
					
					if ((redirectURLBase = [error ocErrorInfoDictionary][OCAuthorizationMethodAlternativeServerURLKey]) != nil)
					{
						if ([self _isAlternativeBaseURLSafeUpgrade:redirectURLBase])
						{
							self->_bookmark.url = redirectURLBase;
							
							[self generateAuthenticationDataWithMethod:methodIdentifier options:options completionHandler:completionHandler];

							return;
						}
					}
				}
			}
		
			if (completionHandler != nil)
			{
				completionHandler(error, authenticationMethodIdentifier, authenticationData);
			}
		}];
	}
}

- (BOOL)canSendAuthenticatedRequestsWithAvailabilityHandler:(OCConnectionAuthenticationAvailabilityHandler)availabilityHandler
{
	__weak id<OCConnectionDelegate> delegate = _delegate;
	__weak OCConnection *weakSelf = self;
	BOOL canSend = YES;
	NSMutableArray <OCConnectionAuthenticationAvailabilityHandler> *pendingAuthenticationAvailabilityHandlers = _pendingAuthenticationAvailabilityHandlers;

	// Make sure the authentication method only receives calls to -canSendAuthenticatedRequestsForConnection:withAvailabilityHandler: after previous calls have finished
	@synchronized(pendingAuthenticationAvailabilityHandlers)
	{
		// Add availabilityHandler to pending
		availabilityHandler = [availabilityHandler copy]; // Make a copy of the block. Otherwise ARC will create one for us later and pointers may differ, so that -removeObject: can't remove it because the copy has a different pointer. The result would be that the queue hangs forever for seemingly no reason.
		
		[pendingAuthenticationAvailabilityHandlers addObject:availabilityHandler];

		if (pendingAuthenticationAvailabilityHandlers.count > 1)
		{
			// If others were also already pending, the previous response must already have been NO
			canSend = NO;
		}
		else
		{
			OCAuthenticationMethod *authenticationMethod;
			
			if ((authenticationMethod = self.authenticationMethod) != nil)
			{
				canSend = [authenticationMethod canSendAuthenticatedRequestsForConnection:self withAvailabilityHandler:^(NSError *error, BOOL authenticationIsAvailable) {
					// Share result with all pending Authentication Availability Handlers
					@synchronized(pendingAuthenticationAvailabilityHandlers)
					{
						for (OCConnectionAuthenticationAvailabilityHandler handler in pendingAuthenticationAvailabilityHandlers)
						{
							handler(error, authenticationIsAvailable);
						}

						[pendingAuthenticationAvailabilityHandlers removeAllObjects];
					};

					// Notify connection delegate in case of error
					if ((error != nil) && (weakSelf!=nil) && (delegate!=nil) && [delegate respondsToSelector:@selector(connection:handleError:)])
					{
						[delegate connection:weakSelf handleError:error];
					}
				}];
			}
			else
			{
				canSend = YES;
			}
			
			if (canSend)
			{
				// Remove availabilityHandler from pending because it won't ever be called
				[pendingAuthenticationAvailabilityHandlers removeObject:availabilityHandler];
			}
		}
	}
	
	return (canSend);
}

- (OCAuthenticationMethod *)_authenticationMethodWithIdentifier:(OCAuthenticationMethodIdentifier)methodIdentifier
{
	Class authenticationMethodClass;

	if ((authenticationMethodClass = [OCAuthenticationMethod registeredAuthenticationMethodForIdentifier:methodIdentifier]) != Nil)
	{
		return ([[authenticationMethodClass alloc] init]);
	}
	
	return (nil);
}

- (OCAuthenticationMethod *)authenticationMethod
{
	if ((_authenticationMethod == nil) || (![[[_authenticationMethod class] identifier] isEqual:_bookmark.authenticationMethodIdentifier]))
	{
		self.authenticationMethod = [self _authenticationMethodWithIdentifier:_bookmark.authenticationMethodIdentifier];
	}
	
	return (_authenticationMethod);
}

- (void)setAuthenticationMethod:(OCAuthenticationMethod *)authenticationMethod
{
	_authenticationMethod = authenticationMethod;
}

- (BOOL)_isAlternativeBaseURLSafeUpgrade:(NSURL *)alternativeBaseURL
{
	return ([[self class] isAlternativeBaseURL:alternativeBaseURL safeUpgradeForPreviousBaseURL:_bookmark.url]);
}

+ (NSArray <OCAuthenticationMethodIdentifier> *)filteredAndSortedMethodIdentifiers:(NSArray <OCAuthenticationMethodIdentifier> *)methodIdentifiers allowedMethodIdentifiers:(NSArray <OCAuthenticationMethodIdentifier> *)allowedMethodIdentifiers preferredMethodIdentifiers:(NSArray <OCAuthenticationMethodIdentifier> *)preferredMethodIdentifiers
{
	NSMutableArray<OCAuthenticationMethodIdentifier> *recommendedMethodIdentifiers = [NSMutableArray array];
	NSMutableArray <OCAuthenticationMethodIdentifier> *unusedMethodIdentifiers = [methodIdentifiers mutableCopy];

	// Remove all forbidden methods from unusedMethodIdentifiers
	if (allowedMethodIdentifiers!=nil)
	{
		for (OCAuthenticationMethodIdentifier supportedMethodID in methodIdentifiers) // Iterate in preferred order => result will also be in preferred order
		{
			if (![allowedMethodIdentifiers containsObject:supportedMethodID])
			{
				[unusedMethodIdentifiers removeObject:supportedMethodID];
			}
		}
	}

	// Add preferred methods in preferred order first
	for (OCAuthenticationMethodIdentifier preferredMethodID in preferredMethodIdentifiers)
	{
		if ([unusedMethodIdentifiers containsObject:preferredMethodID]) // Supported, allowed and
		{
			[recommendedMethodIdentifiers addObject:preferredMethodID];
			[unusedMethodIdentifiers removeObject:preferredMethodID];
		}
	}

	// Add rest of allowed methods
	[recommendedMethodIdentifiers addObjectsFromArray:unusedMethodIdentifiers];
	
	return (recommendedMethodIdentifiers);
}

- (NSArray <OCAuthenticationMethodIdentifier> *)filteredAndSortedMethodIdentifiers:(NSArray <OCAuthenticationMethodIdentifier> *)methodIdentifiers
{
	return ([[self class] filteredAndSortedMethodIdentifiers:methodIdentifiers allowedMethodIdentifiers:[self classSettingForOCClassSettingsKey:OCConnectionAllowedAuthenticationMethodIDs] preferredMethodIdentifiers:[self classSettingForOCClassSettingsKey:OCConnectionPreferredAuthenticationMethodIDs]]);
}

@end

//
//  OCCoreManager.m
//  ownCloudSDK
//
//  Created by Felix Schwarz on 08.06.18.
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

#import "OCCoreManager.h"
#import "NSError+OCError.h"
#import "OCBookmarkManager.h"
#import "OCHTTPPipelineManager.h"
#import "OCLogger.h"
#import "OCCore+FileProvider.h"

@implementation OCCoreManager

@synthesize postFileProviderNotifications = _postFileProviderNotifications;

#pragma mark - Shared instance
+ (instancetype)sharedCoreManager
{
	static dispatch_once_t onceToken;
	static OCCoreManager *sharedManager = nil;

	dispatch_once(&onceToken, ^{
		sharedManager = [OCCoreManager new];
		sharedManager.postFileProviderNotifications = OCCore.hostHasFileProvider;
	});

	return (sharedManager);
}

- (instancetype)init
{
	if ((self = [super init]) != nil)
	{
		_coresByUUID = [NSMutableDictionary new];
		_requestCountByUUID = [NSMutableDictionary new];

		_queuedOfflineOperationsByUUID = [NSMutableDictionary new];
		_runningOfflineOperationByUUID = [NSMutableDictionary new];

		_shutdownWaitGroupByUUID = [NSMutableDictionary new];
	}

	return(self);
}

#pragma mark - Requesting and returning cores
- (OCCore *)requestCoreForBookmark:(OCBookmark *)bookmark completionHandler:(void (^)(OCCore *core, NSError *error))completionHandler
{
	OCCore *returnCore = nil;

	OCLogDebug(@"core requested for bookmark %@", bookmark);

	@synchronized(self)
	{
		if (_runningOfflineOperationByUUID[bookmark.uuid] != nil)
		{
			OCLog(@"core for bookmark %@ unavailable due to running offline operation", bookmark);

			if (completionHandler != nil)
			{
				completionHandler(nil, OCError(OCErrorRunningOperation));
			}
		}
		else
		{
			NSNumber *requestCount = _requestCountByUUID[bookmark.uuid];

			requestCount = @(requestCount.integerValue + 1);
			_requestCountByUUID[bookmark.uuid] = requestCount;

			if (requestCount.integerValue == 1)
			{
				OCCore *core;
				dispatch_group_t shutdownWaitGroup = nil;

				@synchronized(_shutdownWaitGroupByUUID)
				{
					shutdownWaitGroup = _shutdownWaitGroupByUUID[bookmark.uuid];
				}

				if (shutdownWaitGroup != nil)
				{
					OCLog(@"waiting for previous core for %@ to complete shutdown", bookmark);
					dispatch_group_wait(shutdownWaitGroup, DISPATCH_TIME_FOREVER);
					OCLog(@"previous core for %@ has completed shutdown", bookmark);
				}

				OCLog(@"creating core for bookmark %@", bookmark);

				// Create and start core
				if ((core = [[OCCore alloc] initWithBookmark:bookmark]) != nil)
				{
					returnCore = core;

					core.postFileProviderNotifications = self.postFileProviderNotifications;

					_coresByUUID[bookmark.uuid] = core;

					OCLog(@"starting core for bookmark %@", bookmark);

					[core startWithCompletionHandler:^(id sender, NSError *error) {
						OCLog(@"core started for bookmark %@", bookmark);

						if (completionHandler != nil)
						{
							completionHandler((OCCore *)sender, error);
						}
					}];
				}
				else
				{
					if (completionHandler != nil)
					{
						completionHandler(nil, OCError(OCErrorInternal));
					}
				}
			}
			else
			{
				OCCore *core;

				OCLog(@"re-using core for bookmark %@", bookmark);

				if ((core = _coresByUUID[bookmark.uuid]) != nil)
				{
					returnCore = core;

					if ((core.state != OCCoreStateRunning) && (core.state != OCCoreStateStarting))
					{
						OCLog(@"starting core for bookmark %@", bookmark);

						[core startWithCompletionHandler:^(id sender, NSError *error) {
							OCLog(@"core started for bookmark %@", bookmark);

							if (completionHandler != nil)
							{
								completionHandler((OCCore *)sender, error);
							}
						}];
					}
					else if (completionHandler != nil)
					{
						OCLog(@"core for bookmark %@ already started", bookmark);
						completionHandler(core, nil);
					}
				}
				else
				{
					OCLogError(@"no core found for bookmark %@, although one should exist", bookmark);
				}
			}
		}
	}

	return (returnCore);
}

- (void)returnCoreForBookmark:(OCBookmark *)bookmark completionHandler:(dispatch_block_t)completionHandler
{
	BOOL runCompletionHandler = NO;

	OCLogDebug(@"core returned for bookmark %@ (%@)", bookmark.uuid.UUIDString, bookmark.name);

	@synchronized(self)
	{
		NSNumber *requestCount = _requestCountByUUID[bookmark.uuid];

		if (requestCount.integerValue > 0)
		{
			requestCount = @(requestCount.integerValue - 1);
			_requestCountByUUID[bookmark.uuid] = requestCount;
		}

		if (requestCount.integerValue == 0)
		{
			// Stop and release core
			OCCore *core;

			OCLog(@"shutting down core for bookmark %@", bookmark);

			if ((core = _coresByUUID[bookmark.uuid]) != nil)
			{
				// Set up waitgroup for core shutdown
				dispatch_group_t shutdownWaitGroup;

				@synchronized(_shutdownWaitGroupByUUID)
				{
					// Create / add waitgroup for UUID
					if ((shutdownWaitGroup = _shutdownWaitGroupByUUID[bookmark.uuid]) == nil)
					{
						if ((shutdownWaitGroup = dispatch_group_create()) != nil)
						{
							_shutdownWaitGroupByUUID[bookmark.uuid] = shutdownWaitGroup;
						}
					}

					if (shutdownWaitGroup != nil)
					{
						// Lock waitgroup
						dispatch_group_enter(shutdownWaitGroup);
					}
				}

				// Remove core from LUT
				[_coresByUUID removeObjectForKey:bookmark.uuid];

				OCLog(@"stopping core for bookmark %@", bookmark);

				// Stop core
				[core stopWithCompletionHandler:^(id sender, NSError *error) {
					[core unregisterEventHandler];

					@synchronized(self->_shutdownWaitGroupByUUID)
					{
						// Remove waitgroup for UUID
						if (self->_shutdownWaitGroupByUUID[bookmark.uuid] == shutdownWaitGroup)
						{
							self->_shutdownWaitGroupByUUID[bookmark.uuid] = nil;
						}

						// Unlock waitgroup
						dispatch_group_leave(shutdownWaitGroup);
					}

					OCLog(@"core stopped for bookmark %@", bookmark);

					if (completionHandler != nil)
					{
						completionHandler();
					}

					[self _runNextOfflineOperationForBookmark:bookmark];
				}];
			}
			else
			{
				OCLogError(@"no core found for bookmark %@, although one should exist", bookmark);
			}
		}
		else
		{
			OCLog(@"core still in use for bookmark %@", bookmark);

			runCompletionHandler = YES;
		}
	}

	if (runCompletionHandler)
	{
		if (completionHandler != nil)
		{
			completionHandler();
		}
	}
}

#pragma mark - Background session recovery
- (void)handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(dispatch_block_t)completionHandler
{
	[OCHTTPPipelineManager.sharedPipelineManager handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];

//	OCLogDebug(@"Handle events for background URL session: %@", identifier);
//
//	@synchronized(self)
//	{
//		if ((identifier != nil) && (completionHandler != nil))
//		{
//			NSUUID *sessionBookmarkUUID;
//
//			if ((sessionBookmarkUUID = [OCConnectionQueue uuidForBackgroundSessionIdentifier:identifier]) != nil)
//			{
//				OCBookmark *bookmark;
//
//				if ((bookmark = [[OCBookmarkManager sharedBookmarkManager] bookmarkForUUID:sessionBookmarkUUID]) != nil)
//				{
//					// Save completion handler
//					[OCConnectionQueue setCompletionHandler:^{
//						// Return core
//						OCLogDebug(@"Done handling pending events for background URL session %@, bookmark %@", identifier, bookmark);
//
//						[[OCCoreManager sharedCoreManager] returnCoreForBookmark:bookmark completionHandler:^{
//							OCLogDebug(@"Calling completionHandler for pending events for background URL session %@, bookmark %@", identifier, bookmark);
//							completionHandler();
//						}];
//					} forBackgroundSessionWithIdentifier:identifier];
//
//					// Request core, so it can pick up and handle this
//					[[OCCoreManager sharedCoreManager] requestCoreForBookmark:bookmark completionHandler:^(OCCore *core, NSError *error) {
//						if (core != nil)
//						{
//							// Resume pending background sessions
//							OCLogDebug(@"Resuming pending background URL session %@ for bookmark %@", identifier, bookmark);
//							[core.connection resumeBackgroundSessions];
//						}
//					}];
//				}
//				else
//				{
//					// No bookmark
//					OCLogError(@"Bookmark %@ not found (from URL session ID %@)", sessionBookmarkUUID, identifier);
//					completionHandler();
//				}
//			}
//			else
//			{
//				OCLogError(@"Can't extract bookmark UUID from URL session ID: %@", identifier);
//			}
//		}
//		else
//		{
//			OCLogError(@"Invalid parameters for handling background URL session events: (identifier=%@, completionHandler=%@)", identifier, completionHandler);
//		}
//	}
}

#pragma mark - Scheduling offline operations on cores
- (void)scheduleOfflineOperation:(OCCoreManagerOfflineOperation)offlineOperation forBookmark:(OCBookmark *)bookmark
{
	OCLogDebug(@"scheduling offline operation for bookmark %@", bookmark);

	@synchronized(self)
	{
		NSMutableArray<OCCoreManagerOfflineOperation> *queuedOfflineOperations;

		if ((queuedOfflineOperations = _queuedOfflineOperationsByUUID[bookmark.uuid]) == nil)
		{
			queuedOfflineOperations = [NSMutableArray new];
			_queuedOfflineOperationsByUUID[bookmark.uuid] = queuedOfflineOperations;
		}

		[queuedOfflineOperations addObject:offlineOperation];
	}

	[self _runNextOfflineOperationForBookmark:bookmark];
}

- (void)_runNextOfflineOperationForBookmark:(OCBookmark *)bookmark
{
	OCCoreManagerOfflineOperation offlineOperation = nil;

	@synchronized(self)
	{
		OCLogDebug(@"trying to run next offline operation for bookmark %@", bookmark);

		if ((_requestCountByUUID[bookmark.uuid].integerValue == 0) && (_runningOfflineOperationByUUID[bookmark.uuid] == nil))
		{
			if ((offlineOperation = _queuedOfflineOperationsByUUID[bookmark.uuid].firstObject) != nil)
			{
				OCLogDebug(@"running offline operation for bookmark %@: %@", bookmark, offlineOperation);

				[_queuedOfflineOperationsByUUID[bookmark.uuid] removeObjectAtIndex:0];
				_runningOfflineOperationByUUID[bookmark.uuid] = @(YES);
			}
			else
			{
				OCLogDebug(@"no queued offline operation for bookmark %@", bookmark);
			}
		}
		else
		{
			OCLogDebug(@"won't run offline operation for bookmark %@ at this time (requestCount=%lu, runningOperation=%d)", bookmark, _requestCountByUUID[bookmark.uuid].integerValue, (_runningOfflineOperationByUUID[bookmark.uuid] != nil));
		}
	}

	if (offlineOperation != nil)
	{
		offlineOperation(bookmark, ^{
			@synchronized(self)
			{
				[self->_runningOfflineOperationByUUID removeObjectForKey:bookmark.uuid];

				[self _runNextOfflineOperationForBookmark:bookmark];
			}
		});
	}
}

#pragma mark - Progress resolution
- (id<OCProgressResolver>)resolverForPathElement:(OCProgressPathElementIdentifier)pathElementIdentifier withContext:(OCProgressResolutionContext)context
{
	NSUUID *pathUUID;

	if ((pathUUID = [[NSUUID alloc] initWithUUIDString:pathElementIdentifier]) != nil)
	{
		@synchronized(self)
		{
			return ([_coresByUUID objectForKey:pathUUID]);
		}
	}

	return (nil);
}

#pragma mark - Memory configuration
- (void)setMemoryConfiguration:(OCCoreMemoryConfiguration)memoryConfiguration
{
	@synchronized (self)
	{
		_memoryConfiguration = memoryConfiguration;

		[_coresByUUID enumerateKeysAndObjectsUsingBlock:^(NSUUID * _Nonnull key, OCCore * _Nonnull core, BOOL * _Nonnull stop) {
			core.memoryConfiguration = memoryConfiguration;
		}];

		switch (memoryConfiguration)
		{
			case OCCoreMemoryConfigurationMinimum:
				[OCSQLiteDB setMemoryLimit:(1 * 1024 * 1024)]; // Set 1 MB memory limit for SQLite;
			break;

			default: break;
		}

	}
}

#pragma mark - Log tagging
+ (NSArray<OCLogTagName> *)logTags
{
	return (@[@"CORE", @"Manager"]);
}

- (NSArray<OCLogTagName> *)logTags
{
	return (@[@"CORE", @"Manager"]);
}

@end

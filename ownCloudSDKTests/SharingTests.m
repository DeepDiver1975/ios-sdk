//
//  SharingTests.m
//  ownCloudSDKTests
//
//  Created by Felix Schwarz on 01.03.19.
//  Copyright © 2019 ownCloud GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ownCloudSDK/ownCloudSDK.h>

#import "OCTestTarget.h"

@interface SharingTests : XCTestCase

@end

@implementation SharingTests

- (void)testPublicShareCreationAndRetrieval
{
	XCTestExpectation *expectConnect = [self expectationWithDescription:@"Connected"];
	XCTestExpectation *expectShareCreated = [self expectationWithDescription:@"Created share"];
	XCTestExpectation *expectSharesRetrieved = [self expectationWithDescription:@"Received single list"];
	XCTestExpectation *expectSingleShareRetrieved = [self expectationWithDescription:@"Received single share"];
	XCTestExpectation *expectShareAmongList = [self expectationWithDescription:@"Share among list of received shares"];
	XCTestExpectation *expectDisconnect = [self expectationWithDescription:@"Disconnected"];
	XCTestExpectation *expectList = [self expectationWithDescription:@"File list retrieved"];
	OCConnection *connection = nil;

	connection = [[OCConnection alloc] initWithBookmark:OCTestTarget.adminBookmark];
	XCTAssert(connection!=nil);

	[connection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
		XCTAssert(error==nil);
		XCTAssert(issue==nil);

		[connection retrieveItemListAtPath:@"/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {
			OCShare *createShare = [OCShare shareWithPublicLinkToPath:items[1].path linkName:@"iOS SDK CI Share" permissions:OCSharePermissionsMaskRead password:@"test" expiration:[NSDate dateWithTimeIntervalSinceNow:24*60*60 * 2]];

			[expectList fulfill];

			[connection createShare:createShare options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
				OCShare *newShare = event.result;

				XCTAssert(event.error==nil);
				XCTAssert(event.result!=nil);

				OCLog(@"Created new share with error=%@, newShare=%@", event.error, event.result);

				XCTAssert([createShare.name 		isEqual:newShare.name]);
				XCTAssert(createShare.permissions 	== newShare.permissions);
				XCTAssert([createShare.itemPath 	isEqual:newShare.itemPath]);

				XCTAssert(newShare.url != nil);
				XCTAssert(newShare.token != nil);
				XCTAssert(newShare.creationDate != nil);
				XCTAssert(createShare.expirationDate.timeIntervalSinceNow >= (24*60*60));

				[expectShareCreated fulfill];

				[connection retrieveShareWithID:newShare.identifier options:nil completionHandler:^(NSError * _Nullable error, OCShare * _Nullable share) {
					OCLog(@"Retrieved new share with error=%@, share=%@", error, share);

					XCTAssert(error==nil);
					XCTAssert(share!=nil);
					XCTAssert(share!=newShare);

					XCTAssert([share.identifier 	isEqual:newShare.identifier]);
					XCTAssert([share.name 		isEqual:newShare.name]);
					XCTAssert(share.permissions 	== newShare.permissions);
					XCTAssert([share.url 		isEqual:newShare.url]);
					XCTAssert([share.token 		isEqual:newShare.token]);
					XCTAssert([share.creationDate 	isEqual:newShare.creationDate]);
					XCTAssert([share.expirationDate isEqual:newShare.expirationDate]);
					XCTAssert([share.itemPath 	isEqual:newShare.itemPath]);

					[expectSingleShareRetrieved fulfill];

					if (error == nil)
					{
						[connection retrieveSharesWithScope:OCConnectionShareScopeSharedByUser forItem:nil options:nil completionHandler:^(NSError *error, NSArray<OCShare *> *shares) {
							OCLogDebug(@"retrieveSharesWithScope: error=%@, shares=%@", error, shares);

							[expectSharesRetrieved fulfill];

							XCTAssert(error==nil);
							XCTAssert(shares!=nil);
							XCTAssert(shares.count>0);

							for (OCShare *share in shares)
							{
								if ([share.identifier isEqual:newShare.identifier])
								{
									[expectShareAmongList fulfill];

									XCTAssert([share.identifier 	isEqual:newShare.identifier]);
									XCTAssert([share.name 		isEqual:newShare.name]);
									XCTAssert(share.permissions 	== newShare.permissions);
									XCTAssert([share.url 		isEqual:newShare.url]);
									XCTAssert([share.token 		isEqual:newShare.token]);
									XCTAssert([share.creationDate 	isEqual:newShare.creationDate]);
									XCTAssert([share.expirationDate isEqual:newShare.expirationDate]);
									XCTAssert([share.itemPath 	isEqual:newShare.itemPath]);
								}
							}

							[connection deleteShare:newShare resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
								OCLogDebug(@"deleteShare: error=%@", event.error);

								XCTAssert(event.error==nil);

								[connection retrieveShareWithID:newShare.identifier options:nil completionHandler:^(NSError * _Nullable error, OCShare * _Nullable share) {
									OCLogDebug(@"retrieveShareWithID (after deletion): error=%@, share=%@", error, share);

									XCTAssert([error isOCErrorWithCode:OCErrorShareNotFound]);
									XCTAssert(share==nil);

									[connection disconnectWithCompletionHandler:^{
										[expectDisconnect fulfill];
									}];
								}];
							} userInfo:nil ephermalUserInfo:nil]];
						}];
					}
				}];
			} userInfo:nil ephermalUserInfo:nil]];
		}];
		[expectConnect fulfill];
	}];

	[self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testPublicShareCreationAndUpdate
{
	XCTestExpectation *expectConnect = [self expectationWithDescription:@"Connected"];
	XCTestExpectation *expectShareCreated = [self expectationWithDescription:@"Created share"];
	XCTestExpectation *expectSingleShareRetrieved = [self expectationWithDescription:@"Received single share"];
	XCTestExpectation *expectDisconnect = [self expectationWithDescription:@"Disconnected"];
	XCTestExpectation *expectList = [self expectationWithDescription:@"File list retrieved"];
	OCConnection *connection = nil;

	connection = [[OCConnection alloc] initWithBookmark:OCTestTarget.adminBookmark];
	XCTAssert(connection!=nil);

	[connection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
		XCTAssert(error==nil);
		XCTAssert(issue==nil);

		[connection retrieveItemListAtPath:@"/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {
			OCShare *createShare = [OCShare shareWithPublicLinkToPath:items[1].path linkName:@"iOS SDK CI Share" permissions:OCSharePermissionsMaskRead password:@"test" expiration:[NSDate dateWithTimeIntervalSinceNow:24*60*60 * 2]];

			[expectList fulfill];

			[connection createShare:createShare options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
				OCShare *newShare = event.result;

				XCTAssert(event.error==nil);
				XCTAssert(event.result!=nil);

				OCLog(@"Created new share with error=%@, newShare=%@", event.error, event.result);

				XCTAssert([createShare.name 		isEqual:newShare.name]);
				XCTAssert(createShare.permissions 	== newShare.permissions);
				XCTAssert([createShare.itemPath 	isEqual:newShare.itemPath]);

				XCTAssert(newShare.url != nil);
				XCTAssert(newShare.token != nil);
				XCTAssert(newShare.creationDate != nil);
				XCTAssert(createShare.expirationDate.timeIntervalSinceNow >= (24*60*60));

				[expectShareCreated fulfill];

				[connection updateShare:newShare afterPerformingChanges:^(OCShare * _Nonnull share) {
					share.name = @"iOS SDK CI Share (updated)";
					share.permissions = OCSharePermissionsMaskRead|OCSharePermissionsMaskCreate|OCSharePermissionsMaskUpdate|OCSharePermissionsMaskDelete;
					share.password = @"testpassword";
					share.expirationDate = [NSDate dateWithTimeIntervalSinceNow:(24*60*60 * 14)];
				} resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
					OCLog(@"Updated share with error=%@, share=%@", event.error, event.result);

					[connection updateShare:newShare afterPerformingChanges:^(OCShare * _Nonnull share) {
						// Change nothing => should return immediately
					} resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
						XCTAssert(event.error == nil);

						[connection retrieveShareWithID:newShare.identifier options:nil completionHandler:^(NSError * _Nullable error, OCShare * _Nullable share) {
							XCTAssert(error==nil);
							XCTAssert(share!=nil);
							XCTAssert(share!=newShare);

							OCLog(@"Retrieved updated share with error=%@, share=%@", error, share);

							[expectSingleShareRetrieved fulfill];

							XCTAssert([share.identifier 	isEqual:newShare.identifier]);
							XCTAssert([share.name 		isEqual:@"iOS SDK CI Share (updated)"]);
							XCTAssert(share.permissions == (OCSharePermissionsMaskRead|OCSharePermissionsMaskCreate|OCSharePermissionsMaskUpdate|OCSharePermissionsMaskDelete));
							XCTAssert([share.url 		isEqual:newShare.url]);
							XCTAssert([share.token 		isEqual:newShare.token]);
							XCTAssert([share.creationDate 	isEqual:newShare.creationDate]);
							XCTAssert(share.expirationDate.timeIntervalSinceNow >= (24*60*60*12));
							XCTAssert([share.itemPath 	isEqual:newShare.itemPath]);

							[connection deleteShare:newShare resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
								OCLogDebug(@"deleteShare: error=%@", event.error);

								XCTAssert(event.error==nil);

								[connection retrieveShareWithID:newShare.identifier options:nil completionHandler:^(NSError * _Nullable error, OCShare * _Nullable share) {
									OCLogDebug(@"retrieveShareWithID (after deletion): error=%@, share=%@", error, share);

									XCTAssert([error isOCErrorWithCode:OCErrorShareNotFound]);
									XCTAssert(share==nil);

									[connection disconnectWithCompletionHandler:^{
										[expectDisconnect fulfill];
									}];
								}];
							} userInfo:nil ephermalUserInfo:nil]];
						}];
					} userInfo:nil ephermalUserInfo:nil]];
				} userInfo:nil ephermalUserInfo:nil]];
			} userInfo:nil ephermalUserInfo:nil]];
		}];
		[expectConnect fulfill];
	}];

	[self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testUserToUserSharing
{
	XCTestExpectation *expectConnect = [self expectationWithDescription:@"Connected"];
	XCTestExpectation *expectShareCreated = [self expectationWithDescription:@"Created share"];
	XCTestExpectation *expectShareRetrieved = [self expectationWithDescription:@"Share retrieved"];
	XCTestExpectation *expectShareRetrievedInRootSubitems = [self expectationWithDescription:@"Share retrieved in root subitems"];
	XCTestExpectation *expectRecipientSharesRetrieved = [self expectationWithDescription:@"Recipient shares retrieved"];
	XCTestExpectation *expectRecipientSharesContainNewShare = [self expectationWithDescription:@"Recipient shares contain new share"];
	XCTestExpectation *expectDisconnect = [self expectationWithDescription:@"Disconnected"];
	XCTestExpectation *expectList = [self expectationWithDescription:@"File list retrieved"];
	OCConnection *connection = nil;

	OCConnection *recipientConnection = nil;

	connection = [[OCConnection alloc] initWithBookmark:OCTestTarget.adminBookmark];
	XCTAssert(connection!=nil);

	recipientConnection = [[OCConnection alloc] initWithBookmark:OCTestTarget.userBookmark];
	XCTAssert(recipientConnection!=nil);

	[connection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
		XCTAssert(error==nil);
		XCTAssert(issue==nil);

		[connection retrieveItemListAtPath:@"/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {
			OCItem *shareItem = items.lastObject;
			OCItem *rootItem = items.firstObject;

			OCShare *createShare = [OCShare shareWithRecipient:[OCRecipient recipientWithUser:[OCUser userWithUserName:OCTestTarget.userLogin displayName:nil]] path:shareItem.path permissions:OCSharePermissionsMaskRead expiration:nil];

			[expectList fulfill];

			[connection createShare:createShare options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
				OCShare *newShare = event.result;

				XCTAssert(event.error==nil);
				XCTAssert(event.result!=nil);

				OCLog(@"Created new share with error=%@, newShare=%@", event.error, event.result);

				XCTAssert(createShare.recipient 	!= nil);
				XCTAssert(createShare.recipient.user 	!= nil);
				XCTAssert(!createShare.recipient.user.isRemote);
				XCTAssert(createShare.recipient.user.isRemote == newShare.recipient.user.isRemote);
				XCTAssert(createShare.permissions 	== newShare.permissions);
				XCTAssert([createShare.itemPath 	isEqual:newShare.itemPath]);

				XCTAssert(newShare.token == nil);
				XCTAssert(newShare.creationDate != nil);

				[expectShareCreated fulfill];

				[connection retrieveSharesWithScope:OCConnectionShareScopeItem forItem:shareItem options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
					XCTAssert(error==nil);
					XCTAssert(shares.count > 0);

					OCLog(@"Retrieved shares: %@", shares);

					for (OCShare *share in shares)
					{
						if ([share.identifier isEqual:newShare.identifier])
						{
							[expectShareRetrieved fulfill];
						}
					}

					[connection retrieveSharesWithScope:OCConnectionShareScopeSubItems forItem:rootItem options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
						OCLog(@"Retrieved shares of %@: %@", rootItem.path, shares);

						for (OCShare *share in shares)
						{
							if ([share.identifier isEqual:newShare.identifier])
							{
								[expectShareRetrievedInRootSubitems fulfill];
							}
						}

						[recipientConnection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
							[recipientConnection retrieveSharesWithScope:OCConnectionShareScopeSharedWithUser forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
								XCTAssert(error == nil);
								XCTAssert(shares.count > 0);

								OCLog(@"Recipient shares: %@", shares);

								[expectRecipientSharesRetrieved fulfill];

								for (OCShare *share in shares)
								{
									if ([share.identifier isEqual:newShare.identifier])
									{
										[expectRecipientSharesContainNewShare fulfill];

										[connection deleteShare:newShare resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
											XCTAssert(event.error == nil);

											[recipientConnection retrieveSharesWithScope:OCConnectionShareScopeSharedWithUser forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
												XCTAssert(error==nil);

												OCLog(@"Recipient shares after deletion: %@", shares);

												for (OCShare *share in shares)
												{
													if ([share.identifier isEqual:newShare.identifier])
													{
														XCTFail(@"Deleted share still around");
													}
												}

												[recipientConnection disconnectWithCompletionHandler:^{
													[connection disconnectWithCompletionHandler:^{
														[expectDisconnect fulfill];
													}];
												}];
											}];
										} userInfo:nil ephermalUserInfo:nil]];

										break;
									}
								}
							}];
						}];
					}];
				}];
			} userInfo:nil ephermalUserInfo:nil]];
		}];
		[expectConnect fulfill];
	}];

	[self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testUserToUserToUserResharing
{
	XCTestExpectation *expectConnect = [self expectationWithDescription:@"Connected"];
	XCTestExpectation *expectShareCreated = [self expectationWithDescription:@"Created share"];
	XCTestExpectation *expectShareRetrieved = [self expectationWithDescription:@"Share retrieved"];
	XCTestExpectation *expectShareRetrievedInRootSubitems = [self expectationWithDescription:@"Share retrieved in root subitems"];
	XCTestExpectation *expectRecipientSharesRetrieved = [self expectationWithDescription:@"Recipient shares retrieved"];
	XCTestExpectation *expectRecipientSharesContainNewShare = [self expectationWithDescription:@"Recipient shares contain new share"];
	XCTestExpectation *expectReshare = [self expectationWithDescription:@"Shares contain reshare"];
	XCTestExpectation *expectReshareRecipientSeesReshare = [self expectationWithDescription:@"Reshare recipient sees reshare"];
	XCTestExpectation *expectOriginalShare = [self expectationWithDescription:@"Shares contain original share"];
	XCTestExpectation *expectDisconnect = [self expectationWithDescription:@"Disconnected"];
	XCTestExpectation *expectList = [self expectationWithDescription:@"File list retrieved"];
	OCConnection *connection = nil;
	OCConnection *recipientConnection = nil;
	OCConnection *reshareRecipientConnection = nil;

	connection = [[OCConnection alloc] initWithBookmark:OCTestTarget.adminBookmark];
	XCTAssert(connection!=nil);

	recipientConnection = [[OCConnection alloc] initWithBookmark:OCTestTarget.userBookmark];
	XCTAssert(recipientConnection!=nil);

	reshareRecipientConnection = [[OCConnection alloc] initWithBookmark:OCTestTarget.demoBookmark];
	XCTAssert(reshareRecipientConnection!=nil);

	[connection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
		XCTAssert(error==nil);
		XCTAssert(issue==nil);

		[connection retrieveItemListAtPath:@"/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {
			OCItem *shareItem = items.lastObject;
			OCItem *rootItem = items.firstObject;

			OCShare *createShare = [OCShare shareWithRecipient:[OCRecipient recipientWithUser:[OCUser userWithUserName:OCTestTarget.userLogin displayName:nil]] path:shareItem.path permissions:OCSharePermissionsMaskRead|OCSharePermissionsMaskShare expiration:nil];

			[expectList fulfill];

			[connection createShare:createShare options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
				OCShare *newShare = event.result;

				XCTAssert(event.error==nil);
				XCTAssert(event.result!=nil);

				OCLog(@"Created new share with error=%@, newShare=%@", event.error, event.result);

				XCTAssert(createShare.recipient 	!= nil);
				XCTAssert(createShare.recipient.user 	!= nil);
				XCTAssert(!createShare.recipient.user.isRemote);
				XCTAssert(createShare.recipient.user.isRemote == newShare.recipient.user.isRemote);
				XCTAssert(createShare.permissions 	== newShare.permissions);
				XCTAssert([createShare.itemPath 	isEqual:newShare.itemPath]);

				XCTAssert(newShare.token == nil);
				XCTAssert(newShare.creationDate != nil);

				[expectShareCreated fulfill];

				[connection retrieveSharesWithScope:OCConnectionShareScopeItem forItem:shareItem options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
					XCTAssert(error==nil);
					XCTAssert(shares.count > 0);

					OCLog(@"Retrieved shares: %@", shares);

					for (OCShare *share in shares)
					{
						if ([share.identifier isEqual:newShare.identifier])
						{
							[expectShareRetrieved fulfill];
						}
					}

					[connection retrieveSharesWithScope:OCConnectionShareScopeSubItems forItem:rootItem options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
						OCLog(@"Retrieved shares of %@: %@", rootItem.path, shares);

						for (OCShare *share in shares)
						{
							if ([share.identifier isEqual:newShare.identifier])
							{
								[expectShareRetrievedInRootSubitems fulfill];
							}
						}

						[recipientConnection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
							[recipientConnection retrieveSharesWithScope:OCConnectionShareScopeSharedWithUser forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
								XCTAssert(error == nil);
								XCTAssert(shares.count > 0);

								OCLog(@"Recipient shares: %@", shares);

								[expectRecipientSharesRetrieved fulfill];

								for (OCShare *share in shares)
								{
									if ([share.identifier isEqual:newShare.identifier])
									{
										[expectRecipientSharesContainNewShare fulfill];

										OCShare *createReshare = [OCShare shareWithRecipient:[OCRecipient recipientWithUser:[OCUser userWithUserName:OCTestTarget.demoLogin displayName:nil]] path:share.itemPath permissions:OCSharePermissionsMaskRead|OCSharePermissionsMaskShare expiration:nil];

										[recipientConnection createShare:createReshare options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
											OCShare *newReshare = event.result;

											XCTAssert(event.error == nil);
											XCTAssert(event.result != nil);

											OCLog(@"Created re-share: %@", newReshare);

											[connection retrieveSharesWithScope:OCConnectionShareScopeItemWithReshares forItem:shareItem options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {

												XCTAssert(error==nil);
												XCTAssert(shares!=nil);

												OCLog(@"Retrieved items including re-share: %@", shares);

												for (OCShare *share in shares)
												{
													if ([share.identifier isEqual:newShare.identifier])
													{
														[expectOriginalShare fulfill];
													}

													if ([share.identifier isEqual:newReshare.identifier])
													{
														[expectReshare fulfill];
													}
												}

												[reshareRecipientConnection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
													[reshareRecipientConnection retrieveSharesWithScope:OCConnectionShareScopeSharedWithUser forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
														XCTAssert(error==nil);
														XCTAssert(shares!=nil);

														for (OCShare *share in shares)
														{
															if ([share.identifier isEqual:newReshare.identifier])
															{
																[expectReshareRecipientSeesReshare fulfill];
															}
														}

														[recipientConnection deleteShare:newReshare resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
															XCTAssert(event.error == nil);

															[connection deleteShare:newShare resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
																XCTAssert(event.error == nil);

																[recipientConnection retrieveSharesWithScope:OCConnectionShareScopeSharedWithUser forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
																	XCTAssert(error==nil);

																	OCLog(@"Recipient shares after deletion: %@", shares);

																	for (OCShare *share in shares)
																	{
																		if ([share.identifier isEqual:newShare.identifier])
																		{
																			XCTFail(@"Deleted share still around");
																		}

																		if ([share.identifier isEqual:newReshare.identifier])
																		{
																			XCTFail(@"Re-share of deleted share still around");
																		}
																	}

																	[reshareRecipientConnection disconnectWithCompletionHandler:^{
																		[recipientConnection disconnectWithCompletionHandler:^{
																			[connection disconnectWithCompletionHandler:^{
																				[expectDisconnect fulfill];
																			}];
																		}];
																	}];
																}];
															} userInfo:nil ephermalUserInfo:nil]];
														} userInfo:nil ephermalUserInfo:nil]];
													}];
												}];
											}];
										} userInfo:nil ephermalUserInfo:nil]];

										break;
									}
								}
							}];
						}];
					}];
				}];
			} userInfo:nil ephermalUserInfo:nil]];
		}];
		[expectConnect fulfill];
	}];

	[self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testFederatedSharing
{
	XCTestExpectation *expectConnect = [self expectationWithDescription:@"Connected"];
	XCTestExpectation *expectShareCreated = [self expectationWithDescription:@"Created share"];
	XCTestExpectation *expectShareRetrieved = [self expectationWithDescription:@"Share retrieved"];
	XCTestExpectation *expectPendingSharesRetrieved = [self expectationWithDescription:@"Pending shares retrieved"];
	XCTestExpectation *expectPendingSharesContainNewShare = [self expectationWithDescription:@"Pending shares contain new share"];
	XCTestExpectation *expectDisconnect = [self expectationWithDescription:@"Disconnected"];
	XCTestExpectation *expectList = [self expectationWithDescription:@"File list retrieved"];
	OCConnection *connection = nil;

	OCConnection *recipientConnection = nil;

	connection = [[OCConnection alloc] initWithBookmark:OCTestTarget.adminBookmark];
	XCTAssert(connection!=nil);

	recipientConnection = [[OCConnection alloc] initWithBookmark:OCTestTarget.federatedBookmark];
	XCTAssert(recipientConnection!=nil);

	[connection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
		XCTAssert(error==nil);
		XCTAssert(issue==nil);

		NSString *remoteUser = OCTestTarget.federatedLogin;
		NSString *remoteHost = OCTestTarget.federatedTargetURL.host;

		NSString *remoteUserIDFull = [remoteUser stringByAppendingFormat:@"@%@", remoteHost];

		[connection retrieveItemListAtPath:@"/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {
			OCShare *createShare = [OCShare shareWithRecipient:[OCRecipient recipientWithUser:[OCUser userWithUserName:remoteUserIDFull displayName:nil]] path:items[1].path permissions:OCSharePermissionsMaskRead expiration:nil];

			[expectList fulfill];

			[connection createShare:createShare options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
				OCShare *newShare = event.result;

				XCTAssert(event.error==nil);
				XCTAssert(event.result!=nil);

				OCLog(@"Created new share with error=%@, newShare=%@", event.error, event.result);

				XCTAssert(createShare.recipient 	!= nil);
				XCTAssert(createShare.recipient.user 	!= nil);
				XCTAssert(createShare.recipient.user.isRemote == newShare.recipient.user.isRemote);
				XCTAssert([createShare.recipient.user.remoteUserName isEqual:newShare.recipient.user.remoteUserName]);
				XCTAssert([createShare.recipient.user.remoteHost isEqual:newShare.recipient.user.remoteHost]);
				XCTAssert([createShare.recipient.user.remoteUserName isEqual:remoteUser]);
				XCTAssert([createShare.recipient.user.remoteHost isEqual:remoteHost]);
				XCTAssert(createShare.permissions 	== newShare.permissions);
				XCTAssert([createShare.itemPath 	isEqual:newShare.itemPath]);

				XCTAssert(newShare.token != nil);
				XCTAssert(newShare.creationDate != nil);

				[expectShareCreated fulfill];

				[connection retrieveSharesWithScope:OCConnectionShareScopeSharedByUser forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
					XCTAssert(error==nil);
					XCTAssert(shares.count > 0);

					OCLog(@"Retrieved shares: %@", shares);

					for (OCShare *share in shares)
					{
						if ([share.token isEqual:newShare.token])
						{
							[expectShareRetrieved fulfill];
						}
					}

					[recipientConnection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
						[recipientConnection retrieveSharesWithScope:OCConnectionShareScopePendingCloudShares forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
							XCTAssert(error == nil);
							XCTAssert(shares.count > 0);

							OCLog(@"Pending shares: %@", shares);

							[expectPendingSharesRetrieved fulfill];

							for (OCShare *share in shares)
							{
								if ([share.token isEqual:newShare.token])
								{
									[expectPendingSharesContainNewShare fulfill];
									XCTAssert((share.accepted!=nil) && !share.accepted.boolValue);

									[recipientConnection makeDecisionOnShare:share accept:YES resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
										OCLog(@"Accepted share: %@, error=%@, result=%@", event, event.error, event.result);

										XCTAssert(event.error == nil);

										sleep(2); // Apparently accepted shares /can/ be slow to be updated :-/

										[recipientConnection retrieveSharesWithScope:OCConnectionShareScopeAcceptedCloudShares forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
											OCShare *deleteShare = nil;

											XCTAssert(error==nil);
											XCTAssert(shares.count > 0);

											OCLog(@"Accepted shares: %@", shares);

											for (OCShare *share in shares)
											{
												if ([share.token isEqual:newShare.token])
												{
													deleteShare = share;
													XCTAssert(share.accepted.boolValue);

												}
											}

											if (deleteShare != nil)
											{
												[recipientConnection deleteShare:deleteShare resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
													XCTAssert(event.error == nil);

													sleep(2); // Apparently accepted shares /can/ be slow to be updated :-/

													[recipientConnection retrieveSharesWithScope:OCConnectionShareScopeAcceptedCloudShares forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
														XCTAssert(error==nil);

														OCLog(@"Accepted shares: %@", shares);

														for (OCShare *share in shares)
														{
															if ([share.token isEqual:newShare.token])
															{
																XCTFail(@"Deleted share still around");
															}
														}

														[recipientConnection disconnectWithCompletionHandler:^{
															[connection disconnectWithCompletionHandler:^{
																[expectDisconnect fulfill];
															}];
														}];
													}];
												} userInfo:nil ephermalUserInfo:nil]];
											}
										}];
									} userInfo:nil ephermalUserInfo:nil]];

									break;
								}
							}
						}];
					}];
				}];
			} userInfo:nil ephermalUserInfo:nil]];
		}];
		[expectConnect fulfill];
	}];

	[self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testSharingErrors
{
	XCTestExpectation *expectConnect = [self expectationWithDescription:@"Connected"];
//	XCTestExpectation *expectShareCreated = [self expectationWithDescription:@"Created share"];
//	XCTestExpectation *expectShareRetrieved = [self expectationWithDescription:@"Share retrieved"];
//	XCTestExpectation *expectShareRetrievedInRootSubitems = [self expectationWithDescription:@"Share retrieved in root subitems"];
//	XCTestExpectation *expectRecipientSharesRetrieved = [self expectationWithDescription:@"Recipient shares retrieved"];
//	XCTestExpectation *expectRecipientSharesContainNewShare = [self expectationWithDescription:@"Recipient shares contain new share"];
	XCTestExpectation *expectDisconnect = [self expectationWithDescription:@"Disconnected"];
	XCTestExpectation *expectList = [self expectationWithDescription:@"File list retrieved"];
	OCConnection *connection = nil;

	OCConnection *recipientConnection = nil;

	connection = [[OCConnection alloc] initWithBookmark:OCTestTarget.adminBookmark];
	XCTAssert(connection!=nil);

	recipientConnection = [[OCConnection alloc] initWithBookmark:OCTestTarget.userBookmark];
	XCTAssert(recipientConnection!=nil);

	[connection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
		XCTAssert(error==nil);
		XCTAssert(issue==nil);

		[connection retrieveItemListAtPath:@"/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {

			dispatch_group_t waitForCompletion = dispatch_group_create();

//			OCItem *shareItem = items.lastObject;
			OCItem *rootItem = items.firstObject;

			OCShare *createRootShare = [OCShare shareWithRecipient:[OCRecipient recipientWithUser:[OCUser userWithUserName:OCTestTarget.userLogin displayName:nil]] path:rootItem.path permissions:OCSharePermissionsMaskRead expiration:nil];

			[expectList fulfill];

			// Can't share root folder
			dispatch_group_enter(waitForCompletion);

			[connection createShare:createRootShare options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
				XCTAssert(event.error != nil); // Can't share root folder error
				dispatch_group_leave(waitForCompletion);
			} userInfo:nil ephermalUserInfo:nil]];

			// Retrieve shares for item without item
			dispatch_group_enter(waitForCompletion);

			[connection retrieveSharesWithScope:OCConnectionShareScopeItem forItem:nil options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
				XCTAssert(error != nil); // Scope requires item
				XCTAssert([error isOCErrorWithCode:OCErrorInsufficientParameters]);
				dispatch_group_leave(waitForCompletion);
			}];

			// Retrieve shares for non-existant item
			OCItem *nonexistantItem = [OCItem placeholderItemOfType:OCItemTypeFile];
			nonexistantItem.path = @"/does.not.exist";

			dispatch_group_enter(waitForCompletion);

			[connection retrieveSharesWithScope:OCConnectionShareScopeItem forItem:nonexistantItem options:nil completionHandler:^(NSError * _Nullable error, NSArray<OCShare *> * _Nullable shares) {
				XCTAssert(error != nil); // Scope requires item
				XCTAssert([error isOCErrorWithCode:OCErrorShareItemNotFound]);
				dispatch_group_leave(waitForCompletion);
			}];

			dispatch_group_notify(waitForCompletion, dispatch_get_main_queue(), ^{
				[connection disconnectWithCompletionHandler:^{
					[expectDisconnect fulfill];
				}];
			});
		}];
		[expectConnect fulfill];
	}];

	[self waitForExpectationsWithTimeout:60 handler:nil];
}

- (void)testSharesRetrieval
{
	XCTestExpectation *expectConnect = [self expectationWithDescription:@"Connected"];
	XCTestExpectation *expectShareCreated = [self expectationWithDescription:@"Created share"];
	XCTestExpectation *expectSharesRetrieved = [self expectationWithDescription:@"Received share list"];
	XCTestExpectation *expectDisconnect = [self expectationWithDescription:@"Disconnected"];
	XCTestExpectation *expectLists = [self expectationWithDescription:@"Disconnected"];
	OCConnection *connection = nil;

	connection = [[OCConnection alloc] initWithBookmark:OCTestTarget.adminBookmark];
	XCTAssert(connection!=nil);

	[connection connectWithCompletionHandler:^(NSError *error, OCIssue *issue) {
		XCTAssert(error==nil);
		XCTAssert(issue==nil);

		[connection retrieveItemListAtPath:@"/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {
			[connection createShare:[OCShare shareWithPublicLinkToPath:items[1].path linkName:@"iOS SDK CI" permissions:OCSharePermissionsMaskRead password:@"test" expiration:[NSDate dateWithTimeIntervalSinceNow:24*60*60 * 2]] options:nil resultTarget:[OCEventTarget eventTargetWithEphermalEventHandlerBlock:^(OCEvent * _Nonnull event, id  _Nonnull sender) {
				OCLog(@"error=%@, newShare=%@", event.error, event.result);

				[expectShareCreated fulfill];

				[connection retrieveItemListAtPath:@"/Documents/" depth:1 completionHandler:^(NSError *error, NSArray<OCItem *> *items) {
					[expectLists fulfill];

					if (error == nil)
					{
						[connection retrieveSharesWithScope:OCConnectionShareScopeSharedByUser forItem:nil options:nil completionHandler:^(NSError *error, NSArray<OCShare *> *shares) {
							OCLogDebug(@"error=%@, shares=%@", error, shares);

							[expectSharesRetrieved fulfill];

							[connection disconnectWithCompletionHandler:^{
								[expectDisconnect fulfill];
							}];
						}];
					}
				}];
			} userInfo:nil ephermalUserInfo:nil]];
		}];
		[expectConnect fulfill];
	}];

	[self waitForExpectationsWithTimeout:60 handler:nil];
}

@end

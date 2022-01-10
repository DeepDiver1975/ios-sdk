//
//  OCResourceSourceStorage.m
//  ownCloudSDK
//
//  Created by Felix Schwarz on 03.01.22.
//  Copyright © 2022 ownCloud GmbH. All rights reserved.
//

/*
 * Copyright (C) 2022, ownCloud GmbH.
 *
 * This code is covered by the GNU Public License Version 3.
 *
 * For distribution utilizing Apple mechanisms please see https://owncloud.org/contribute/iOS-license-exception/
 * You should have received a copy of this license along with this program. If not, see <http://www.gnu.org/licenses/gpl-3.0.en.html>.
 *
 */

#import "OCResourceSourceStorage.h"
#import "OCResourceManager.h"
#import "OCMacros.h"
#import "OCItem.h"

@implementation OCResourceSourceStorage

- (OCResourceType)type
{
	return (OCResourceTypeAny);
}

- (OCResourceSourceIdentifier)identifier
{
	return (OCResourceSourceIdentifierStorage);
}

- (OCResourceQuality)qualityForRequest:(OCResourceRequest *)request
{
	if ((request.maxPixelSize.width > 0) && (request.maxPixelSize.height > 0))
	{
		OCItem *item;

		if ((item = OCTypedCast(request.reference, OCItem)) != nil)
		{
			if (item.type == OCItemTypeFile)
			{
				return (OCResourceQualityCached);
			}
		}
	}

	return (OCResourceQualityNone);
}

- (void)provideResourceForRequest:(OCResourceRequest *)request shouldContinueHandler:(OCResourceSourceShouldContinueHandler)shouldContinueHandler resultHandler:(OCResourceSourceResultHandler)resultHandler
{
	[self.manager.storage retrieveResourceForRequest:request completionHandler:^(NSError * _Nullable error, OCResource * _Nullable resource) {
		resource.originSourceIdentifier = OCResourceSourceIdentifierStorage;

		resultHandler(error, resource);
	}];
}

@end

OCResourceSourceIdentifier OCResourceSourceIdentifierStorage = @"vault.storage";

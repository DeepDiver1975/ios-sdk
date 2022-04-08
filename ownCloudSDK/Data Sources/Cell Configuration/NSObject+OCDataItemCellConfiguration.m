//
//  NSObject+OCDataCellConfiguration.m
//  ownCloudSDK
//
//  Created by Felix Schwarz on 07.04.22.
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

#import "NSObject+OCDataItemCellConfiguration.h"
#import <objc/runtime.h>

static NSString *sOCDataCellConfigurationAssociatedObjectKey = @"OCDataCellConfiguration";

@implementation NSObject (OCDataItemCellConfiguration)

- (OCDataItemCellConfiguration *)ocDataItemCellConfiguration
{
	return (objc_getAssociatedObject(self, (__bridge const void *)sOCDataCellConfigurationAssociatedObjectKey));
}

- (void)setOcDataItemCellConfiguration:(OCDataItemCellConfiguration *)ocDataItemCellConfiguration
{
	objc_setAssociatedObject(self, (__bridge const void *)sOCDataCellConfigurationAssociatedObjectKey, ocDataItemCellConfiguration, OBJC_ASSOCIATION_RETAIN);
}

@end

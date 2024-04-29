//
//  OCSignal.h
//  ownCloudSDK
//
//  Created by Felix Schwarz on 27.09.20.
//  Copyright © 2020 ownCloud GmbH. All rights reserved.
//

/*
 * Copyright (C) 2020, ownCloud GmbH.
 *
 * This code is covered by the GNU Public License Version 3.
 *
 * For distribution utilizing Apple mechanisms please see https://owncloud.org/contribute/iOS-license-exception/
 * You should have received a copy of this license along with this program. If not, see <http://www.gnu.org/licenses/gpl-3.0.en.html>.
 *
 */

#import <Foundation/Foundation.h>
#import "OCTypes.h"

typedef NSString* OCSignalUUID;

NS_ASSUME_NONNULL_BEGIN

@interface OCSignal : NSObject <NSSecureCoding>

+ (OCSignalUUID)generateUUID; //!< Generates a signal UUID 

@property(readonly,strong) OCSignalUUID uuid;
@property(readonly,nullable,strong) OCCodableDict payload;

- (instancetype)initWithUUID:(OCSignalUUID)uuid payload:(nullable OCCodableDict)payload;

@end

NS_ASSUME_NONNULL_END

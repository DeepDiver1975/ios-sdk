//
//  OCIssueChoice.h
//  ownCloudSDK
//
//  Created by Felix Schwarz on 15.06.18.
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

#import <Foundation/Foundation.h>
#import "OCIssue.h"

typedef void(^OCIssueChoiceHandler)(OCIssue *issue, OCIssueChoice *choice);

typedef NS_ENUM(NSInteger,OCIssueChoiceType)
{
	OCIssueChoiceTypeCancel,
	OCIssueChoiceTypeRegular,
	OCIssueChoiceTypeDefault,
	OCIssueChoiceTypeDestructive
};

@interface OCIssueChoice : NSObject

@property(assign) OCIssueChoiceType type;

@property(strong) NSString *identifier;

@property(strong) NSString *label;
@property(copy) OCIssueChoiceHandler choiceHandler;

@property(strong) id<NSObject> userInfo;

+ (instancetype)choiceWithType:(OCIssueChoiceType)type identifier:(NSString *)identifier label:(NSString *)label userInfo:(id<NSObject>)userInfo handler:(OCIssueChoiceHandler)handler;

+ (instancetype)choiceWithType:(OCIssueChoiceType)type label:(NSString *)label handler:(OCIssueChoiceHandler)handler;

@end

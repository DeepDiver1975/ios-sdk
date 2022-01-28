//
// OCGODataErrorDetail.m
// Autogenerated / Managed by ocapigen
// Copyright (C) 2022 ownCloud GmbH. All rights reserved.
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

// occgen: includes
#import "OCGODataErrorDetail.h"

// occgen: type start
@implementation OCGODataErrorDetail

// occgen: type serialization
+ (nullable instancetype)decodeGraphData:(OCGraphData)structure context:(nullable OCGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	OCGODataErrorDetail *instance = [self new];

	OCG_SET_REQ(code, NSString, Nil);
	OCG_SET_REQ(message, NSString, Nil);
	OCG_SET(target, NSString, Nil);

	return (instance);
}

// occgen: type protected {"locked":true}


// occgen: type end
@end


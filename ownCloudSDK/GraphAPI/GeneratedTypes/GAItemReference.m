//
// GAItemReference.m
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
#import "GAItemReference.h"

// occgen: type start
@implementation GAItemReference

// occgen: type serialization
+ (nullable instancetype)decodeGraphData:(GAGraphData)structure context:(nullable GAGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	GAItemReference *instance = [self new];

	GA_SET(driveId, NSString, Nil);
	GA_SET(driveType, NSString, Nil);
	GA_MAP(identifier, "id", NSString, Nil);
	GA_SET(name, NSString, Nil);
	GA_SET(path, NSString, Nil);
	GA_SET(shareId, NSString, Nil);

	return (instance);
}

// occgen: type protected {"locked":true}


// occgen: type end
@end


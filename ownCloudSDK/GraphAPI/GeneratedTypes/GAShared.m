//
// GAShared.m
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
#import "GAShared.h"
#import "GAIdentitySet.h"

// occgen: type start
@implementation GAShared

// occgen: type serialization
+ (nullable instancetype)decodeGraphData:(GAGraphData)structure context:(nullable GAGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	GAShared *instance = [self new];

	GA_SET(owner, GAIdentitySet, Nil);
	GA_SET(scope, NSString, Nil);
	GA_SET(sharedBy, GAIdentitySet, Nil);
	GA_SET(sharedDateTime, NSDate, Nil);

	return (instance);
}

// occgen: type native deserialization
+ (BOOL)supportsSecureCoding
{
	return (YES);
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]) != nil)
	{
		_owner = [decoder decodeObjectOfClass:GAIdentitySet.class forKey:@"owner"];
		_scope = [decoder decodeObjectOfClass:NSString.class forKey:@"scope"];
		_sharedBy = [decoder decodeObjectOfClass:GAIdentitySet.class forKey:@"sharedBy"];
		_sharedDateTime = [decoder decodeObjectOfClass:NSDate.class forKey:@"sharedDateTime"];
	}

	return (self);
}

// occgen: type native serialization
- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_owner forKey:@"owner"];
	[coder encodeObject:_scope forKey:@"scope"];
	[coder encodeObject:_sharedBy forKey:@"sharedBy"];
	[coder encodeObject:_sharedDateTime forKey:@"sharedDateTime"];
}

// occgen: type debug description
- (NSString *)description
{
	return ([NSString stringWithFormat:@"<%@: %p%@%@%@%@>", NSStringFromClass(self.class), self, ((_owner!=nil) ? [NSString stringWithFormat:@", owner: %@", _owner] : @""), ((_scope!=nil) ? [NSString stringWithFormat:@", scope: %@", _scope] : @""), ((_sharedBy!=nil) ? [NSString stringWithFormat:@", sharedBy: %@", _sharedBy] : @""), ((_sharedDateTime!=nil) ? [NSString stringWithFormat:@", sharedDateTime: %@", _sharedDateTime] : @"")]);
}

// occgen: type protected {"locked":true}


// occgen: type end
@end


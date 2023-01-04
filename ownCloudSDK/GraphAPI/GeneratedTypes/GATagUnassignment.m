//
// GATagUnassignment.m
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
#import "GATagUnassignment.h"

// occgen: type start
@implementation GATagUnassignment

// occgen: type serialization
+ (nullable instancetype)decodeGraphData:(GAGraphData)structure context:(nullable GAGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	GATagUnassignment *instance = [self new];

	GA_SET_REQ(resourceId, NSString, Nil);
	GA_SET_REQ(tags, NSString, NSArray.class);

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
		_resourceId = [decoder decodeObjectOfClass:NSString.class forKey:@"resourceId"];
		_tags = [decoder decodeObjectOfClasses:[NSSet setWithObjects: NSString.class, NSArray.class, nil] forKey:@"tags"];
	}

	return (self);
}

// occgen: type native serialization
- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_resourceId forKey:@"resourceId"];
	[coder encodeObject:_tags forKey:@"tags"];
}

// occgen: type debug description
- (NSString *)description
{
	return ([NSString stringWithFormat:@"<%@: %p%@%@>", NSStringFromClass(self.class), self, ((_resourceId!=nil) ? [NSString stringWithFormat:@", resourceId: %@", _resourceId] : @""), ((_tags!=nil) ? [NSString stringWithFormat:@", tags: %@", _tags] : @"")]);
}

// occgen: type protected {"locked":true}


// occgen: type end
@end


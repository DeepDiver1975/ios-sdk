//
// GAODataError.m
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
#import "GAODataError.h"
#import "GAODataErrorMain.h"
#import "NSError+OCError.h"

// occgen: type start
@implementation GAODataError

// occgen: type serialization
+ (nullable instancetype)decodeGraphData:(GAGraphData)structure context:(nullable GAGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	GAODataError *instance = [self new];

	GA_SET_REQ(error, GAODataErrorMain, Nil);

	return (instance);
}

// occgen: type protected {"locked":true}
- (NSError *)nativeError
{
	NSError *error = _error.nativeError;
	return ((error != nil) ? error : OCError(OCErrorGraphError));
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
		_error = [decoder decodeObjectOfClass:GAODataErrorMain.class forKey:@"error"];
	}

	return (self);
}

// occgen: type native serialization
- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_error forKey:@"error"];
}

// occgen: type debug description
- (NSString *)description
{
	return ([NSString stringWithFormat:@"<%@: %p%@>", NSStringFromClass(self.class), self, ((_error!=nil) ? [NSString stringWithFormat:@", error: %@", _error] : @"")]);
}

// occgen: type end
@end


//
// GADrive.m
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
#import "GADrive.h"
#import "GAQuota.h"
#import "GAUser.h"
#import "GADriveItem.h"
#import "GAIdentitySet.h"
#import "GAItemReference.h"

// occgen: type start
@implementation GADrive

// occgen: type serialization
+ (nullable instancetype)decodeGraphData:(GAGraphData)structure context:(nullable GAGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	GADrive *instance = [self new];

	GA_MAP(identifier, "id", NSString, Nil);
	GA_SET(createdBy, GAIdentitySet, Nil);
	GA_SET(createdDateTime, NSDate, Nil);
	GA_MAP(desc, "description", NSString, Nil);
	GA_SET(eTag, NSString, Nil);
	GA_SET(lastModifiedBy, GAIdentitySet, Nil);
	GA_SET(lastModifiedDateTime, NSDate, Nil);
	GA_SET(name, NSString, Nil);
	GA_SET(parentReference, GAItemReference, Nil);
	GA_SET(webUrl, NSURL, Nil);
	GA_SET(createdByUser, GAUser, Nil);
	GA_SET(lastModifiedByUser, GAUser, Nil);
	GA_SET(driveType, NSString, Nil);
	GA_SET(owner, GAIdentitySet, Nil);
	GA_SET(quota, GAQuota, Nil);
	GA_SET(items, GADriveItem, NSArray.class);
	GA_SET(root, GADriveItem, Nil);
	GA_SET(special, GADriveItem, NSArray.class);

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
		_identifier = [decoder decodeObjectOfClass:NSString.class forKey:@"identifier"];
		_createdBy = [decoder decodeObjectOfClass:GAIdentitySet.class forKey:@"createdBy"];
		_createdDateTime = [decoder decodeObjectOfClass:NSDate.class forKey:@"createdDateTime"];
		_desc = [decoder decodeObjectOfClass:NSString.class forKey:@"desc"];
		_eTag = [decoder decodeObjectOfClass:NSString.class forKey:@"eTag"];
		_lastModifiedBy = [decoder decodeObjectOfClass:GAIdentitySet.class forKey:@"lastModifiedBy"];
		_lastModifiedDateTime = [decoder decodeObjectOfClass:NSDate.class forKey:@"lastModifiedDateTime"];
		_name = [decoder decodeObjectOfClass:NSString.class forKey:@"name"];
		_parentReference = [decoder decodeObjectOfClass:GAItemReference.class forKey:@"parentReference"];
		_webUrl = [decoder decodeObjectOfClass:NSURL.class forKey:@"webUrl"];
		_createdByUser = [decoder decodeObjectOfClass:GAUser.class forKey:@"createdByUser"];
		_lastModifiedByUser = [decoder decodeObjectOfClass:GAUser.class forKey:@"lastModifiedByUser"];
		_driveType = [decoder decodeObjectOfClass:NSString.class forKey:@"driveType"];
		_owner = [decoder decodeObjectOfClass:GAIdentitySet.class forKey:@"owner"];
		_quota = [decoder decodeObjectOfClass:GAQuota.class forKey:@"quota"];
		_items = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GADriveItem.class, NSArray.class.class, nil] forKey:@"items"];
		_root = [decoder decodeObjectOfClass:GADriveItem.class forKey:@"root"];
		_special = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GADriveItem.class, NSArray.class.class, nil] forKey:@"special"];
	}

	return (self);
}

// occgen: type native serialization
- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_identifier forKey:@"identifier"];
	[coder encodeObject:_createdBy forKey:@"createdBy"];
	[coder encodeObject:_createdDateTime forKey:@"createdDateTime"];
	[coder encodeObject:_desc forKey:@"desc"];
	[coder encodeObject:_eTag forKey:@"eTag"];
	[coder encodeObject:_lastModifiedBy forKey:@"lastModifiedBy"];
	[coder encodeObject:_lastModifiedDateTime forKey:@"lastModifiedDateTime"];
	[coder encodeObject:_name forKey:@"name"];
	[coder encodeObject:_parentReference forKey:@"parentReference"];
	[coder encodeObject:_webUrl forKey:@"webUrl"];
	[coder encodeObject:_createdByUser forKey:@"createdByUser"];
	[coder encodeObject:_lastModifiedByUser forKey:@"lastModifiedByUser"];
	[coder encodeObject:_driveType forKey:@"driveType"];
	[coder encodeObject:_owner forKey:@"owner"];
	[coder encodeObject:_quota forKey:@"quota"];
	[coder encodeObject:_items forKey:@"items"];
	[coder encodeObject:_root forKey:@"root"];
	[coder encodeObject:_special forKey:@"special"];
}

// occgen: type debug description
- (NSString *)description
{
	return ([NSString stringWithFormat:@"<%@: %p%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@>", NSStringFromClass(self.class), self, ((_identifier!=nil) ? [NSString stringWithFormat:@", identifier: %@", _identifier] : @""), ((_createdBy!=nil) ? [NSString stringWithFormat:@", createdBy: %@", _createdBy] : @""), ((_createdDateTime!=nil) ? [NSString stringWithFormat:@", createdDateTime: %@", _createdDateTime] : @""), ((_desc!=nil) ? [NSString stringWithFormat:@", desc: %@", _desc] : @""), ((_eTag!=nil) ? [NSString stringWithFormat:@", eTag: %@", _eTag] : @""), ((_lastModifiedBy!=nil) ? [NSString stringWithFormat:@", lastModifiedBy: %@", _lastModifiedBy] : @""), ((_lastModifiedDateTime!=nil) ? [NSString stringWithFormat:@", lastModifiedDateTime: %@", _lastModifiedDateTime] : @""), ((_name!=nil) ? [NSString stringWithFormat:@", name: %@", _name] : @""), ((_parentReference!=nil) ? [NSString stringWithFormat:@", parentReference: %@", _parentReference] : @""), ((_webUrl!=nil) ? [NSString stringWithFormat:@", webUrl: %@", _webUrl] : @""), ((_createdByUser!=nil) ? [NSString stringWithFormat:@", createdByUser: %@", _createdByUser] : @""), ((_lastModifiedByUser!=nil) ? [NSString stringWithFormat:@", lastModifiedByUser: %@", _lastModifiedByUser] : @""), ((_driveType!=nil) ? [NSString stringWithFormat:@", driveType: %@", _driveType] : @""), ((_owner!=nil) ? [NSString stringWithFormat:@", owner: %@", _owner] : @""), ((_quota!=nil) ? [NSString stringWithFormat:@", quota: %@", _quota] : @""), ((_items!=nil) ? [NSString stringWithFormat:@", items: %@", _items] : @""), ((_root!=nil) ? [NSString stringWithFormat:@", root: %@", _root] : @""), ((_special!=nil) ? [NSString stringWithFormat:@", special: %@", _special] : @"")]);
}

// occgen: type protected {"locked":true}


// occgen: type end
@end


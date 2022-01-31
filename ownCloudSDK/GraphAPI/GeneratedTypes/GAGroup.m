//
// GAGroup.m
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
#import "GAGroup.h"
#import "GADrive.h"
#import "GADirectoryObject.h"

// occgen: type start
@implementation GAGroup

// occgen: type serialization {"locked":true}
+ (nullable instancetype)decodeGraphData:(GAGraphData)structure context:(nullable GAGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	GAGroup *instance = [self new];

	GA_MAP(identifier, "id", NSString, Nil);
	GA_SET(deletedDateTime, NSDate, Nil);
	GA_SET(createdDateTime, NSDate, Nil);
	GA_MAP(desc, "description", NSString, Nil);
	GA_SET(displayName, NSString, Nil);
	GA_SET(expirationDateTime, NSDate, Nil);
	GA_SET(mail, NSString, Nil);
	GA_SET(onPremisesDomainName, NSString, Nil);
	GA_SET(onPremisesLastSyncDateTime, NSDate, Nil);
	GA_SET(onPremisesSamAccountName, NSString, Nil);
	GA_SET(onPremisesSyncEnabled, NSNumber, Nil);
	GA_SET(preferredLanguage, NSString, Nil);
	GA_SET(securityEnabled, NSNumber, Nil);
	GA_SET(securityIdentifier, NSString, Nil);
	GA_SET(visibility, NSString, Nil);
	GA_SET(createdOnBehalfOf, GADirectoryObject, Nil);
	GA_SET(memberOf, GADirectoryObject, NSArray.class);
	GA_SET(members, GADirectoryObject, NSArray.class);
	GA_SET(owners, GADirectoryObject, NSArray.class);
	GA_SET(drive, GADrive, Nil);
	GA_SET(drives, GADrive, NSArray.class);
	GA_SET(isArchived, NSNumber, Nil);
//	GA_SET('members@odata.bind', NSArray, Nil);

	return (instance);
}

// occgen: type native deserialization {"locked":true}
+ (BOOL)supportsSecureCoding
{
	return (YES);
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]) != nil)
	{
		_identifier = [decoder decodeObjectOfClass:NSString.class forKey:@"identifier"];
		_deletedDateTime = [decoder decodeObjectOfClass:NSDate.class forKey:@"deletedDateTime"];
		_createdDateTime = [decoder decodeObjectOfClass:NSDate.class forKey:@"createdDateTime"];
		_desc = [decoder decodeObjectOfClass:NSString.class forKey:@"desc"];
		_displayName = [decoder decodeObjectOfClass:NSString.class forKey:@"displayName"];
		_expirationDateTime = [decoder decodeObjectOfClass:NSDate.class forKey:@"expirationDateTime"];
		_mail = [decoder decodeObjectOfClass:NSString.class forKey:@"mail"];
		_onPremisesDomainName = [decoder decodeObjectOfClass:NSString.class forKey:@"onPremisesDomainName"];
		_onPremisesLastSyncDateTime = [decoder decodeObjectOfClass:NSDate.class forKey:@"onPremisesLastSyncDateTime"];
		_onPremisesSamAccountName = [decoder decodeObjectOfClass:NSString.class forKey:@"onPremisesSamAccountName"];
		_onPremisesSyncEnabled = [decoder decodeObjectOfClass:NSNumber.class forKey:@"onPremisesSyncEnabled"];
		_preferredLanguage = [decoder decodeObjectOfClass:NSString.class forKey:@"preferredLanguage"];
		_securityEnabled = [decoder decodeObjectOfClass:NSNumber.class forKey:@"securityEnabled"];
		_securityIdentifier = [decoder decodeObjectOfClass:NSString.class forKey:@"securityIdentifier"];
		_visibility = [decoder decodeObjectOfClass:NSString.class forKey:@"visibility"];
		_createdOnBehalfOf = [decoder decodeObjectOfClass:GADirectoryObject.class forKey:@"createdOnBehalfOf"];
		_memberOf = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GADirectoryObject.class, NSArray.class.class, nil] forKey:@"memberOf"];
		_members = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GADirectoryObject.class, NSArray.class.class, nil] forKey:@"members"];
		_owners = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GADirectoryObject.class, NSArray.class.class, nil] forKey:@"owners"];
		_drive = [decoder decodeObjectOfClass:GADrive.class forKey:@"drive"];
		_drives = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GADrive.class, NSArray.class.class, nil] forKey:@"drives"];
		_isArchived = [decoder decodeObjectOfClass:NSNumber.class forKey:@"isArchived"];
//		_'members@odata.bind' = [decoder decodeObjectOfClass:NSArray.class forKey:@"'members@odata.bind'"];
	}

	return (self);
}

// occgen: type native serialization {"locked":true}
- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_identifier forKey:@"identifier"];
	[coder encodeObject:_deletedDateTime forKey:@"deletedDateTime"];
	[coder encodeObject:_createdDateTime forKey:@"createdDateTime"];
	[coder encodeObject:_desc forKey:@"desc"];
	[coder encodeObject:_displayName forKey:@"displayName"];
	[coder encodeObject:_expirationDateTime forKey:@"expirationDateTime"];
	[coder encodeObject:_mail forKey:@"mail"];
	[coder encodeObject:_onPremisesDomainName forKey:@"onPremisesDomainName"];
	[coder encodeObject:_onPremisesLastSyncDateTime forKey:@"onPremisesLastSyncDateTime"];
	[coder encodeObject:_onPremisesSamAccountName forKey:@"onPremisesSamAccountName"];
	[coder encodeObject:_onPremisesSyncEnabled forKey:@"onPremisesSyncEnabled"];
	[coder encodeObject:_preferredLanguage forKey:@"preferredLanguage"];
	[coder encodeObject:_securityEnabled forKey:@"securityEnabled"];
	[coder encodeObject:_securityIdentifier forKey:@"securityIdentifier"];
	[coder encodeObject:_visibility forKey:@"visibility"];
	[coder encodeObject:_createdOnBehalfOf forKey:@"createdOnBehalfOf"];
	[coder encodeObject:_memberOf forKey:@"memberOf"];
	[coder encodeObject:_members forKey:@"members"];
	[coder encodeObject:_owners forKey:@"owners"];
	[coder encodeObject:_drive forKey:@"drive"];
	[coder encodeObject:_drives forKey:@"drives"];
	[coder encodeObject:_isArchived forKey:@"isArchived"];
//	[coder encodeObject:_'members@odata.bind' forKey:@"'members@odata.bind'"];
}

// occgen: type debug description {"locked":true}
- (NSString *)description
{
	return ([NSString stringWithFormat:@"<%@: %p%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@>", NSStringFromClass(self.class), self, ((_identifier!=nil) ? [NSString stringWithFormat:@", identifier: %@", _identifier] : @""), ((_deletedDateTime!=nil) ? [NSString stringWithFormat:@", deletedDateTime: %@", _deletedDateTime] : @""), ((_createdDateTime!=nil) ? [NSString stringWithFormat:@", createdDateTime: %@", _createdDateTime] : @""), ((_desc!=nil) ? [NSString stringWithFormat:@", desc: %@", _desc] : @""), ((_displayName!=nil) ? [NSString stringWithFormat:@", displayName: %@", _displayName] : @""), ((_expirationDateTime!=nil) ? [NSString stringWithFormat:@", expirationDateTime: %@", _expirationDateTime] : @""), ((_mail!=nil) ? [NSString stringWithFormat:@", mail: %@", _mail] : @""), ((_onPremisesDomainName!=nil) ? [NSString stringWithFormat:@", onPremisesDomainName: %@", _onPremisesDomainName] : @""), ((_onPremisesLastSyncDateTime!=nil) ? [NSString stringWithFormat:@", onPremisesLastSyncDateTime: %@", _onPremisesLastSyncDateTime] : @""), ((_onPremisesSamAccountName!=nil) ? [NSString stringWithFormat:@", onPremisesSamAccountName: %@", _onPremisesSamAccountName] : @""), ((_onPremisesSyncEnabled!=nil) ? [NSString stringWithFormat:@", onPremisesSyncEnabled: %@", _onPremisesSyncEnabled] : @""), ((_preferredLanguage!=nil) ? [NSString stringWithFormat:@", preferredLanguage: %@", _preferredLanguage] : @""), ((_securityEnabled!=nil) ? [NSString stringWithFormat:@", securityEnabled: %@", _securityEnabled] : @""), ((_securityIdentifier!=nil) ? [NSString stringWithFormat:@", securityIdentifier: %@", _securityIdentifier] : @""), ((_visibility!=nil) ? [NSString stringWithFormat:@", visibility: %@", _visibility] : @""), ((_createdOnBehalfOf!=nil) ? [NSString stringWithFormat:@", createdOnBehalfOf: %@", _createdOnBehalfOf] : @""), ((_memberOf!=nil) ? [NSString stringWithFormat:@", memberOf: %@", _memberOf] : @""), ((_members!=nil) ? [NSString stringWithFormat:@", members: %@", _members] : @""), ((_owners!=nil) ? [NSString stringWithFormat:@", owners: %@", _owners] : @""), ((_drive!=nil) ? [NSString stringWithFormat:@", drive: %@", _drive] : @""), ((_drives!=nil) ? [NSString stringWithFormat:@", drives: %@", _drives] : @""), ((_isArchived!=nil) ? [NSString stringWithFormat:@", isArchived: %@", _isArchived] : @"")]);
}

// occgen: type protected {"locked":true}


// occgen: type end
@end


//
// GADriveItem.m
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
#import "GADriveItem.h"
#import "GADeleted.h"
#import "GADriveItem.h"
#import "GAFileSystemInfo.h"
#import "GAFolder.h"
#import "GAIdentitySet.h"
#import "GAImage.h"
#import "GAItemReference.h"
#import "GAOpenGraphFile.h"
#import "GAPermission.h"
#import "GARemoteItem.h"
#import "GARoot.h"
#import "GASpecialFolder.h"
#import "GATrash.h"
#import "GAUser.h"

// occgen: type start
@implementation GADriveItem

// occgen: type serialization
+ (nullable instancetype)decodeGraphData:(GAGraphData)structure context:(nullable GAGraphContext *)context error:(NSError * _Nullable * _Nullable)outError
{
	GADriveItem *instance = [self new];

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
	GA_SET(content, NSString, Nil);
	GA_SET(cTag, NSString, Nil);
	GA_SET(deleted, GADeleted, Nil);
	GA_SET(file, GAOpenGraphFile, Nil);
	GA_SET(fileSystemInfo, GAFileSystemInfo, Nil);
	GA_SET(folder, GAFolder, Nil);
	GA_SET(image, GAImage, Nil);
	GA_SET(root, GARoot, Nil);
	GA_SET(trash, GATrash, Nil);
	GA_SET(specialFolder, GASpecialFolder, Nil);
	GA_SET(remoteItem, GARemoteItem, Nil);
	GA_SET(size, NSNumber, Nil);
	GA_SET(webDavUrl, NSURL, Nil);
	GA_SET(children, GADriveItem, NSArray.class);
	GA_SET(permissions, GAPermission, NSArray.class);

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
		_content = [decoder decodeObjectOfClass:NSString.class forKey:@"content"];
		_cTag = [decoder decodeObjectOfClass:NSString.class forKey:@"cTag"];
		_deleted = [decoder decodeObjectOfClass:GADeleted.class forKey:@"deleted"];
		_file = [decoder decodeObjectOfClass:GAOpenGraphFile.class forKey:@"file"];
		_fileSystemInfo = [decoder decodeObjectOfClass:GAFileSystemInfo.class forKey:@"fileSystemInfo"];
		_folder = [decoder decodeObjectOfClass:GAFolder.class forKey:@"folder"];
		_image = [decoder decodeObjectOfClass:GAImage.class forKey:@"image"];
		_root = [decoder decodeObjectOfClass:GARoot.class forKey:@"root"];
		_trash = [decoder decodeObjectOfClass:GATrash.class forKey:@"trash"];
		_specialFolder = [decoder decodeObjectOfClass:GASpecialFolder.class forKey:@"specialFolder"];
		_remoteItem = [decoder decodeObjectOfClass:GARemoteItem.class forKey:@"remoteItem"];
		_size = [decoder decodeObjectOfClass:NSNumber.class forKey:@"size"];
		_webDavUrl = [decoder decodeObjectOfClass:NSURL.class forKey:@"webDavUrl"];
		_children = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GADriveItem.class, NSArray.class, nil] forKey:@"children"];
		_permissions = [decoder decodeObjectOfClasses:[NSSet setWithObjects: GAPermission.class, NSArray.class, nil] forKey:@"permissions"];
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
	[coder encodeObject:_content forKey:@"content"];
	[coder encodeObject:_cTag forKey:@"cTag"];
	[coder encodeObject:_deleted forKey:@"deleted"];
	[coder encodeObject:_file forKey:@"file"];
	[coder encodeObject:_fileSystemInfo forKey:@"fileSystemInfo"];
	[coder encodeObject:_folder forKey:@"folder"];
	[coder encodeObject:_image forKey:@"image"];
	[coder encodeObject:_root forKey:@"root"];
	[coder encodeObject:_trash forKey:@"trash"];
	[coder encodeObject:_specialFolder forKey:@"specialFolder"];
	[coder encodeObject:_remoteItem forKey:@"remoteItem"];
	[coder encodeObject:_size forKey:@"size"];
	[coder encodeObject:_webDavUrl forKey:@"webDavUrl"];
	[coder encodeObject:_children forKey:@"children"];
	[coder encodeObject:_permissions forKey:@"permissions"];
}

// occgen: type debug description
- (NSString *)description
{
	return ([NSString stringWithFormat:@"<%@: %p%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@>", NSStringFromClass(self.class), self, ((_identifier!=nil) ? [NSString stringWithFormat:@", identifier: %@", _identifier] : @""), ((_createdBy!=nil) ? [NSString stringWithFormat:@", createdBy: %@", _createdBy] : @""), ((_createdDateTime!=nil) ? [NSString stringWithFormat:@", createdDateTime: %@", _createdDateTime] : @""), ((_desc!=nil) ? [NSString stringWithFormat:@", desc: %@", _desc] : @""), ((_eTag!=nil) ? [NSString stringWithFormat:@", eTag: %@", _eTag] : @""), ((_lastModifiedBy!=nil) ? [NSString stringWithFormat:@", lastModifiedBy: %@", _lastModifiedBy] : @""), ((_lastModifiedDateTime!=nil) ? [NSString stringWithFormat:@", lastModifiedDateTime: %@", _lastModifiedDateTime] : @""), ((_name!=nil) ? [NSString stringWithFormat:@", name: %@", _name] : @""), ((_parentReference!=nil) ? [NSString stringWithFormat:@", parentReference: %@", _parentReference] : @""), ((_webUrl!=nil) ? [NSString stringWithFormat:@", webUrl: %@", _webUrl] : @""), ((_createdByUser!=nil) ? [NSString stringWithFormat:@", createdByUser: %@", _createdByUser] : @""), ((_lastModifiedByUser!=nil) ? [NSString stringWithFormat:@", lastModifiedByUser: %@", _lastModifiedByUser] : @""), ((_content!=nil) ? [NSString stringWithFormat:@", content: %@", _content] : @""), ((_cTag!=nil) ? [NSString stringWithFormat:@", cTag: %@", _cTag] : @""), ((_deleted!=nil) ? [NSString stringWithFormat:@", deleted: %@", _deleted] : @""), ((_file!=nil) ? [NSString stringWithFormat:@", file: %@", _file] : @""), ((_fileSystemInfo!=nil) ? [NSString stringWithFormat:@", fileSystemInfo: %@", _fileSystemInfo] : @""), ((_folder!=nil) ? [NSString stringWithFormat:@", folder: %@", _folder] : @""), ((_image!=nil) ? [NSString stringWithFormat:@", image: %@", _image] : @""), ((_root!=nil) ? [NSString stringWithFormat:@", root: %@", _root] : @""), ((_trash!=nil) ? [NSString stringWithFormat:@", trash: %@", _trash] : @""), ((_specialFolder!=nil) ? [NSString stringWithFormat:@", specialFolder: %@", _specialFolder] : @""), ((_remoteItem!=nil) ? [NSString stringWithFormat:@", remoteItem: %@", _remoteItem] : @""), ((_size!=nil) ? [NSString stringWithFormat:@", size: %@", _size] : @""), ((_webDavUrl!=nil) ? [NSString stringWithFormat:@", webDavUrl: %@", _webDavUrl] : @""), ((_children!=nil) ? [NSString stringWithFormat:@", children: %@", _children] : @""), ((_permissions!=nil) ? [NSString stringWithFormat:@", permissions: %@", _permissions] : @"")]);
}

// occgen: type protected {"locked":true}


// occgen: type end
@end


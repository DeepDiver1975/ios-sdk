//
// OCGOpenGraphFile.h
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
#import <Foundation/Foundation.h>
#import "OCGraphObject.h"

// occgen: forward declarations
@class OCGHashes;

// occgen: type start
NS_ASSUME_NONNULL_BEGIN
@interface OCGOpenGraphFile : NSObject <OCGraphObject>

// occgen: type properties
@property(strong, nullable) OCGHashes *hashes;
@property(strong, nullable) NSString *mimeType; //!< The MIME type for the file. This is determined by logic on the server and might not be the value provided when the file was uploaded. Read-only.
@property(strong, nullable) NSNumber *processingMetadata; //!< [boolean]

// occgen: type protected {"locked":true}


// occgen: type end
@end
NS_ASSUME_NONNULL_END


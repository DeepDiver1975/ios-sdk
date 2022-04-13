//
// GASpecialFolder.h
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
#import "GAGraphObject.h"

// occgen: forward declarations
typedef NSString * GASpecialFolderName;

// occgen: typedefs {"locked":true}
typedef NSString* GASpecialFolderName NS_TYPED_ENUM;

// occgen: type start
NS_ASSUME_NONNULL_BEGIN
@interface GASpecialFolder : NSObject <GAGraphObject, NSSecureCoding>

// occgen: type properties { "customPropertyTypes" : { "name" : "GASpecialFolderName" }}
@property(strong, nullable) GASpecialFolderName name; //!< The unique identifier for this item in the /drive/special collection

// occgen: type protected {"locked":true}


// occgen: type end {"locked":true}
@end

extern GASpecialFolderName GASpecialFolderNameReadme;
extern GASpecialFolderName GASpecialFolderNameImage;

NS_ASSUME_NONNULL_END












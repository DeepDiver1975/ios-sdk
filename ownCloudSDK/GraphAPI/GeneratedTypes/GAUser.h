//
// GAUser.h
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
@class GADrive;
@class GAPasswordProfile;

// occgen: type start
NS_ASSUME_NONNULL_BEGIN
@interface GAUser : NSObject <GAGraphObject, NSSecureCoding>

// occgen: type properties
@property(strong, nullable) NSString *identifier; //!< Read-only.
@property(strong, nullable) NSDate *deletedDateTime; //!< [string:date-time] | pattern: ^[0-9]{4,}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])[Tt]([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]([.][0-9]{1,12})?([Zz]|[+-][0-9][0-9]:[0-9][0-9])$
@property(strong, nullable) NSNumber *accountEnabled; //!< [boolean] true if the account is enabled; otherwise, false. This property is required when a user is created. Returned only on $select. Supports $filter.
@property(strong, nullable) NSArray *businessPhones; //!< The telephone numbers for the user. Only one number can be set for this property. Returned by default. Read-only for users synced from on-premises directory.
@property(strong, nullable) NSString *city; //!< The city in which the user is located. Returned only on $select. Supports $filter.
@property(strong, nullable) NSString *companyName; //!< The company name which the user is associated. This property can be useful for describing the company that an external user comes from. The maximum length of the company name is 64 characters.Returned only on $select.
@property(strong, nullable) NSString *country; //!< The country/region in which the user is located; for example, ''US'' or ''UK''. Returned only on $select. Supports $filter.
@property(strong, nullable) NSDate *createdDateTime; //!< [string:date-time] The date and time the user was created. The value cannot be modified and is automatically populated when the entity is created. The DateTimeOffset type represents date and time information using ISO 8601 format and is always in UTC time. Property is nullable. A null value indicates that an accurate creation time couldn't be determined for the user. Returned only on $select. Read-only. Supports $filter. | pattern: ^[0-9]{4,}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])[Tt]([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]([.][0-9]{1,12})?([Zz]|[+-][0-9][0-9]:[0-9][0-9])$
@property(strong, nullable) NSString *department; //!< The name for the department in which the user works. Returned only on $select. Supports $filter.
@property(strong, nullable) NSString *displayName; //!< The name displayed in the address book for the user. This value is usually the combination of the user''s first name, middle initial, and last name. This property is required when a user is created and it cannot be cleared during updates. Returned by default. Supports $filter and $orderby.
@property(strong, nullable) NSString *faxNumber; //!< The fax number of the user. Returned only on $select.
@property(strong, nullable) NSString *givenName; //!< The given name (first name) of the user. Returned by default. Supports $filter.
@property(strong, nullable) NSDate *lastPasswordChangeDateTime; //!< [string:date-time] The time when this user last changed their password. The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z Returned only on $select. Read-only. | pattern: ^[0-9]{4,}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])[Tt]([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]([.][0-9]{1,12})?([Zz]|[+-][0-9][0-9]:[0-9][0-9])$
@property(strong, nullable) NSString *legalAgeGroupClassification; //!< Used by enterprise applications to determine the legal age group of the user. This property is read-only and calculated based on ageGroup and consentProvidedForMinor properties. Allowed values: null, minorWithOutParentalConsent, minorWithParentalConsent, minorNoParentalConsentRequired, notAdult and adult. Refer to the legal age group property definitions for further information. Returned only on $select.
@property(strong, nullable) NSString *mail; //!< The SMTP address for the user, for example, ''jeff@contoso.onowncloud.com''. Returned by default. Supports $filter and endsWith.
@property(strong, nullable) NSString *mailNickname; //!< The mail alias for the user. This property must be specified when a user is created. Returned only on $select. Supports $filter.
@property(strong, nullable) NSString *mobilePhone; //!< The primary cellular telephone number for the user. Returned by default. Read-only for users synced from on-premises directory.
@property(strong, nullable) NSString *onPremisesDistinguishedName; //!< Contains the on-premises Active Directory distinguished name or DN. The property is only populated for customers who are synchronizing their on-premises directory to Azure Active Directory via Azure AD Connect. Read-only. Returned only on $select.
@property(strong, nullable) NSString *onPremisesDomainName; //!< Contains the on-premises domainFQDN, also called dnsDomainName synchronized from the on-premises directory. The property is only populated for customers who are synchronizing their on-premises directory to Azure Active Directory via Azure AD Connect. Read-only. Returned only on $select.
@property(strong, nullable) NSString *onPremisesImmutableId; //!< This property is used to associate an on-premises Active Directory user account to their Azure AD user object. This property must be specified when creating a new user account in the Graph if you are using a federated domain for the user''s userPrincipalName (UPN) property. NOTE: The $ and _ characters cannot be used when specifying this property. Returned only on $select. Supports $filter (eq, ne, not, ge, le, in)..
@property(strong, nullable) NSNumber *onPremisesSyncEnabled; //!< [boolean] true if this object is synced from an on-premises directory; false if this object was originally synced from an on-premises directory but is no longer synced; null if this object has never been synced from an on-premises directory (default). Read-only. Returned only on $select. Supports $filter (eq, ne, not, in, and eq on null values).
@property(strong, nullable) NSDate *onPremisesLastSyncDateTime; //!< [string:date-time] Indicates the last time at which the object was synced with the on-premises directory; for example: 2013-02-16T03:04:54Z. The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Read-only. Returned only on $select. Supports $filter (eq, ne, not, ge, le, in). | pattern: ^[0-9]{4,}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]([.][0-9]{1,12})?(Z|[+-][0-9][0-9]:[0-9][0-9])$
@property(strong, nullable) NSString *onPremisesSamAccountName; //!< Contains the on-premises SAM account name synchronized from the on-premises directory. Read-only.
@property(strong, nullable) NSString *onPremisesUserPrincipalName; //!< Contains the on-premises userPrincipalName synchronized from the on-premises directory. The property is only populated for customers who are synchronizing their on-premises directory to Azure Active Directory via Azure AD Connect. Read-only. Returned only on $select. Supports $filter (eq, ne, not, ge, le, in, startsWith).
@property(strong, nullable) NSString *officeLocation; //!< The office location in the user's place of business. Returned by default.
@property(strong, nullable) GAPasswordProfile *passwordProfile;
@property(strong, nullable) NSString *postalCode; //!< The postal code for the user''s postal address. The postal code is specific to the user''s country/region. In the United States of America, this attribute contains the ZIP code. Returned only on $select.
@property(strong, nullable) NSString *preferredLanguage; //!< The preferred language for the user. Should follow ISO 639-1 Code; for example 'en-US'. Returned by default. | pattern: ^[a-z]{2}(-[A-Z]{2})?$
@property(strong, nullable) NSString *state; //!< The state or province in the user's address. Returned only on $select. Supports $filter.
@property(strong, nullable) NSString *streetAddress; //!< The street address of the user's place of business. Returned only on $select.
@property(strong, nullable) NSString *surname; //!< The user's surname (family name or last name). Returned by default. Supports $filter.
@property(strong, nullable) NSString *usageLocation; //!< A two letter country code (ISO standard 3166). Required for users that will be assigned licenses due to legal requirement to check for availability of services in countries.  Examples include: ''US'', ''JP'', and ''GB''. Not nullable. Returned only on $select. Supports $filter.
@property(strong, nullable) NSString *userPrincipalName; //!< The user principal name (UPN) of the user. The UPN is an Internet-style login name for the user based on the Internet standard RFC 822. By convention, this should map to the user''s email name. The general format is alias@domain, where domain must be present in the tenant''s collection of verified domains. This property is required when a user is created. The verified domains for the tenant can be accessed from the verifiedDomains property of organization. Returned by default. Supports $filter, $orderby, and endsWith.
@property(strong, nullable) NSString *userType; //!< A string value that can be used to classify user types in your directory, such as ''Member'' and ''Guest''. Returned only on $select. Supports $filter.
@property(strong, nullable) NSString *aboutMe; //!< A freeform text entry field for the user to describe themselves. Returned only on $select.
@property(strong, nullable) NSDate *birthday; //!< [string:date-time] The birthday of the user. The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z Returned only on $select. | pattern: ^[0-9]{4,}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])[Tt]([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]([.][0-9]{1,12})?([Zz]|[+-][0-9][0-9]:[0-9][0-9])$
@property(strong, nullable) NSString *preferredName; //!< The preferred name for the user. Returned only on $select.
@property(strong, nullable) GADrive *drive;
@property(strong, nullable) NSArray<GADrive *> *drives; //!< A collection of drives available for this user. Read-only.

// occgen: type protected {"locked":true}


// occgen: type end
@end
NS_ASSUME_NONNULL_END


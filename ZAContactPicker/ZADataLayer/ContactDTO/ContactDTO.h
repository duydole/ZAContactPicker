#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

// Contact Data Transfer Object: for transfering from DataLayer to Business Layers.
@interface ContactDTO : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSString *fullName;
@property NSMutableArray *phoneNumbers;
@property NSString *contactId;
@property NSString *namePrefix;
@property NSString *middleName;
@property NSString *nameSuffix;
@property NSString *jobTitle;

- (instancetype) initWithCNContact: (CNContact*) cnContact;

@end

#import "ContactDTO.h"

@interface ContactDTO()

@end

@implementation ContactDTO

- (instancetype) init {
    self = [super init];
    if (self) {
        _firstName = [[NSString alloc] init];
        _lastName = [[NSString alloc] init];
        _fullName = [[NSString alloc] init];
        _phoneNumbers = [[NSMutableArray alloc] init];
        _contactId = [[NSString alloc] init];
        _namePrefix = [[NSString alloc] init];
        _middleName = [[NSString alloc] init];
        _nameSuffix = [[NSString alloc] init];
        _jobTitle = [[NSString alloc] init];
    }
    return self;
}

- (instancetype) initWithCNContact:(CNContact *) cnContact {
    self = [self init];
    self.contactId = cnContact.identifier;
    self.firstName = cnContact.givenName;
    self.lastName = cnContact.familyName;
    if (self.firstName.length > 0 || self.lastName.length > 0) {
        self.fullName = [[NSString alloc] initWithFormat:@"%@ %@",cnContact.givenName,cnContact.familyName];
    }
    self.phoneNumbers = [[cnContact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    self.namePrefix = cnContact.namePrefix;
    self.middleName = cnContact.middleName;
    self.nameSuffix = cnContact.nameSuffix;
    self.jobTitle = cnContact.jobTitle;
    
    return self;
}

@end

#import <Foundation/Foundation.h>
#import "ZAContactModel.h"

@implementation ZAContactModel

- (instancetype) init {
    self = [super init];
    if (self) {
        self.fullName = [[NSString alloc] init];
        self.identifier = [[NSString alloc] init];
        self.firstName = [[NSString alloc] init];
        self.lastName = [[NSString alloc] init];
        self.phoneNumbers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype) initWithContactDTO:(ContactDTO *) contactDTO {
    
    self = [self init];
    
    if ([contactDTO.fullName isEqualToString:@""]) {
        self.fullName = contactDTO.phoneNumbers[0];
    } else {
        self.fullName = contactDTO.fullName;
    }
    
    self.firstName = contactDTO.firstName;
    
    self.lastName = contactDTO.lastName;
    
    self.phoneNumbers = contactDTO.phoneNumbers;
    
    self.identifier = contactDTO.contactId;

    return self;
}


@end

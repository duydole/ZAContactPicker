#import <Foundation/Foundation.h>
#import "ContactDTO.h"

/**
 @brief ZAContactModel is the Contact Entity for Business Layer.
 */
@interface ZAContactModel : NSObject

// initWith ContactDTO.
- (instancetype) initWithContactDTO: (ContactDTO*) contactDTO;

@property NSString *fullName;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *identifier;
@property NSMutableArray *phoneNumbers;

@end

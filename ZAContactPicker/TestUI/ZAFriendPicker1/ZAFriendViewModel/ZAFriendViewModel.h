#import <Foundation/Foundation.h>
#import "ZAContactViewModel.h"
#import "ZAFriendModel.h"

@interface ZAFriendViewModel : NSObject<ZAViewModelProtocol>

@property NSString *identifier;
@property NSString *fullName;
@property BOOL isSelected;
@property NSString *groupKey;
@property NSString *phoneNumber;
@property NSString *avatarUrl;

- (instancetype) initWithZAFriendModel: (ZAFriendModel*)zaFriendModel;

- (UIImage*) getZAViewModelImage;

@end

#import "ZAContactModel.h"
#import <UIKit/UIKit.h>

@protocol ZAViewModelProtocol <NSObject>

@required
@property NSString *identifier;
@property NSString *fullName;
@property BOOL isSelected;
@property NSString *groupKey;
@property NSString *phoneNumber;

- (UIImage*) getZAViewModelImage;

@end

@interface ZAContactViewModel : NSObject<ZAViewModelProtocol>

/**
 @brief init a ZAContactViewModel by a ZAContactModel
 */
- (instancetype) initWithZAContactModel: (ZAContactModel*)zaContactModel;

/**
 @brief get Avatar of ContactViewModel.
 */
- (UIImage*) getZAViewModelImage;

@property NSString *identifier;
@property NSString *fullName;
@property BOOL isSelected;
@property NSString *groupKey;
@property NSString *phoneNumber;
@property NSString *shortName;
@property UIColor *backgroundColor;

@end

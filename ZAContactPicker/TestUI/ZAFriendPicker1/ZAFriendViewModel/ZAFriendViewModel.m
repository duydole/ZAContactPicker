#import "ZAFriendViewModel.h"

@interface ZAFriendViewModel()

@end

@implementation ZAFriendViewModel

- (instancetype) init {
    self = [super init];
    if (self) {
        _identifier = [[NSString alloc] init];
        _fullName = [[NSString alloc] init];
        _isSelected = FALSE;
        _groupKey = [[NSString alloc] init];
        _phoneNumber = [[NSString alloc] init];
    }
    return self;
}

- (instancetype)initWithZAFriendModel:(ZAFriendModel *)zaFriendModel {
    self = [super init];
    
    _fullName = zaFriendModel.fullName;
    _avatarUrl = zaFriendModel.avatarUrl;
    _identifier = zaFriendModel.avatarUrl;
    
    return self;
}


- (UIImage *) getZAViewModelImage {
    NSURL *url = [NSURL URLWithString:_avatarUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *avatar = [UIImage imageWithData:imageData];
    return avatar;
}

@end

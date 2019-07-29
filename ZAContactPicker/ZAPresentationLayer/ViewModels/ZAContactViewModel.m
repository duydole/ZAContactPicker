#import "ZAContactViewModel.h"

@implementation ZAContactViewModel

- (instancetype) init {
    self = [super init];
    if (self) {
        _identifier = [[NSString alloc] init];
        _fullName = [[NSString alloc] init];
        _isSelected = FALSE;
        _groupKey = [[NSString alloc] init];
        _phoneNumber = [[NSString alloc] init];
        _shortName = @"";
    }
    return self;
}

- (instancetype) initWithZAContactModel: (ZAContactModel *)zaContactModel {
    self = [self init];
    _identifier = zaContactModel.identifier;
    _fullName = zaContactModel.fullName;
    
    // generrate GroupKey.
    if (zaContactModel.lastName.length > 0) {
        self.groupKey = [zaContactModel.lastName substringToIndex:1];
    } else if (zaContactModel.firstName.length > 0) {
        self.groupKey = [zaContactModel.firstName substringToIndex:1];
    } else {
        self.groupKey = @"#";
    }
    
    // Phonenumber
    if (zaContactModel.phoneNumbers.count > 0) {
        _phoneNumber = zaContactModel.phoneNumbers[0];
    }
    
    // generate ShortName:
    if (zaContactModel.firstName.length || zaContactModel.lastName.length) {
        NSString *firstCharOfFirstName = (zaContactModel.firstName.length > 0)? [zaContactModel.firstName substringToIndex:1]: @"";
        NSString *firstCharOfLastName = (zaContactModel.lastName.length > 0)? [zaContactModel.lastName substringToIndex:1]: @"";
        _shortName = [NSString stringWithFormat:@"%@%@",firstCharOfFirstName, firstCharOfLastName];
    } else if (zaContactModel.phoneNumbers.count > 0 && [zaContactModel.phoneNumbers[0] length] > 0){
        _shortName = [zaContactModel.phoneNumbers[0] substringToIndex:1];
    } else {
        _shortName = @"?";
    }
    
    // generate BackgroundColor:
    _backgroundColor =  [[UIColor alloc] initWithRed:[self stringToFloat:zaContactModel.firstName] green:[self stringToFloat:zaContactModel.lastName] blue:[self stringToFloat:_phoneNumber] alpha:0.3];
    
    return self;
}

- (UIImage *) getZAViewModelImage {
    CGRect frame = CGRectMake(0, 0, 100, 100);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = _backgroundColor;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:50];
    label.text = _shortName;
    
    // circle lable:
    label.layer.cornerRadius = label.frame.size.height/2;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 0;
    
    // gen Image:
     UIGraphicsBeginImageContext(frame.size);
    if (UIGraphicsGetCurrentContext()) {
        [label.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *myImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return myImg;
    }
    
    return nil;
}

# pragma mark - Private methods:
- (CGFloat) stringToFloat: (NSString *) aString {
    if (aString.length > 2) {
        char firstChar = [aString characterAtIndex:2];
        CGFloat floatValue = ([[NSNumber numberWithChar:firstChar] integerValue]%5)/5.0;
        return floatValue;
    }
    return 0.2;
}

@end

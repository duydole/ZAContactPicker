//
//  ZAFriendModel.m
//  ZAContactPicker
//
//  Created by Duy on 7/14/19.
//  Copyright © 2019 vng. All rights reserved.
//

#import "ZAFriendModel.h"

@implementation ZAFriendModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _fullName = @"";
        _avatarUrl = @"";
    }
    return self;
}

@end

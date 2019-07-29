#import "ZAViewModelDictionary.h"

@implementation ZAViewModelDictionary

- (instancetype) init {
    self = [super init];
    if (self) {
        _zaViewModelDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSUInteger) numbOfGroupKeys {
    return self.zaViewModelDict.count;
}

- (NSArray *) sortedGroupKeys {
    return [self.zaViewModelDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

- (void)addAZAViewModel:(id<ZAViewModelProtocol>) zaViewModel {
    
    if (!zaViewModel.groupKey) {
        zaViewModel.groupKey = @"#";
    }
    
    if(self.zaViewModelDict[zaViewModel.groupKey]) {
        [self.zaViewModelDict[zaViewModel.groupKey] addObject:zaViewModel];
    } else {
        self.zaViewModelDict[zaViewModel.groupKey] = [[NSMutableArray alloc] initWithObjects:zaViewModel, nil];
    }
}

- (id<ZAViewModelProtocol>)getZAViewModelAtGroupIndex:(NSUInteger)groupIndex indexInGroup:(NSUInteger)subIndex {
    if (groupIndex < self.numbOfGroupKeys && groupIndex >= 0 && subIndex < [self getSizeOfGroupWithGroupIndex:groupIndex] && subIndex >=0) {
        NSString *groupKey = self.sortedGroupKeys[groupIndex];
        return self.zaViewModelDict[groupKey][subIndex];
    }
    return nil;
}

- (NSInteger) getSizeOfGroupWithGroupIndex:(NSUInteger) groupIndex {
    if (groupIndex < self.numbOfGroupKeys && groupIndex >= 0) {
        NSString *groupKey = self.sortedGroupKeys[groupIndex];
        return [self.zaViewModelDict[groupKey] count];
    }
    return  1;
}

- (ZAViewModelDictionary *) filterByText:(NSString *) text {
    ZAViewModelDictionary *filteredDict = [[ZAViewModelDictionary alloc] init];
    for (NSString *groupKey in self.sortedGroupKeys) {
        for (id<ZAViewModelProtocol> zaViewModel in self.zaViewModelDict[groupKey]) {
            NSRange range = [zaViewModel.fullName rangeOfString:text options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [filteredDict addAZAViewModel:zaViewModel];
            }
        }
    }
    return filteredDict;
}

- (NSInteger) getGroupIndexOfZAViewModel: (id<ZAViewModelProtocol>) zaViewModel {
    if (zaViewModel) {
        for (int i = 0; i < self.sortedGroupKeys.count; i++) {
            if ([zaViewModel.groupKey isEqualToString: self.sortedGroupKeys[i]]) {
                return i;
            }
        }
        return -1;
    }
    return -1;
}

- (NSInteger)getIndexOfZAViewModelInGroup:(id<ZAViewModelProtocol>)zaViewModel {
    if (zaViewModel) {
        for (int i = 0; i < [self.zaViewModelDict[zaViewModel.groupKey] count]; i++) {
            if (zaViewModel == self.zaViewModelDict[zaViewModel.groupKey][i]) {
                return i;
            }
        }
        return -1;
    }
    return -1;
}

- (void) removeAZAViewModel:(id<ZAViewModelProtocol>) removedZAViewModel {
    for (NSString *sectionKey in self.sortedGroupKeys) {
        [[self.zaViewModelDict objectForKey:sectionKey] removeObject:removedZAViewModel];
        if ([[self.zaViewModelDict objectForKey:sectionKey] count] == 0) {
            [self.zaViewModelDict removeObjectForKey:sectionKey];
        }
    }
}

@end

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZAContactViewModel.h"


// ZAContactViewModelDictionary is the model for managing a Dictionary of ZAContactViewModels which implemented id<ZAViewModelProtocol>.
@interface ZAViewModelDictionary : NSObject

// a dictionary which contains id<ZAViewModelProtocol> by grouping them correspond to their group keys.
@property NSMutableDictionary<NSString*,NSMutableArray<id<ZAViewModelProtocol>>*> *zaViewModelDict;
@property (readonly) NSArray *sortedGroupKeys;                                                              // array of sorted group keys.
@property (readonly) NSUInteger numbOfGroupKeys;                                                            // number of keys in dictionary.

/**
 add new id<ZAViewModelProtocol> into dictionary.
 
 @param zaViewModel :will be added in to dictionary.
 */
- (void) addAZAViewModel: (id<ZAViewModelProtocol>) zaViewModel;

/**
 remove a id<ZAViewModelProtocol> from Dictionary.
 
 @param removedZAViewModel : will be removed from dictionary.
 */
- (void) removeAZAViewModel: (id<ZAViewModelProtocol>) removedZAViewModel;

/**
 get ZAModel at GroupIndex and subIndex (index of ZAModel in that Group).
 
 @param groupIndex : index of group (in sorted groups)
 @param subIndex : index of ZAModel in that group.
 @return nil if invalid input or an id<ZAModelProtol>.
 */
- (id<ZAViewModelProtocol>) getZAViewModelAtGroupIndex: (NSUInteger)groupIndex
                                      indexInGroup: (NSUInteger)subIndex;

/**
 get Size of a group.
 
 @param groupIndex : index of that group in sorted list groups.
 @return - 1 if groupIndex out of range.
 Or return size of input groupIndex.
 */
- (NSInteger) getSizeOfGroupWithGroupIndex:(NSUInteger) groupIndex;

/**
 filter self.zaModelDict by FullName property of ZAModel.
 
 @param text : search text.
 @return new ZAModelDictionary after filtered.
 */
 - (ZAViewModelDictionary *) filterByText: (NSString *) text;

/**
 get index of a ZAModel (index in sorted group name) in a specified group in Dictionary.
 
 @param zaViewModel : input ZAModel
 @return -1 if invalid zaModel or model doesn't exist in dictionary.
 Or, return an index number if it exists.
 */
- (NSInteger) getIndexOfZAViewModelInGroup: (id<ZAViewModelProtocol>) zaViewModel;

/**
 get Index of a Group that zaModel belongs to. (index in sorted group name)
 
 @param zaViewModel :input viewmodel.
 @return -1 if invalid zaViewModel or model doesn't exist in dictionary.
 Or, return an index number of group.
 */
- (NSInteger) getGroupIndexOfZAViewModel: (id<ZAViewModelProtocol>) zaViewModel;

@end

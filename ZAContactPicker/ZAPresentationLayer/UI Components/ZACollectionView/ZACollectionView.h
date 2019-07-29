#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "ZAContactModel.h"
#import "ZAContactViewModel.h"

@class ZACollectionView;

// PROTOCOL: DatSource Protocol of ZACollectionView.
@protocol ZACollectionViewDataSource <NSObject>

@required
// require a Array of id<ZAViewModelProtocol> for collectionview.
- (NSMutableArray<id<ZAViewModelProtocol>> *) zaModelsListForZACollectionView:(ZACollectionView *) zaCollectionView;

@end


// PROTOCOL: Delegate protocol of ZACollectionView.
@protocol ZACollectionViewDelegate <NSObject>

@optional
// called when select a ViewModel in CollectionView.
- (void) ZACollectionView:(ZACollectionView*) zaCollectionView didSelectZAModel:(id<ZAViewModelProtocol>) selectedZAModel;

@end

// INTERFACE: ZACollectionView Interface.
@interface ZACollectionView : UIView

@property (nonatomic, weak) IBOutlet id<ZACollectionViewDelegate> zaCollectionViewDelegate;
@property (nonatomic, weak) IBOutlet id<ZACollectionViewDataSource> zaCollectionViewDataSource;

/**
 reload data of collectionview.
 */
- (void) reloadZACollectionView;

/**
 Add a new item at position.

 @param newZAModelView is the new item to be added.
 @param index : position of new item.
 */
- (void) addAZAModelview: (id<ZAViewModelProtocol>) newZAModelView atIndex: (NSUInteger) index;

/**
 Remove an ZAModel Items at Index and reload collectionview.

 @param index of Removed Item.
 */
- (void) removeZAModelAtIndex: (NSUInteger) index;

@end

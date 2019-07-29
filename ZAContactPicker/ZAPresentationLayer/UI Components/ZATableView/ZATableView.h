#import "ZATableViewCell.h"
#import "ZAViewModelDictionary.h"

@class ZATableView;

@protocol ZATableViewDelegate <NSObject>

@optional
// called when user selected a row on ZATableView.
- (void) zaTableView:(ZATableView*)zaTableView didSelectZAViewModel:(id<ZAViewModelProtocol>)selectedZAViewModel;
// called when user deselected row on ZATableView.
- (void) zaTableView:(ZATableView*)zaTableView didDeselectZAViewModel:(id<ZAViewModelProtocol>)deselectedZAViewModel;
// called before user drag the ZATableView.
- (void) zaTableViewWillBeginDragging:(UIScrollView*)scrollView;
// called before user select a row in ZATableView. Return TRUE if allow the selection, FALSE if not.
- (BOOL) zaTableView:(ZATableView*)zaTableView isAllowToSelectZAViewModel:(id<ZAViewModelProtocol>)zaViewModel;
// called when user pull down the TableView, param: callBack to handle the completion.
- (void) didPullDown:(ZATableView*) zaTableView completionHandler:(void(^)(void))callBack;

@end

@protocol ZATableViewDataSource <NSObject>

@required
// required a ZAContactViewModelDictionary for rendering ZATableView.
- (ZAViewModelDictionary*) zaModelDictForZATableView:(ZATableView*) zaTableView;

@optional
// is show HeaderView or not.
- (BOOL) isShowedHeaderViewForZATableView:(ZATableView*)zaTableView;

@end

@interface ZATableView : UIView

@property (nonatomic, weak) IBOutlet id<ZATableViewDelegate> zaTableViewDelegate;
@property (nonatomic, weak) IBOutlet id<ZATableViewDataSource> zaTableViewDataSource;

// reloadData of ZATableView.
- (void) reloadZATableView;
// force to stop scrolling ZATableView.
- (void) stopScrollingZATableView;
// scroll to IndexPath:
- (void) scrollToIndexPath:(NSIndexPath*)indexPath;

@end

#import <UIKit/UIKit.h>
#import "ZATableView.h"
#import "ZACollectionView.h"

@class ZAPickerViewController;

@protocol ZAPickerViewControllerDataSource <NSObject>

@required
// require a Dictionary of ZAViewModels.
- (ZAViewModelDictionary *) zaModelDictForPickerView:(ZAPickerViewController*) zaPickerViewController;

@end

@protocol ZAPickerViewControllerDelegate <NSObject>

@optional
// called when user pulled down the zaTableView, callBack to handle the completion.
- (void) didPullDown:(ZATableView*) zaTableView completionHandler:(void(^)(void)) callBack;

@end

@interface ZAPickerViewController : UIViewController

@property (nonatomic, weak) IBOutlet id<ZAPickerViewControllerDelegate> pickerDelegate;
@property (nonatomic, weak) IBOutlet id<ZAPickerViewControllerDataSource> pickerDataSource;

// reload data of ZACollectionView, ZATableView.
- (void) reloadPickerView;

@end

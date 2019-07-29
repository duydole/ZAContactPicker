#import "ZAPickerViewController.h"
#import "ZACollectionView.h"
#import "ZATableView.h"
#import "ZAViewModelDictionary.h"

#define MAX_SELECTED_ZAMODEL 5

@interface ZAPickerViewController()<ZACollectionViewDataSource, ZACollectionViewDelegate, ZATableViewDataSource, ZATableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet ZACollectionView *zaCollectionView;
@property (weak, nonatomic) IBOutlet ZATableView *zaTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSendSMS;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zaCollectionViewHeight;

@property BOOL isFiltered;
@property NSMutableArray<id<ZAViewModelProtocol>> *selectedZAModelViews;
@property ZAViewModelDictionary *presentedZAModelViewDict;

@end

@implementation ZAPickerViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self = [self initWithNibName:@"ZAPickerView" bundle:nil];
    }
    return self;
}

- (void) viewDidLoad {
    [self setupPickerView];
}

- (void) setupPickerView {
    // init
    self.selectedZAModelViews = [[NSMutableArray alloc] init];
    self.isFiltered = false;
    
    // datasource + delegate:
    self.zaCollectionView.zaCollectionViewDataSource = self;
    self.zaCollectionView.zaCollectionViewDelegate = self;
    self.zaTableView.zaTableViewDataSource = self;
    self.zaTableView.zaTableViewDelegate = self;
    self.searchBar.delegate = self;
    
    
    // setup CollecitonView:
    self.zaCollectionViewHeight.constant = 0;
    
    // setup NavigationBar:
    [self setupNavigationBar];
    [self setupSearchBar];
}

- (void) setupSearchBar {
    // placeholder posiotion
    NSInteger placeholderWidth = 160;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIOffset offset = UIOffsetMake((screenWidth - placeholderWidth)/2, 0);
    self.searchBar.placeholder = @"Nhập tên bạn bè";
    [self.searchBar setPositionAdjustment:offset forSearchBarIcon:UISearchBarIconSearch];
    
    // backgroundColor:
    self.searchBar.translucent = false;
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.barTintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    // offset:
    self.searchBar.layoutMargins = UIEdgeInsetsMake(10, 10, 2, 2);
}

- (void) setupNavigationBar {
    // TITLE:
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];;
    // UILabel: top
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 22)];
    topLabel.text = @"Chọn bạn";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont systemFontOfSize:16];
    // UILabel: bottom:
    UILabel *botLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 150, 22)];
    botLabel.textAlignment = NSTextAlignmentCenter;
    botLabel.text = @"Đã chọn: 0";
    botLabel.font = [UIFont systemFontOfSize:11];
    botLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    botLabel.tag = 10;
    // add subviews:
    [view addSubview:topLabel];
    [view addSubview:botLabel];
    self.navigationBar.topItem.titleView = view;
    
    // Button Send Message:
    self.btnSendSMS.enabled = false;
    
    // Button Cancel:
    self.btnCancel.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    [self.btnCancel setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // color:
    self.navigationBar.barTintColor = [UIColor whiteColor];
}

# pragma mark - ZACollectionView DataSource.
- (NSMutableArray<id<ZAViewModelProtocol>>*) zaModelsListForZACollectionView:(ZACollectionView *) zaCollectionView {
    return self.selectedZAModelViews;
}

# pragma mark - ZACollectionView delegate:
- (void) ZACollectionView:(ZACollectionView *)zaCollectionView didSelectZAModel:(id<ZAViewModelProtocol>)selectedZAModel {
    if ([self.pickerDataSource respondsToSelector:@selector(zaModelDictForPickerView:)]) {
        self.presentedZAModelViewDict = [self.pickerDataSource zaModelDictForPickerView:self];
    }

    self.isFiltered = false;
    [self.zaTableView reloadZATableView];
    self.searchBar.text = @"";
    [self.view endEditing:true];
    
    // scroll to selected selected ZAModel.
    NSInteger sectionIndex = [self.presentedZAModelViewDict getGroupIndexOfZAViewModel:selectedZAModel];
    NSInteger rowIndex = [self.presentedZAModelViewDict getIndexOfZAViewModelInGroup:selectedZAModel];
    if (sectionIndex >= 0 && rowIndex >= 0) {
        [_zaTableView scrollToIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
    }
}

# pragma mark - ZATableView DataSource.
- (ZAViewModelDictionary*) zaModelDictForZATableView:(ZATableView *) zaTableView {
    return self.presentedZAModelViewDict;
}

- (BOOL)isShowedHeaderViewForZATableView:(ZATableView *) zaTableView {
    return !self.isFiltered;
}

# pragma mark - ZATableView Delegate.
- (void) zaTableView:(ZATableView *)zaTableView didSelectZAViewModel:(id<ZAViewModelProtocol>) selectedZAModelView {
    // expand if height == 0.
    if (self.zaCollectionViewHeight.constant == 0) {
        self.zaCollectionViewHeight.constant = 40;
        [UIView animateWithDuration:0.1 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    // add to zaCollectionView.
    [self.zaCollectionView addAZAModelview:selectedZAModelView atIndex:self.selectedZAModelViews.count];
    
    // update UI
    self.btnSendSMS.enabled = true;                     // enable btnSendMessage.
    [self updateNavigationBarTitle];                        // update NavigationBarTile
}

- (void) zaTableView:(ZATableView *)zaTableView didDeselectZAViewModel:(id<ZAViewModelProtocol>) deselectedZAModel {
    NSUInteger rowIndex = [self.selectedZAModelViews indexOfObject:deselectedZAModel];
    
    // remove and reload :
    [self.zaCollectionView removeZAModelAtIndex:rowIndex];
    
    // Update UI.
    [self updateNavigationBarTitle];
    if (self.selectedZAModelViews.count == 0) {
        self.btnSendSMS.enabled = false;
        
        self.zaCollectionViewHeight.constant = 0;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (BOOL) zaTableView:(ZATableView *)zaTableView isAllowToSelectZAViewModel:(id<ZAViewModelProtocol>) zaModel {
    if (self.selectedZAModelViews.count >= MAX_SELECTED_ZAMODEL) {
        [self alertOverLimitSelection];
        return false;
    }
    return true;
}

- (void) zaTableViewWillBeginDragging:(UIScrollView *) scrollView {
     [self.view endEditing:true];
}

- (void) didPullDown:(ZATableView *)zaTableView completionHandler:(void (^)(void)) callBack {
    if (callBack && [self.pickerDelegate respondsToSelector:@selector(didPullDown:completionHandler:)]) {
        [self.pickerDelegate didPullDown:self.zaTableView completionHandler:^{
            callBack();
        }];
    } else {
        callBack();
    }
}

# pragma mark - SearchBar Delegate:
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *) searchText {
    if ([self.pickerDataSource respondsToSelector:@selector(zaModelDictForPickerView:)]) {
        if (searchText.length == 0) {
            self.presentedZAModelViewDict = [self.pickerDataSource zaModelDictForPickerView:self];
            self.isFiltered = false;
        } else {
            self.presentedZAModelViewDict = [[self.pickerDataSource zaModelDictForPickerView:self] filterByText:searchText];
            self.isFiltered = true;
        }
    }
    
    [self.zaTableView reloadZATableView];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    UIOffset offset = UIOffsetMake(0, 0);
    [self.searchBar setPositionAdjustment:offset forSearchBarIcon:UISearchBarIconSearch];
    
    // force stop scroll
    [self.zaTableView stopScrollingZATableView];
}

# pragma mark - Public methods:
- (void) reloadPickerView {
    if ([self.pickerDataSource respondsToSelector:@selector(zaModelDictForPickerView:)]) {
        self.presentedZAModelViewDict = [self.pickerDataSource zaModelDictForPickerView:self];
    }
    
    // refresh collectionview:
    [self.selectedZAModelViews removeAllObjects];
    self.zaCollectionViewHeight.constant = 0;
    
    // reload NavigationBarTitle:
    [self updateNavigationBarTitle];
    
    // disable button:
    self.btnSendSMS.enabled = false;
    
    [self.zaTableView reloadZATableView];
    [self.zaCollectionView reloadZACollectionView];
}

# pragma mark - Private methods:
- (void) updateNavigationBarTitle {
    NSUInteger totalSelectedZAModels = self.selectedZAModelViews.count;
    NSArray *subViews = self.navigationBar.topItem.titleView.subviews;
    for (UILabel *view in subViews) {
        if (view.tag == 10) {
            view.text = [NSString stringWithFormat:@"Đã chọn: %@", @(totalSelectedZAModels)];
            [UIView animateWithDuration:0.2 animations:^{
                view.transform = CGAffineTransformScale(view.transform, 2.5, 2.5);
                view.transform = CGAffineTransformScale(view.transform, (float)1/2.5, (float)1/2.5);
            }];
            
        }
    }
}

- (void) alertOverLimitSelection {
    NSString *alertContent;
    alertContent = [[NSString alloc] initWithFormat:@"Bạn không được chọn quá %d người",MAX_SELECTED_ZAMODEL];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Warning" message:alertContent preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:alertAction];
    [self presentViewController:alertView animated:true completion:nil];
}

# pragma mark - Events:
- (IBAction) tappedBtnSendSMS:(id) sender {
    // selected phonenumbers:
    NSMutableArray *selectedPhoneNumbers = [[NSMutableArray alloc] init];
    for (id<ZAViewModelProtocol> zaModel in self.selectedZAModelViews) {
        if (zaModel.phoneNumber) {
            [selectedPhoneNumbers addObject:zaModel.phoneNumber];
        }
    }
    
    // nsArray to string.
    NSString *alertContent = @"";
    for (NSString *phoneNumber in selectedPhoneNumbers) {
        if (phoneNumber == selectedPhoneNumbers[selectedPhoneNumbers.count-1]) {
            alertContent = [alertContent stringByAppendingFormat:@"%@.",phoneNumber];
        } else {
            alertContent = [alertContent stringByAppendingFormat:@"%@, ",phoneNumber];
        }
    }
    
    // create alertView.
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Send SMS to:" message:alertContent preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:alertAction];
    
    // show alert view.
    [self presentViewController:alertView animated:true completion:nil];
}

- (IBAction)tappedCancel:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

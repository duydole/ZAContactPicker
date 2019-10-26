#import <Foundation/Foundation.h>
#import "ZAContactPickerViewController.h"
#import "ZAContactBusiness.h"
#import "ZAContactViewModel.h"

@interface ZAContactPickerViewController() <ZAPickerViewControllerDataSource, ZAPickerViewControllerDelegate>

@property UIActivityIndicatorView *indicatorView;
@property ZAViewModelDictionary *contactViewModelDict;

@end

@implementation ZAContactPickerViewController

- (void) feature2Implementation {
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadingDataState];
    [self loadData];
}

- (void) setup {
    // init:
    self.contactViewModelDict = [[ZAViewModelDictionary alloc] init];
    self.pickerDataSource = self;
    
    // setup views:
    [self setupIndicator];
}

- (void) setupIndicator {
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    self.indicatorView.color = [UIColor grayColor];
    [self.view addSubview:self.indicatorView];
}

- (void) loadingDataState {
    [self.indicatorView startAnimating];
}

- (void) didLoadDataState {
    [self.indicatorView stopAnimating];
}

- (void) loadData {
    [ZAContactBusiness.sharedInstance loadContactDTOsWithCompletionHandler:^(NSArray<ZAContactModel *> *zaContactModels, NSError *error) {
        if (!error) {
            for (ZAContactModel *contactModel in zaContactModels) {
                ZAContactViewModel *contactViewModel = [[ZAContactViewModel alloc] initWithZAContactModel:contactModel];
                [self.contactViewModelDict addAZAViewModel:contactViewModel];
            }
            [self reloadPickerView];
            [self didLoadDataState];
        } else {
            [self alertViewWithCode:error.code];
            [self reloadPickerView];
            [self didLoadDataState];
        }
    } callbackBlockOn:dispatch_get_main_queue()];
}

# pragma mark - PickerView DataSource.
- (ZAViewModelDictionary *) zaModelDictForPickerView:(ZAPickerViewController *)pickerViewController {
    return self.contactViewModelDict;
}

# pragma mark - PickerView Delegate:
- (void) didPullDown:(ZATableView *) zaTableView completionHandler:(void (^)(void))callBack {
    // testing pulldown:
    if (callBack) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack();
            });
        });
    }
}

# pragma mark - Private methods:
- (void) alertViewWithCode: (ContactErrorCode) errorCode {
    NSString *alertContent;
    switch (errorCode) {
        case ContactErrorCodeAccessDenied:
            alertContent = @"Please allow us to access contact in Setting > ZAContactPicker.";
            break;
        default:
            alertContent = @"Something wrong";
            break;
    }
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Warning!" message:alertContent preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:alertAction];
    [self presentViewController:alertView animated:true completion:nil];
}

@end

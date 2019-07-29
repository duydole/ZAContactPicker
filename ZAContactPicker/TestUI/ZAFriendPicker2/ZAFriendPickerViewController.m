#import <Foundation/Foundation.h>
#import "ZAFriendPickerViewController.h"
#import "ZAFriendViewModel.h"

@interface ZAFriendPickerViewController() <ZAPickerViewControllerDataSource>

@property ZAViewModelDictionary *friendDict;
@property UIActivityIndicatorView *indicatorView;

@end

@implementation ZAFriendPickerViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadingDataState];
    
    [self loadData];
}

- (void) loadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        [self addMockDataWithFullname:@"Đỗ Lê Duy" avatarUrl:@"https://scontent.fsgn1-1.fna.fbcdn.net/v/t1.0-9/15037350_371761959828997_356678831024765761_n.jpg?_nc_cat=103&_nc_oc=AQkbJwko7eoZCA8A2mW5VuDmJn6vV2tu8yn__9dpKoY7tJLe1TQocX-zdor_FmQI0P4&_nc_ht=scontent.fsgn1-1.fna&oh=137b9b62021921eae62c400b2fb15210&oe=5DA41A63"];
        
        [self addMockDataWithFullname:@"Nguyễn Võ Hồng Thắng" avatarUrl:@"https://scontent.fsgn1-1.fna.fbcdn.net/v/t1.0-9/66386294_1376148849191104_3322028281422675968_o.jpg?_nc_cat=101&_nc_oc=AQmNAMAuCCZaZnpXT5_BymrMx8vzlpNQQ8cMLFcuOug2MFHYyX8C_-NKnmuHbsmQry4&_nc_ht=scontent.fsgn1-1.fna&oh=99f6cdc1f5be5b8a38d1ba00ad8238e9&oe=5DA6F32E"];
        
        [self addMockDataWithFullname:@"Trường Nguyễn" avatarUrl:@"https://scontent.fsgn1-1.fna.fbcdn.net/v/t1.0-9/57561055_802531533437850_3067544717446086656_o.jpg?_nc_cat=105&_nc_oc=AQnik4QfCIAXJNf4uNZetFnyoXpN6nGc66c_i4H7G3qz4EClCBPJ9xEZ1Nos58SBjac&_nc_ht=scontent.fsgn1-1.fna&oh=ad103bbf78b9c96cf4ebc0bd93d08018&oe=5DA9C031"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadPickerView];
            [self didLoadDataState];
            
        });
    });
}

- (ZAViewModelDictionary *)zaModelDictForPickerView:(ZAPickerViewController *)pickerViewController {
    return self.friendDict;
}

- (void) loadingDataState {
    [self.indicatorView startAnimating];
}

- (void) didLoadDataState {
    [self.indicatorView stopAnimating];
}

- (void) setup {
    self.pickerDataSource = self;
    _friendDict = [[ZAViewModelDictionary alloc] init];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    self.indicatorView.color = [UIColor grayColor];
    [self.view addSubview:self.indicatorView];
}

# pragma mark - private methods:
- (void) addMockDataWithFullname:(NSString*)fullName
                       avatarUrl:(NSString*)url {
    ZAFriendModel *friendModel = [[ZAFriendModel alloc] init];
    friendModel.fullName = fullName;
    friendModel.avatarUrl = url;
    
    ZAFriendViewModel *friendViewModel = [[ZAFriendViewModel alloc] initWithZAFriendModel:friendModel];
    [_friendDict addAZAViewModel:friendViewModel];
}

@end

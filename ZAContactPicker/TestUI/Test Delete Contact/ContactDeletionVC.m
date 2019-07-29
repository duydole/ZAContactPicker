
#import "ContactDeletionVC.h"
#import "ZATableView.h"
#import "ZAContactBusiness.h"

// test:
#define DENIED_ACCESS_CODE 100
#define TURNED_OFF_ACCESS_GRANT_CODE 101
#define NOT_FOUND_CONTACT 200
#define DELETED_SUCCESS 102
#define EMPTY_SELECTED_CONTACTS 103

@interface ContactDeletionVC () <ZATableViewDelegate, ZATableViewDataSource>

@property (weak, nonatomic) IBOutlet ZATableView *myTableView;

@property ZAViewModelDictionary *contactViewModelDict;
@property NSMutableArray *selectedContacts;

@end

@implementation ContactDeletionVC

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self loadData];
    
}

- (void) loadData {
    [ZAContactBusiness.sharedInstance loadContactDTOsWithCompletionHandler:^(NSArray<ZAContactModel *> *zaContactModels, NSError *error) {
        if (!error) {
            for (ZAContactModel *contactModel in zaContactModels) {
                ZAContactViewModel *contactViewModel = [[ZAContactViewModel alloc] initWithZAContactModel:contactModel];
                [self.contactViewModelDict addAZAViewModel:contactViewModel];
            }
            
            [self.myTableView reloadZATableView];
        } else {
            [self showAlertViewWithCode:error.code];
        }
    } callbackBlockOn:dispatch_get_main_queue()];
}

- (void) setup {
    self.myTableView.zaTableViewDelegate = self;
    self.myTableView.zaTableViewDataSource = self;

    self.contactViewModelDict = [[ZAViewModelDictionary alloc] init];
    self.selectedContacts = [[NSMutableArray alloc] init];
}

// data source:
- (ZAViewModelDictionary *)zaModelDictForZATableView:(ZATableView *)contactTableView {
    return self.contactViewModelDict;
}

- (ZAViewModelDictionary *)zaViewModelDictForZATableView:(ZATableView *)zaTableView {
    return nil;
}

// delegate:
- (void)zaTableView:(ZATableView *)contactTableView didSelectZAViewModel:(id<ZAViewModelProtocol>)selectedContact {
    [self.selectedContacts addObject:selectedContact];
}

- (void) zaTableView:(ZATableView *) zaTableView didDeselectZAViewModel:(id<ZAViewModelProtocol>) deselectedZAModel {
    [self.selectedContacts removeObject:deselectedZAModel];
}

// events:
- (IBAction) deleteContacts:(id) sender {
    if (self.selectedContacts.count > 0) {
        [self showWarningDeletionAlertView];    
    } else {
        [self showAlertViewWithCode:EMPTY_SELECTED_CONTACTS];
    }
}

- (void) deleteSelectedContacts {
    for (ZAContactModel *contactModel in self.selectedContacts) {
        [ZAContactBusiness.sharedInstance deleteAZAContactModel:contactModel completionHandler:^(BOOL deleted, NSError *error) {
            if (deleted) {
                [self showAlertViewWithCode:DELETED_SUCCESS];
                [self.myTableView reloadZATableView];
                self.selectedContacts = [[NSMutableArray alloc] init];
            } else {
                [self showAlertViewWithCode:error.code];
            }
        } callbackBlockOn:dispatch_get_main_queue()];
    }
}

- (void) showAlertViewWithCode: (NSUInteger) code {
    NSString *alertContent;
    switch (code) {
        case DENIED_ACCESS_CODE:
            alertContent = @"You denied our access.";
            break;
        case TURNED_OFF_ACCESS_GRANT_CODE:
            alertContent = @"Please allow us to access contact in setting.";
            break;
        case NOT_FOUND_CONTACT:
            alertContent = @"Không tìm thấy Contact trong ContactsBook.";
            break;
        case DELETED_SUCCESS:
            alertContent = [[NSString alloc] initWithFormat:@"Đã xoá %lu Contacts.",(unsigned long)self.selectedContacts.count];
            break;
        case EMPTY_SELECTED_CONTACTS:
            alertContent = @"Chưa chọn Contact";
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

- (void) showWarningDeletionAlertView {
    NSString *alertMessage = [[NSString alloc] initWithFormat:@"Bạn có chắc muốn xoá %lu Contacts đã chọn?",(unsigned long)self.selectedContacts.count];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Warning!" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmedAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSelectedContacts];
    }];
    
    [alertView addAction:cancleAction];
    [alertView addAction:confirmedAction];
    
    [self presentViewController:alertView animated:true completion:nil];
}

- (void) didPullDown:(ZATableView *)zaTableView completionHandler:(void (^)(void))callBack {
    if (callBack) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [NSThread sleepForTimeInterval:2];
            callBack();
        });
    }
}

- (IBAction) addNewContact:(id) sender {
    ZAContactModel *newContact = [[ZAContactModel alloc] init];
    newContact.firstName = @"NEW";
    newContact.lastName = @"CONTACT";
    newContact.phoneNumbers[0] = @"12012409127470";
    
    [ZAContactBusiness.sharedInstance addNewZAContactModel:newContact completionHandler:^(BOOL success, NSError *error) {
        
    } callbackBlockOn:dispatch_get_main_queue()];
}

@end

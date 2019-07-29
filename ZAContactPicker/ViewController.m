#import "ViewController.h"
#import "ZAPickerViewController.h"
#import "ZAFriendPickerViewController.h"
#import "ZAContactPickerViewController.h"
#import "ContactDeletionVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (IBAction) moveToFriendPickerViewController:(id)sender {
    ZAFriendPickerViewController *friendPickerViewController = [[ZAFriendPickerViewController alloc] init];
    [self presentViewController:friendPickerViewController animated:YES completion:nil];
}

- (IBAction) moveToContactPickerViewController:(id)sender {
    ZAContactPickerViewController *contactPickerViewController = [[ZAContactPickerViewController alloc] init];
    [self presentViewController:contactPickerViewController animated:YES completion:nil];
}

@end

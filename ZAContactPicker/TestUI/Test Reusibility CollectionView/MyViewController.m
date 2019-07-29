#import <Foundation/Foundation.h>
#import "MyViewController.h"
#import "ZACollectionView.h"

@interface MyViewController() <ZACollectionViewDelegate, ZACollectionViewDataSource>

@property (weak, nonatomic) IBOutlet ZACollectionView *zaCollectionView;

@property NSMutableArray *contactsList;

@end

@implementation MyViewController

- (void) viewDidLoad {
    
    [self setup];
    
    // mock data:
    for (int i = 0; i < 5; i++) {
        ZAContactModel *model = [[ZAContactModel alloc] init];
        model.firstName = @"DO";
        model.lastName = @"AN";
        model.fullName = @"DO LE DUY";
        model.identifier = @"999";
        
        ZAContactViewModel *modelView = [[ZAContactViewModel alloc] initWithZAContactModel:model];
        
        [self.contactsList addObject:modelView];
    }
    
    // reload:
    [self.zaCollectionView reloadZACollectionView];
}

- (void) setup {
    _zaCollectionView.zaCollectionViewDataSource = self;
    _zaCollectionView.zaCollectionViewDelegate = self;
    _contactsList = [[NSMutableArray alloc] init];
}

# pragma mark - datasource
- (NSMutableArray *) zaModelsListForZACollectionView:(ZACollectionView *) contactCollectionView {
    return self.contactsList;
}

# pragma mark - delegate
- (void) ZACollectionView:(ZACollectionView *)zaCollectionView didSelectZAModel:(id<ZAViewModelProtocol>) selectedZAModel {
    NSLog(@"Selected model id: %@",selectedZAModel.identifier);
}

# pragma mark - Events:
- (IBAction) addNewItem:(id) sender {
    // mock new model:
    ZAContactModel *model = [[ZAContactModel alloc] init];
    model.firstName = @"DO";
    model.lastName = @"DUY";
    model.fullName = @"DO LE DUY";
    model.identifier = @"999";
    
    ZAContactViewModel *modelView = [[ZAContactViewModel alloc] initWithZAContactModel:model];
    
    [self.zaCollectionView addAZAModelview:modelView atIndex:self.contactsList.count];
}

- (IBAction) deleteFisrtItem:(id) sender {
    [self.zaCollectionView removeZAModelAtIndex:0];
}




@end

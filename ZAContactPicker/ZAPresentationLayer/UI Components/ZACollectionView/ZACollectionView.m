#import "Cell/ZACollectionViewCell.h"
#import "ZACollectionView.h"
#import "../../Utilities/ZAModelImageCache.h"

@interface ZACollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property UICollectionView *zaCollectionView;
@property (nonatomic) NSMutableArray *ZAViewModelsList;
@property UIImage *defaultZAModelImage;

@end

@implementation ZACollectionView

- (instancetype) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    // setup ZACollectionView:
    [self setupZACollectionView];
    
    // init:
    self.ZAViewModelsList = [[NSMutableArray alloc] init];
    
    // create defaultImage:
    self.defaultZAModelImage = [UIImage imageNamed:@"defaultZAModelImage"];
}

- (void) setupZACollectionView {
    // init
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(35, 35);
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _zaCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    
    _zaCollectionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _zaCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _zaCollectionView.clipsToBounds = YES;

    // register cell:
    [_zaCollectionView registerNib:[UINib nibWithNibName:@"ZACollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZACollectionViewCellId"];
    
    // datasource, delegate
    _zaCollectionView.dataSource = self;
    _zaCollectionView.delegate = self;
    
    // add to self:
    [self addSubview:_zaCollectionView];
    
    // add Constraints:
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:_zaCollectionView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:self
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:_zaCollectionView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    
    NSLayoutConstraint *centerX =[NSLayoutConstraint
                                  constraintWithItem:_zaCollectionView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:0
                                  toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                  constant:0];
    
    NSLayoutConstraint *centerY =[NSLayoutConstraint
                                  constraintWithItem:_zaCollectionView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:0
                                  toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                  constant:0];
    
    [self addConstraint:width];
    [self addConstraint:height];
    [self addConstraint:centerX];
    [self addConstraint:centerY];
}

# pragma mark - CollectionView Darasource:
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // new cell:
    ZACollectionViewCell *cell = [_zaCollectionView dequeueReusableCellWithReuseIdentifier:@"ZACollectionViewCellId" forIndexPath:indexPath];
    
    // get model:
    id<ZAViewModelProtocol> zaViewModel = self.ZAViewModelsList[indexPath.row];
    
    [cell setModel:zaViewModel];
    
    return cell;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ZAViewModelsList.count;
}

# pragma mark - CollectionView Delegate:
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<ZAViewModelProtocol> selectedZAModel = self.ZAViewModelsList[indexPath.row];
    if ([self.zaCollectionViewDelegate respondsToSelector:@selector(ZACollectionView:didSelectZAModel:)]) {
        [self.zaCollectionViewDelegate ZACollectionView:self didSelectZAModel:selectedZAModel];
    }
    
}

# pragma mark - public methods:
- (void) reloadZACollectionView {
    [self getData];
    [_zaCollectionView reloadData];
}

- (void) removeZAModelAtIndex:(NSUInteger)index {
    if (index >= 0 && index < self.ZAViewModelsList.count) {
        [self.ZAViewModelsList removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [_zaCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void) addAZAModelview:(id<ZAViewModelProtocol>) newZAModelView atIndex:(NSUInteger)index {
    if (index >= 0 && index <= self.ZAViewModelsList.count) {
        // insert:
        [self.ZAViewModelsList insertObject:newZAModelView atIndex:index];
        // insert and reload:
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [_zaCollectionView insertItemsAtIndexPaths:@[indexPath]];
        // scroll:
        [_zaCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:true];
    }
}

# pragma mark - Private methods:
- (void) getData {
    if ([self.zaCollectionViewDataSource respondsToSelector:@selector(zaModelsListForZACollectionView:)]) {
        self.ZAViewModelsList = [self.zaCollectionViewDataSource zaModelsListForZACollectionView:self];
    }
}

@end

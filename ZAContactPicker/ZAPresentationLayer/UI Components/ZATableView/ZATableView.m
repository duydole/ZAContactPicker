#import "ZATableView.h"
#import "ZAModelImageCache.h"
#import "ZAViewModelDictionary.h"

@interface ZATableView() <UITableViewDelegate, UITableViewDataSource>

@property UITableView *zaTableView;
@property ZAViewModelDictionary * presentedZAViewModelDict;
@property BOOL isShowedHeaderView;
@property UIImage *defaultZAModelImage;
@property UIRefreshControl *zaRefreshControl;

@end

@implementation ZATableView

- (instancetype) initWithCoder:(NSCoder *) coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    // setup ZATableView:
    [self setupZATableView];
    
    // create defaultImage:
    self.defaultZAModelImage = [UIImage imageNamed:@"defaultZAModelImage"];
    
    // refreshControl:
    self.zaRefreshControl = [[UIRefreshControl alloc] init];
    self.zaRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.zaRefreshControl addTarget:self action:@selector(refreshZATableView) forControlEvents:UIControlEventValueChanged];
    [self.zaTableView addSubview:self.zaRefreshControl];
    
    // filtered:
    self.isShowedHeaderView = true;
}

- (void) setupZATableView {
    
    // setup tableView:
    _zaTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    _zaTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _zaTableView.clipsToBounds = YES;
    _zaTableView.dataSource = self;
    _zaTableView.delegate = self;
    
    // register cell:
    [_zaTableView registerNib:[UINib nibWithNibName:@"ZATableViewCell" bundle:nil] forCellReuseIdentifier:@"ZATableViewCell"];
    
    // circle selection button.
    [_zaTableView setEditing:YES];
    
    // separator:
    //_zaTableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
    //_zaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // not work
    _zaTableView.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);

    
    // add tableview:
    [self addSubview:_zaTableView];
    
    // add constraints:
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:_zaTableView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:self
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:_zaTableView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    
    NSLayoutConstraint *centerX =[NSLayoutConstraint
                                 constraintWithItem:_zaTableView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:0
                                 toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0
                                 constant:0];
    
    NSLayoutConstraint *centerY =[NSLayoutConstraint
                                  constraintWithItem:_zaTableView
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

# pragma mark - UITableView Datasource.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZATableViewCell"];
    
    // get ZAViewModelProtocol
    id<ZAViewModelProtocol> zaViewModel = [self.presentedZAViewModelDict getZAViewModelAtGroupIndex:indexPath.section indexInGroup:indexPath.row];

    // set model:
    [cell setModel:zaViewModel];
    
    if (zaViewModel.isSelected) {
        [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presentedZAViewModelDict getSizeOfGroupWithGroupIndex:section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.presentedZAViewModelDict.numbOfGroupKeys;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isShowedHeaderView) {
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.text = [NSString stringWithFormat:@"  %@",self.presentedZAViewModelDict.sortedGroupKeys[section]];
        headerLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        [headerLabel setFont:[UIFont systemFontOfSize:14]];
        return headerLabel;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.6)];
    separatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [footerView addSubview:separatorView];
    return footerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isShowedHeaderView) {
        return 20;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isShowedHeaderView) {
        return 10;
    }
    return 0;
}

- (NSArray<NSString *> *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.presentedZAViewModelDict.sortedGroupKeys;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

# pragma mark - UITableView Delegate
- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    id<ZAViewModelProtocol> willBeSelectedZAViewModel = [self.presentedZAViewModelDict getZAViewModelAtGroupIndex:indexPath.section indexInGroup:indexPath.row];
    [self.zaTableView cellForRowAtIndexPath:indexPath].selectedBackgroundView = [[UIView alloc] init];
    if ([self.zaTableViewDelegate respondsToSelector:@selector(zaTableView:isAllowToSelectZAViewModel:)]) {
        if ([self.zaTableViewDelegate zaTableView:self isAllowToSelectZAViewModel:willBeSelectedZAViewModel]) {
            return indexPath;
        } else {
            return nil;
        }
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<ZAViewModelProtocol> selectedZAViewModel = [self.presentedZAViewModelDict getZAViewModelAtGroupIndex:indexPath.section indexInGroup:indexPath.row];
    selectedZAViewModel.isSelected = true;

    if ([self.zaTableViewDelegate respondsToSelector:@selector(zaTableView:didSelectZAViewModel:)]) {
        [self.zaTableViewDelegate zaTableView:self didSelectZAViewModel:selectedZAViewModel];
    }
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<ZAViewModelProtocol> deselectedZAModel = [self.presentedZAViewModelDict getZAViewModelAtGroupIndex:indexPath.section indexInGroup:indexPath.row];
    deselectedZAModel.isSelected = false;
    if ([self.zaTableViewDelegate respondsToSelector:@selector(zaTableView:didDeselectZAViewModel:)]) {
        [self.zaTableViewDelegate zaTableView:self didDeselectZAViewModel:deselectedZAModel];
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.zaTableViewDelegate respondsToSelector:@selector(zaTableViewWillBeginDragging:)]) {
        [self.zaTableViewDelegate zaTableViewWillBeginDragging:scrollView];
    }
}

# pragma mark - Private Methods
- (void) refreshZATableView {
    if ([self.zaTableViewDelegate respondsToSelector:@selector(didPullDown:completionHandler:)]) {
        [self.zaTableViewDelegate didPullDown:self completionHandler:^{
                 [self.zaRefreshControl endRefreshing];
        }];
    } else {
        [self.zaRefreshControl endRefreshing];
    }
}

# pragma mark - Public methods:
- (void) reloadZATableView {
    if ([self.zaTableViewDataSource respondsToSelector:@selector(isShowedHeaderViewForZATableView:)]) {
        self.isShowedHeaderView = [self.zaTableViewDataSource isShowedHeaderViewForZATableView:self];
    }
    
    if ([self.zaTableViewDataSource respondsToSelector:@selector(zaModelDictForZATableView:)]) {
        self.presentedZAViewModelDict = [self.zaTableViewDataSource zaModelDictForZATableView:self];
    }

    // if data is empty:
    if (self.presentedZAViewModelDict.numbOfGroupKeys == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

        if (self.isShowedHeaderView) {
            label.text = @"Không có dữ liệu";                       // not filtered.
        } else {
            label.text = @"Không tìm thấy kết quả phù hợp";         // filter.
        }

        label.textAlignment = NSTextAlignmentCenter;
        _zaTableView.backgroundView = label;
    } else {
        _zaTableView.backgroundView = nil;
    }

    // reload
    [_zaTableView reloadData];

    // scroll to top:
    if (self.presentedZAViewModelDict.numbOfGroupKeys > 0) {
        [_zaTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

- (void) stopScrollingZATableView {
    [_zaTableView setContentOffset:_zaTableView.contentOffset animated:NO];
}

- (void) scrollToIndexPath:(NSIndexPath *)indexPath {
    [_zaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
@end



#import "ContactTableView.h"

@interface ContactTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ContactTableView

- (instancetype)initWithCoder:(NSCoder *) coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    // circle selection button.
    [self setEditing:true];
    
    //
    self.dataSource = self;
    self.delegate = self;
    
    // separator:
    self.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
}

// MARK: TABLE VIEW DATASOURCE:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell"];
    id<ZAContactModelProtocol> contact = [self.presentedContactDict getContactBySectionIndex:indexPath.section rowIndex:indexPath.row];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // set data for cell:
    cell.image.image = contact.contactUIImage;
    cell.title.text = contact.fullName;
//    if (contact.isSelected) {
//        [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionNone];
//    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [self.presentedContactDict getSizeOfSectionWitSectionIndex:section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return self.presentedContactDict.numbOfSection;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section {

    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = [NSString stringWithFormat:@"  %@",self.presentedContactDict.allSortedSectionKeys[section]];
    headerLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    [headerLabel setFont:[UIFont systemFontOfSize:14]];
    
    return headerLabel;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.6)];
    separatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [footerView addSubview:separatorView];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (NSArray<NSString *> *) sectionIndexTitlesForTableView:(UITableView *) tableView {
    return self.presentedContactDict.allSortedSectionKeys;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}


// MARK: TABLEVIEW DELEGATE:
- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *willBeSelectedContact = [self.presentedContactDict getContactBySectionIndex:indexPath.section rowIndex:indexPath.row];
    if ([self.contactDelegate respondsToSelector:@selector(contactTableView:isAllowToSelectContact:)]) {
        if ([self.contactDelegate contactTableView:self isAllowToSelectContact:willBeSelectedContact]) {
            return indexPath;
        } else {
            return nil;
        }
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    Contact *selectedContact = [self.presentedContactDict getContactBySectionIndex:indexPath.section rowIndex:indexPath.row];

    if ([self.contactDelegate respondsToSelector:@selector(contactTableView:didSelectContact:)]) {
        [self.contactDelegate contactTableView:self didSelectContact:selectedContact];
    }

    // selectedBackgroundView = nil;
    [self cellForRowAtIndexPath:indexPath].selectedBackgroundView = [[UIView alloc] init];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *) indexPath {
    Contact *deselectedContact = [self.presentedContactDict getContactBySectionIndex:indexPath.section rowIndex:indexPath.row];
    if ([self.contactDelegate respondsToSelector:@selector(contactTableView:didDeselectContact:)]) {
        [self.contactDelegate contactTableView:self didDeselectContact:deselectedContact];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
    if ([self.contactDelegate respondsToSelector:@selector(didScrollTableView:)]) {
        [self.contactDelegate didScrollTableView:scrollView];
    }
}



// MARK: Methods:
- (void) reloadTableView {
    // get DataSource
    self.presentedContactDict = [self.contactDataSource contactDictForContactTableView:self];
    
    // check datasource:
    if (self.presentedContactDict.numbOfSection == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.text = @"Không tìm thấy kết quả phù hợp";
        label.textAlignment = NSTextAlignmentCenter;
        self.backgroundView = label;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    // reload
    [self reloadData];
}

- (void) stopScrolling {
    [self setContentOffset:self.contentOffset animated:NO];
}

@end

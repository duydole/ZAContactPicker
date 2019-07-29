#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "ZAContactModel.h"
#import "ContactTableViewCell.h"
#import "ZAContactDictModel.h"

@class ContactTableView;

// Delegate protocol:
@protocol ZAContactTableViewDelegate <NSObject>

@optional
- (void) contactTableView:(ContactTableView*)contactTableView didSelectContact:(id<ZAContactModelProtocol>) selectedContact;
- (void) contactTableView:(ContactTableView*)contactTableView didDeselectContact:(id<ZAContactModelProtocol>) deselectedContact;
- (void) didScrollTableView:(UIScrollView*)scrollView;
- (BOOL) contactTableView:(ContactTableView*)contactTableView isAllowToSelectContact:(id<ZAContactModelProtocol>) contact;

@end

// DataSource protocol:
@protocol ContactTableViewDataSource <NSObject>

@required
- (id<ZAContactDictModelProtocol>) contactDictForContactTableView:(ContactTableView*) contactTableView;

@end


// Interface:
@interface ContactTableView : UITableView

@property (nonatomic) id<ZAContactDictModelProtocol> presentedContactDict;
@property (nonatomic, weak) IBOutlet id<ZAContactTableViewDelegate> contactDelegate;
@property (nonatomic, weak) IBOutlet id<ContactTableViewDataSource> contactDataSource;

- (void) reloadTableView;
- (void) stopScrolling;

@end

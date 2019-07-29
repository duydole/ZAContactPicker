#import <UIKit/UIKit.h>
#import "ZAContactViewModel.h"

@interface ZATableViewCell : UITableViewCell

@property (weak, nonatomic) id<ZAViewModelProtocol> model;

@end

#import <UIKit/UIKit.h>
#import "ZAContactViewModel.h"

@interface ZACollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<ZAViewModelProtocol> model;

@end

#import <Foundation/Foundation.h>
#import "ZACollectionViewCell.h"
#import "ZAModelImageCache.h"

@interface ZACollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *zaModelImageView; // UIImageView for cell.

@end

@implementation ZACollectionViewCell

- (void) setModel:(id<ZAViewModelProtocol>)model {
    // check Cached Image.
    UIImage *cachedImage = [ZAModelImageCache.sharedInstance getImageById:model.identifier];
    
    if (!cachedImage) {
        cachedImage = [model getZAViewModelImage];
        [ZAModelImageCache.sharedInstance storeImage:cachedImage byId:model.identifier];
    }
    
    // set data:
    _zaModelImageView.image = cachedImage;
}
@end

#import "ZATableViewCell.h"
#import "ZAModelImageCache.h"

@interface ZATableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *zaModelImageView;     // image for cell
@property (weak, nonatomic) IBOutlet UILabel *zaModelTitle;

@end

@implementation ZATableViewCell

- (void)setModel:(id<ZAViewModelProtocol>)model {
    // check Cached Image.
    UIImage *cachedImage = [ZAModelImageCache.sharedInstance getImageById:model.identifier];
    
    if (!cachedImage) {
        cachedImage = [model getZAViewModelImage];
        [ZAModelImageCache.sharedInstance storeImage:cachedImage byId:model.identifier];
    }
    
    // set data:
    _zaModelImageView.image = cachedImage;
    _zaModelTitle.text = model.fullName;
}

@end

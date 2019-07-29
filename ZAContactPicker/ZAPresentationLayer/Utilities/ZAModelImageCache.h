#import "UIKit/UIKit.h"

@interface ZAModelImageCache : NSObject

+ (id) sharedInstance;

/**
 Store UIImage in cache with Id.

 @param image : UIImage will be stored in cache.
 @param imageId : id of UIImage.
 */
- (void) storeImage: (UIImage *)image
               byId: (NSString *)imageId;

/**
 Get UIImage from cache by Id.

 @param imageId : Image Id.
 @return image if it exists in cache, nil if not.
 */
- (UIImage*) getImageById: (NSString *)imageId;

@end

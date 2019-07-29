#import "ZAModelImageCache.h"

@interface ZAModelImageCache()

@property NSCache *imageCache;
@property NSInteger maxMemory;                  // max memory for cache (bytes)

@end

@implementation ZAModelImageCache

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

+ (id) sharedInstance {
    static ZAModelImageCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) setup {
    self.imageCache = [[NSCache alloc] init];
    self.maxMemory = 5*1024*1024;                               // 5Mb.
     self.imageCache.totalCostLimit = self.maxMemory;
}

- (void) storeImage:(UIImage *)image
               byId:(NSString *)imageId {
    if (image) {
        NSUInteger imageSize  = CGImageGetHeight(image.CGImage) * CGImageGetBytesPerRow(image.CGImage);
        [self.imageCache setObject:image forKey:imageId cost:imageSize];
    }
}

- (UIImage*) getImageById:(NSString *)imageId {
    return [self.imageCache objectForKey:imageId];
}

@end

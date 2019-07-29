#import "ZAContactBusiness.h"
#import "ContactDTO.h"

@interface ZAContactBusiness()

@property dispatch_queue_t contactBusinessSerialQueue;      // Serialqueue for BusinessLayer.

@end

@implementation ZAContactBusiness

- (instancetype) init {
    self = [super init];
    if (self) {
        _contactBusinessSerialQueue = dispatch_queue_create("duydl.contactBusiness.serialqueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (id) sharedInstance {
    static ZAContactBusiness *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

# pragma mark - Public methods:
- (void) loadContactDTOsWithCompletionHandler:(void (^)(NSArray<ZAContactModel *> *, NSError *))callBack
                                 callbackBlockOn:(dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        [ZAContactManager.sharedInstance fetchContactsBookWithCompletionHandler:^(NSArray<ContactDTO *> *contactDTOs, NSError *error) {
            if (!error) {
                NSMutableArray *zaContactModels = [[NSMutableArray alloc] init];
                for (ContactDTO* contactDTO in contactDTOs) {
                    if (contactDTO.phoneNumbers.count>0) {
                        ZAContactModel *zaContact = [[ZAContactModel alloc] initWithContactDTO:contactDTO];
                        [zaContactModels addObject:zaContact];
                    }
                }
                dispatch_async(completionQueue, ^{
                    callBack(zaContactModels,nil);
                });
            } else {
                dispatch_async(completionQueue, ^{
                    callBack(nil,error);
                });
            }
        } callbackBlockOn:_contactBusinessSerialQueue];
    }
}

- (void) deleteAZAContactModel: (ZAContactModel *)contact
             completionHandler: (void (^)(BOOL, NSError *))callBack
               callbackBlockOn: (dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        [ZAContactManager.sharedInstance deleteContactFromContactBookById:contact.identifier completionHandler:^(BOOL deleted, NSError *error) {
            dispatch_async(completionQueue, ^{
                callBack(deleted,error);
            });
        } callbackBlockOn:_contactBusinessSerialQueue];
    }
}

- (void) addNewZAContactModel: (ZAContactModel *)newContact
            completionHandler: (void (^)(BOOL, NSError *))callBack
              callbackBlockOn: (dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        dispatch_async(_contactBusinessSerialQueue, ^{
            // ZAContactModel to ContactDTO
            ContactDTO *newContactDTO = [[ContactDTO alloc] init];
            newContactDTO.firstName = newContact.firstName;
            newContactDTO.lastName = newContact.lastName;
            newContactDTO.phoneNumbers = newContact.phoneNumbers;
            
            [ZAContactManager.sharedInstance addContactIntoContactsBook:newContactDTO
                                               completionHandler:^(BOOL success, NSError *error) {
                dispatch_async(completionQueue, ^{
                    callBack(success,error);
                });
            } callbackBlockOn:self.contactBusinessSerialQueue];
        });
    }
}

- (void) getAvatarOfZAContactModelById:(NSString *)contactId
                     completionHandler:(void (^)(NSData *, NSError *))callBack
                       callbackBlockOn:(dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        [ZAContactManager.sharedInstance getContactAvatarById:contactId completionHandler:^(NSData *imageData, NSError *error) {
            dispatch_async(completionQueue, ^{
                callBack(imageData,error);
            });
        } callbackBlockOn:_contactBusinessSerialQueue];
    }
}

@end

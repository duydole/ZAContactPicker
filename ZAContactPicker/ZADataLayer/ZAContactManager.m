#import <Foundation/Foundation.h>
#import "ZAContactManager.h"

@interface ZAContactManager()

@property CNContactStore *contactStore;
@property dispatch_queue_t contactManagerSerialQueue;
@property NSMutableDictionary *callBacksDict;
@property NSMutableArray *queuesArr;
@property BOOL isFetching;

@end

@implementation ZAContactManager

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

+ (id) sharedInstance {
    static ZAContactManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) setup {
    self.contactStore = [[CNContactStore alloc] init];
    self.contactManagerSerialQueue = dispatch_queue_create("duydl.contactmanager.serialqueue", DISPATCH_QUEUE_SERIAL);
    _callBacksDict = [[NSMutableDictionary alloc] init];
    _isFetching = false;
    _queuesArr = [[NSMutableArray alloc] init];
}

# pragma mark - Public methods:
- (BOOL) checkPermission {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    return (status == CNAuthorizationStatusAuthorized);
}

- (ContactAuthorizationStatus) getContactAuthorizationStatus {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized:
            return ContactAuthorizationStatusAuthorized;
            break;
        case CNAuthorizationStatusNotDetermined:
            return ContactAuthorizationStatusNotDetermined;
            break;
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted:
            return ContactAuthorizationStatusDenied;
            break;
    }
}

- (void) requestAccessForContactsBook:(void (^)(BOOL, NSError *))callBack {
    ContactAuthorizationStatus status = [self getContactAuthorizationStatus];
    switch (status) {
        case ContactAuthorizationStatusAuthorized:
            callBack(true,nil);
            break;
        case ContactAuthorizationStatusDenied:
            callBack(false,[NSError errorWithDomain:@"ContactManagerDomain" code:ContactErrorCodeAccessDenied userInfo:@{}]);
            break;
        case ContactAuthorizationStatusNotDetermined:
            [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!error) {
                    callBack(granted,nil);
                } else {
                    callBack(false,[NSError errorWithDomain:@"ContactManagerDomain" code:ContactErrorCodeAccessDenied userInfo:@{}]);
                }
            }];
            break;
    }
}

- (void) fetchContactsBookWithCompletionHandler:(LoadDataCompletionBlock)callBack
                                   callbackBlockOn:(dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        dispatch_async(self.contactManagerSerialQueue, ^{
            // save:
            [self storeCompletionQueue:completionQueue withCallback:callBack];
            
            // check isFetching.
            if (!self.isFetching) {
                // Start fetching data:
                self.isFetching = true;
                dispatch_queue_t concurrentQueue = dispatch_queue_create("duydl.contactmanager.concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(concurrentQueue, ^{
                    [self requestAccessForContactsBook:^(BOOL granted, NSError *error) {
                        if (granted) {
                            NSMutableArray *cnContacts;
                            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactNamePrefixKey, CNContactNameSuffixKey, CNContactImageDataKey, CNContactJobTitleKey, CNContactEmailAddressesKey, CNContactMiddleNameKey];
                            NSString *containerId = self.contactStore.defaultContainerIdentifier;
                            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
                            NSError *error;
                            cnContacts = (NSMutableArray*)[self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
                            
                            // if fetch success:
                            if (!error) {
                                NSArray *contactDTOs = [self convertToContactDTOsFrom:cnContacts];  // convert to contactDTOs.
                                [self forwardToAllCallbacks:contactDTOs];                           // foward to all callbacks:
                            } else {
                                // system error:
                                dispatch_async(completionQueue, ^{
                                    callBack(nil,error);
                                });
                            }
                        } else {
                            dispatch_async(completionQueue, ^{
                                callBack(nil,error);
                            });
                        }
                    }];
                });
            } else {
                // NSLog(@"Don't need to fetch, other task is fetching....");
                return;
            }
        });
    }
}

- (void) deleteContactFromContactBookById:(NSString *)contactId
                       completionHandler:(void (^)(BOOL, NSError *))callBack
                       callbackBlockOn:(dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        dispatch_async(self.contactManagerSerialQueue, ^{
            if ([self checkPermission]) {
                NSArray *keys = @[];
                NSError *error;
                CNContact *cnContact = [self.contactStore unifiedContactWithIdentifier:contactId keysToFetch:keys error:&error];
                
                // if success:
                if (!error) {
                    CNMutableContact *mutableCnContact = (CNMutableContact *)[cnContact mutableCopy];
                    CNSaveRequest *request = [[CNSaveRequest alloc] init];
                    [request deleteContact:mutableCnContact];
                    [self.contactStore executeSaveRequest:request error:&error];
                    if (!error) {
                        dispatch_async(completionQueue, ^{
                            callBack(true,nil);
                        });

                    } else {
                        dispatch_async(completionQueue, ^{
                            callBack(false,error);
                        });
                    }
                } else {
                    dispatch_async(completionQueue, ^{
                        callBack(false, error);
                    });
                }
            } else {
                // turn off permision or ...something..
                NSError *error = [NSError errorWithDomain:@"contactManagerDomain" code:101 userInfo:@{}];
                dispatch_async(completionQueue, ^{
                    callBack(false,error);
                });
            }
        });
    }
}

- (void) addContactIntoContactsBook:(ContactDTO *)contactDTO
                 completionHandler:(void (^)(BOOL, NSError *))callBack
                   callbackBlockOn:(dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        dispatch_async(_contactManagerSerialQueue, ^{
            // create new CNContact
            CNMutableContact *newCNContact = [[CNMutableContact alloc] init];
            newCNContact.givenName = contactDTO.firstName;
            newCNContact.familyName = contactDTO.lastName;
            if (contactDTO.phoneNumbers.count>0) {
                newCNContact.phoneNumbers = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain value:[CNPhoneNumber phoneNumberWithStringValue:contactDTO.phoneNumbers[0]]], nil];
            }
            
            // create request:
            CNSaveRequest *request = [[CNSaveRequest alloc] init];
            [request addContact:newCNContact toContainerWithIdentifier:nil];
            
            // addContact.
            NSError *error;
            [self.contactStore executeSaveRequest:request error:&error];
            
            // callback:
            dispatch_async(completionQueue, ^{
                if (!error) {
                    callBack(true,nil);
                } else {
                    callBack(false,error);
                }
            });
        });
    }
}

- (void) getContactAvatarById:(NSString *)contactId
           completionHandler:(void (^)(NSData *, NSError *))callBack
             callbackBlockOn:(dispatch_queue_t)completionQueue {
    if (callBack && completionQueue) {
        dispatch_async(self.contactManagerSerialQueue, ^{
            if ([self checkPermission]) {
                NSArray *keys = @[CNContactImageDataKey];
                NSError *error;
                CNContact *cnContact = [self.contactStore unifiedContactWithIdentifier:contactId keysToFetch:keys error:&error];  // fetch.
                if (!error) {
                    dispatch_async(completionQueue, ^{
                        callBack(cnContact.imageData,nil);
                    });
                } else {
                    dispatch_async(completionQueue, ^{
                        callBack(nil, error);
                    });
                }
            } else {
                NSError *error = [NSError errorWithDomain:@"contactManagerDomain" code:ContactErrorCodeAccessDenied userInfo:@{}];
                dispatch_async(completionQueue, ^{
                    callBack(false,error);
                });
            }
        });
    }
}

# pragma mark - Private methods:
// convert CNContacts to ContactDTOs.
- (NSMutableArray*) convertToContactDTOsFrom: (NSArray *)cnContacts {
    NSMutableArray *contactDTOs = [[NSMutableArray alloc] init];
    for (CNContact *cnContact in cnContacts) {
        ContactDTO *contactDTO = [[ContactDTO alloc] initWithCNContact:cnContact];
        [contactDTOs addObject:contactDTO];
    }
    return contactDTOs;
}

// store callback blocks and the completionQueue, which handle the callback block.
- (void) storeCompletionQueue: (dispatch_queue_t)completionQueue
                     withCallback: (LoadDataCompletionBlock)callback {
    const char *label = dispatch_queue_get_label(completionQueue);
    NSString *queueName = [[NSString alloc] initWithFormat:@"%s",label];
    if (self.callBacksDict[queueName]) {
        [self.callBacksDict[queueName] addObject:callback];
    } else {
        [self.queuesArr addObject:completionQueue];
        [self.callBacksDict setObject:[[NSMutableArray alloc] init] forKey:queueName];
        [self.callBacksDict[queueName] addObject:callback];
    }
    
}

// forward contactDTOs to all callbacks.
- (void) forwardToAllCallbacks:(NSArray*)contactDTOs {
    // for each queue:
    for (dispatch_queue_t queue in self.queuesArr) {
        const char *label = dispatch_queue_get_label(queue);
        NSString *queueName = [[NSString alloc] initWithFormat:@"%s",label];
        NSArray *callbacks = self.callBacksDict[queueName];
        // for each callback:
        for (int i = 0; i < callbacks.count; i++) {
            LoadDataCompletionBlock callback = callbacks[i];
            dispatch_async(queue, ^{
                callback(contactDTOs,nil);
            });
        }
    }
    
    // reset:
    [self.queuesArr removeAllObjects];
    [self.callBacksDict removeAllObjects];
    self.isFetching = false;
}

@end

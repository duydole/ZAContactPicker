#import <Foundation/Foundation.h>
#import "ZAContactModel.h"
#import "ZAContactManager.h"

@interface ZAContactBusiness : NSObject

+ (id) sharedInstance;

/**
 load list ContactDTOs from DataLayer then convert to list ZAContactModels.

 @param callBack to handle the results.
 @param completionQueue which will hanlde the callback block.
 */
- (void) loadContactDTOsWithCompletionHandler: (void (^)(NSArray<ZAContactModel*> *zaContactModels, NSError *error))callBack
                              callbackBlockOn: (dispatch_queue_t)completionQueue;

/**
Delete ZAContactModel in Local Contacts Book.

 @param contact will be deleted.
 @param callBack will hanlde the returned results.
 @param completionQueue will handle the callback block.
 */
- (void) deleteAZAContactModel: (ZAContactModel*)contact
             completionHandler: (void(^)(BOOL deleted, NSError *error))callBack
               callbackBlockOn: (dispatch_queue_t) completionQueue;

// Add new ZAContactModel.
- (void) addNewZAContactModel: (ZAContactModel *)newContact
            completionHandler: (void(^)(BOOL success, NSError *error))callBack
              callbackBlockOn: (dispatch_queue_t)completionQueue;

// get Avatar of Contact.
- (void) getAvatarOfZAContactModelById: (NSString *)contactId
                     completionHandler: (void(^)(NSData *imageData, NSError *error))callBack
                       callbackBlockOn: (dispatch_queue_t) completionQueue;

@end

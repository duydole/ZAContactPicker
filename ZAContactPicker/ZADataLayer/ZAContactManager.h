#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "ContactDTO.h"

typedef void(^LoadDataCompletionBlock)(NSArray<ContactDTO*> *contactDTOs, NSError *error);

// Defined authorization status of accessing Contacts Book.
typedef NS_ENUM(NSInteger, ContactAuthorizationStatus) {
    ContactAuthorizationStatusAuthorized = 0,                   // granted.
    ContactAuthorizationStatusNotDetermined,                    // not determined (first time request to access)
    ContactAuthorizationStatusDenied                            // user denied the access.
};

// Defined Error code when fetching data, request access.
typedef NS_ENUM(NSInteger, ContactErrorCode) {
    ContactErrorCodeAccessDenied = 0                            // user denied the access.
};

@interface ZAContactManager : NSObject

+ (id) sharedInstance;

/**
 Get user permisson about accessing contacts book.
 
 @return true, so we can access contacts book and vice versa.
 */
- (BOOL) checkPermission;

/**
 Get current Contact Authorization Status.

 @return a enum in ContactAuthorizationStatus.
 */
- (ContactAuthorizationStatus) getContactAuthorizationStatus;

/**
 Request user to access into contacts book.
 
 @param callBack to handle the returned results.
 granted: true if user give the permission and vice versa.
 error: errors occurring when request.
 */
- (void) requestAccessForContactsBook: (void(^)(BOOL granted, NSError *error)) callBack;

/**
 Using to fetch all CNContacts and convert to contactDTOs, then return for CompletionHandler.

 @param callBack to handle the results: contactDTOS (fetch successfully) or error.
 @param completionQueue which will handle the callback block.
 */
- (void) fetchContactsBookWithCompletionHandler: (LoadDataCompletionBlock) callBack
                                callbackBlockOn: (dispatch_queue_t) completionQueue;

/**
 Delete a contact in local contactsbook by Contact Id.

 @param contactId is identifier of Contact in Database.
 @param callBack to handle the results.
 @param completionQueue to hanlde the callback block.
 */
- (void) deleteContactFromContactBookById: (NSString *)contactId
                        completionHandler: (void(^)(BOOL deleted, NSError *error))callBack
                          callbackBlockOn: (dispatch_queue_t)completionQueue;

// addContact
- (void) addContactIntoContactsBook: (ContactDTO *)contactDTO
                  completionHandler: (void(^)(BOOL success, NSError *error))callBack
                    callbackBlockOn: (dispatch_queue_t)completionQueue;

// getImageById.
- (void) getContactAvatarById: (NSString*)contactId
            completionHandler: (void(^)(NSData *imageData, NSError *error))callBack
              callbackBlockOn: (dispatch_queue_t)completionQueue;

@end

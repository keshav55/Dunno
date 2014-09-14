//
//  SM_FBKitProtocol.h
//
//  Created by Karthikeya Udupa on 10/18/13.
//
//



#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBDialogs.h>
#import <FacebookSDK/FBWebDialogs.h>

typedef NS_ENUM(NSInteger, FacebookAudienceType)
{
    FacebookAudienceTypeSelf = 0,
    FacebookAudienceTypeFriends,
    FacebookAudienceTypeEveryone
};

BOOL FacebookAudienceTypeIsRestricted(FacebookAudienceType type);


@interface SM_FBKit : NSObject  {
   
}

+ (instancetype)sharedInstance;

- (void)openSession:(void(^)(NSError *error))completionBlock;
- (void)getUserInfo:(void(^)(id result, NSError *error))completionBlock;

- (void)showAppRequestDialogueWithMessage:(NSString*)message toUserId:(NSString*)userId;
- (void)logout;
- (BOOL)handleOpenUrl:(NSURL*)url;
- (void)handleDidBecomeActive;

- (void)postToWall:(NSDictionary *)params withCompletion:(void(^)(NSError *error))completionBlock;

@end

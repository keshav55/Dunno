//
//  SM_FBKit.m
//
//  Created by Karthikeya Udupa on 10/18/13.
//  Copyright (c) 2013 Karthikeya Udupa K M. All rights reserved.
//
//

#import "SM_FBKit.h"

NSString *NSStringFromFBSessionState(FBSessionState state);

@interface SM_FBKit ()
// single use blocks. these blocks are immediatly nulled after they are used
@property (nonatomic, copy) void(^openBlock)(NSError *error);
@property (nonatomic, copy) void(^permissionsBlock)(NSError *error);

- (void)openSessionWithBasicInfo:(void(^)( NSError *error))completionBlock;
- (void)requestPublishPermissions:(void(^)( NSError *error))completionBlock;
- (NSString*)accessToken;
@end


@implementation SM_FBKit

static NSString *const publish_actions = @"publish_actions";

#pragma mark - Externally accessible functions.

+ (instancetype)sharedInstance {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self.class new];
        [instance setSettings];
    });
    return instance;
}

// Permission Requesting along with login.
- (void)openSession:(void(^)(NSError *error))completionBlock {
    [self openSessionWithBasicInfo:^(NSError *error) {
        if(error) {
            completionBlock(error);
            return;
        }
        
        [self requestPublishPermissions:^(NSError *error_publish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(error_publish);
            });
        }];
    }];
}

- (void)getUserInfo:(void(^)(id result, NSError *error))completionBlock {
    
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:@"/me" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,picture,first_name,last_name,email",@"fields",
                                                                               nil] HTTPMethod:@"GET"];
    NSLog(@"%@", request);
    
    [newConnection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionBlock(result,error);
        });
    }];
    [newConnection start];
}


- (void)showAppRequestDialogueWithMessage:(NSString*)message toUserId:(NSString*)userId {
    [FBWebDialogs presentDialogModallyWithSession:[FBSession activeSession] dialog:@"apprequests"
                                       parameters:@{@"to" : userId, @"message" : message}
                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                              
                                          }];
}

- (void)postToWall:(NSDictionary *)params withCompletion:(void(^)(NSError *error))completionBlock {
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:params
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionBlock(error);
         });
     }];
    
}


- (void)logout {
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark -
#pragma mark - Internal

- (void)setSettings {

    [FBSettings setDefaultAppID:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"]];
    [FBSettings setDefaultDisplayName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookDisplayName"]];
    [FBAppEvents activateApp];
}

- (BOOL)handleOpenUrl:(NSURL*)url {
    
    [FBSettings setDefaultAppID:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"]];
    [FBSettings setDefaultDisplayName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookDisplayName"]];
    [FBAppEvents activateApp];
    
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)handleDidBecomeActive {
    
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [FBSession.activeSession close];
    }
    
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
    [FBSession.activeSession handleDidBecomeActive];
}

NSString *NSStringFromFBSessionState(FBSessionState state) {
    switch (state) {
        case FBSessionStateClosed:
            return @"FBSessionStateClosed";
        case FBSessionStateClosedLoginFailed:
            return @"FBSessionStateClosedLoginFailed";
        case FBSessionStateCreated:
            return @"FBSessionStateCreated";
        case FBSessionStateCreatedOpening:
            return @"FBSessionStateCreatedOpening";
        case FBSessionStateCreatedTokenLoaded:
            return @"FBSessionStateCreatedTokenLoaded";
        case FBSessionStateOpen:
            return @"FBSessionStateOpen";
        case FBSessionStateOpenTokenExtended:
            return @"FBSessionStateOpenTokenExtended";
            
    }
    return @"Not Found";
}

- (void)openSessionWithBasicInfo:(void(^)(NSError *error))completionBlock {
    if([[FBSession activeSession] isOpen]) {
        completionBlock(nil);
        return;
    }
    
    self.openBlock = completionBlock;
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sessionStateChanged:session state:status error:error open:YES permissions:NO];
        });
    }];
}

- (void)requestPublishPermissions:(void(^)(NSError *error))completionBlock {
    if([[[FBSession activeSession] permissions] indexOfObject:publish_actions] != NSNotFound) {
        completionBlock(nil);
        return;
    }
    
    if([[FBSession activeSession] isOpen] == NO) {

        [self openSession:^(NSError *error) {
            if(error){
                completionBlock(error);
            }else{
                [self requestPublishPermissions:completionBlock];
            }
        }];
        
        return;
    }
    
    self.permissionsBlock = completionBlock;
    
    [FBSession.activeSession requestNewPublishPermissions:@[publish_actions] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sessionStateChanged:session state:session.state error:error open:NO permissions:YES];
        });
    }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error open:(BOOL)open permissions:(BOOL)permissions {
    if(self.openBlock && open) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.openBlock(error);
            self.openBlock = nil;
        });
    }
    else if(self.permissionsBlock && permissions) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.permissionsBlock(error);
            self.permissionsBlock = nil;
        });
    }
}

- (NSString*)accessToken {
    return [[[FBSession activeSession] accessTokenData] accessToken];
}

@end
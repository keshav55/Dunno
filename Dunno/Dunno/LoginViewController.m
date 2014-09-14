//
//  LoginViewController.m
//  Dunno
//
//  Created by Keshav Rao on 9/13/14.
//  Copyright (c) 2014 edu.foothill. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "SM_FBKit.h"
#import "SM_LocationKit.h"
#import <Parse/Parse.h>


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)facebookAction:(id)sender {
    
    [self loginFacebook];

    
}
- (IBAction)locationAction:(id)sender {
    
    [SM_LocationKit getBallParkLocationOnSuccess:^(CLLocation *loc) {
        NSLog(@"-- %@", loc);
    } onFailure:^(NSInteger failCode) {
        NSLog(@"-- Failed:%@",failCode==0?@"Authorization Failure":@"Timeout Failure");
    }
     ];
    
    [SM_LocationKit getPlacemarkLocationOnSuccess:^(CLPlacemark *place) {
        NSLog(@"-- %@", place);
    } onFailure:^(NSInteger failCode) {
        NSLog(@"-- Failed:%@",failCode==0?@"Authorization Failure":@"Timeout Failure");
    }];
    
    
}

-(void) loginFacebook {
    
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    [PFFacebookUtils initializeFacebook];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }

        }
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

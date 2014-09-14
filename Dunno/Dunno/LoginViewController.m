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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SM_FBKit sharedInstance] openSession:^(NSError *error) {
        if(error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"An error occured while connecting to Facebook, please try again."] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return ;
        }else{
            
            
            NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"testapp",@"name",
                                                              @"http://www.testapp.com",@"link", nil],
                                    nil];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:actionLinks options:0 error:nil];
            NSString* actionLinksStr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Testing Facebook", @"name",
                                           @"Testing facebook caption.", @"caption",
                                           @"A sample facebook application to test facebook caption.", @"description",
                                           @"http://www.google.com", @"link",
                                           @"https://github.global.ssl.fastly.net/images/modules/logos_page/GitHub-Mark.png", @"picture",
                                           actionLinksStr, @"actions",
                                           nil];
            [[SM_FBKit sharedInstance] postToWall:params withCompletion:^(NSError *error_post) {
                if(error_post){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"An error occured while posting to facebook."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.animationType = MBProgressHUDAnimationZoom;
                    HUD.delegate = (id<MBProgressHUDDelegate>)self;
                    HUD.labelText = @"Posteado";
                    
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:3];
                });
            }];
            
        }
    }];
    
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

//
//  LoginViewController.h
//  Dunno
//
//  Created by Keshav Rao on 9/13/14.
//  Copyright (c) 2014 edu.foothill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) NSString * location;
@property (strong, nonatomic) IBOutlet UITextField *phonenumber;
@property (strong, nonatomic) NSString * place;

-(IBAction)resign:(id)sender;
@end

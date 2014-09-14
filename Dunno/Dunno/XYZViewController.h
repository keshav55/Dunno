//
//  XYZViewController.h
//  Dunno
//
//  Created by Saiteja Samudrala on 9/13/14.
//  Copyright (c) 2014 edu.foothill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZViewController : UIViewController
@property (strong, nonatomic) NSMutableArray* users;
@property (strong, nonatomic) IBOutlet UITextField * username;
@property (strong, nonatomic) IBOutlet UITextField * password;
@property (strong, nonatomic) IBOutlet UIButton * signbut;
@property (strong, nonatomic) IBOutlet UIButton * logbut;
@property (strong, nonatomic) IBOutlet UILabel * statuslabel;
-(IBAction)signup:(id)sender;
-(IBAction)login:(id)sender;

@end

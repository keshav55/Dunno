//
//  QuestionViewController.m
//  Dunno
//
//  Created by Keshav Rao on 9/14/14.
//  Copyright (c) 2014 edu.foothill. All rights reserved.
//

#import "QuestionViewController.h"
#import <Firebase/Firebase.h>


@interface QuestionViewController ()

@end

@implementation QuestionViewController

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
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)Feed:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * city = [defaults objectForKey:@"city"];
    
    NSMutableDictionary * _Questions = [NSMutableDictionary dictionaryWithCapacity:100];
    
    [_Questions setObject:@"" forKey: _questionfield.text];
  
    NSDictionary *send = @{@"question":_questionfield.text, @"answer": @"", @"city":city};
    NSDictionary *final =@{_questionfield.text:send};
    
    Firebase* userj = [[Firebase alloc] initWithUrl:@"https://thedunno.firebaseio.com/"];
    
    
    [userj setValue:final];
    
}



@end

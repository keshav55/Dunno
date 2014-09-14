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
    // Do any additional setup after loading the view.
  
}
-(IBAction)submitQuestion:(id)sender {
    NSString *question = _question.text;
    
    NSDictionary *questions = @{@"question": question};
    
    Firebase* userj = [[Firebase alloc] initWithUrl:@"https://thedunno.firebaseio.com/"];
    
 
    
    
}

-(IBAction)pullThis:(id)sender {
    Firebase* postsRef = [[Firebase alloc] initWithUrl: @"https://thedunno.firebaseio.com/"];
    
    // Attach a block to read the data at our posts reference
    [postsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
        _puller = snapshot.value;
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    NSLog(@"%@", _puller);
    
    NSString *city = [_puller objectForKey:@"city"];
    
    NSLog(@"%@", city);
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

@end

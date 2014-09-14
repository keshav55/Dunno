//
//  XYZViewController.m
//  Dunno
//
//  Created by Saiteja Samudrala on 9/13/14.
//  Copyright (c) 2014 edu.foothill. All rights reserved.
//

#import "XYZViewController.h"
#import <Parse/Parse.h>
@interface XYZViewController ()

@end

@implementation XYZViewController {
    
    
    PFObject *Dunnousers;
    NSString *currentObjectID;
    
}

- (void)viewDidLoad
{
    _users = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    Dunnousers = [PFObject objectWithClassName:@"Userdetails"];
    [self retrivePreviousID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)retrivePreviousID{
    PFQuery *query = [PFQuery queryWithClassName:@"Userdetails"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
       for (PFObject *object in objects) {
           currentObjectID = object.objectId;
           _users = object[@"users"];
        
            
       }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}




-(void)pushToCloud{
    Dunnousers[@"users"] = _users;
    
    [Dunnousers saveInBackground];
}

-(void)updateToCloud{
    PFQuery *query = [PFQuery queryWithClassName:@"Userdetails"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:currentObjectID block:^(PFObject *Answers, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        
        Dunnousers[@"users"] = _users;
        [Dunnousers saveInBackground];
    }];
}

-(IBAction)signup:(id)sender {
    NSString * username = [NSString stringWithFormat:_username.text];
     NSString * password = [NSString stringWithFormat:_password.text];
    
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:username forKey:password];
    [_users addObject:dict];
    [self pushToCloud];
    
    _username.text = @"";
    _password.text = @"";
    
    _statuslabel.text = @"Signed Up";
    
}

-(IBAction)login:(id)sender {
    [self retrivePreviousID];
    for (NSMutableDictionary * dict in _users) {
        
        if([[dict objectForKey:_password.text] isEqualToString: _username.text]) {
            _username.text = @"";
            _username.hidden = YES;
            _password.text = @"";
            _password.hidden = NO;
              _statuslabel.text = @"";
            break;
        }
    }
   
    
    
}



@end

//
//  INLAddFriendsViewController.m
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import "INLAddFriendsViewController.h"
#import "Parse/parse.h"
#import "INLAcceptFriendshipTableViewController.h"

@interface INLAddFriendsViewController ()
@property IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *sear;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation INLAddFriendsViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        UINavigationItem *navItem = self.navigationItem;
        _sear.layer.cornerRadius = 2;
        _sear.layer.borderWidth = 2;
        _sear.layer.borderColor = [UIColor blueColor].CGColor;
        UIBarButtonItem *frq = [[UIBarButtonItem alloc] initWithTitle:@"Friend Requests" style:UIBarButtonItemStylePlain target:self action:@selector(viewFriendRequests:)];
        frq.tintColor = [UIColor whiteColor];
        navItem.rightBarButtonItem = frq;
    }
    return self;
}



-(IBAction)search:(id)sender{
    PFQuery *query = [PFUser query];
    NSString *currentString = self.textF.text;
    if (currentString){
        [query whereKey:@"username" equalTo:currentString];
        NSArray* currentStrings = [query findObjects];
        if ([currentStrings count] == 0) {NSLog(@"Error"); return;}
        PFUser* toBeAdded = currentStrings[0];
        PFUser *currentUser = [PFUser currentUser];
        if (!currentUser){
            NSLog(@"There is an error");
            return;
        }
//        NSMutableArray *friendsRequested = currentUser[@"friendRequested"];
//        if (!friendsRequested) friendsRequested = [NSMutableArray array];
//        [friendsRequested addObject:toBeAdded];
//        currentUser[@"friendRequested"] = friendsRequested;
//        [currentUser saveInBackground];
//        NSMutableArray *friendsReceived = toBeAdded[@"friendsRequestedR"];
//        if (!friendsReceived) friendsReceived = [NSMutableArray array];
//        toBeAdded[@"friendsRequestedR"] = friendsReceived;
//        [friendsReceived addObject:currentUser];
//        [toBeAdded saveInBackground];
        PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
        [query whereKey:@"from" equalTo:[PFUser currentUser]];
        NSMutableArray *people = [[query findObjects]mutableCopy];
        BOOL present = NO;
        for (PFObject *o in people){
            PFUser *q = [o objectForKey:@"to"];
            PFUser *j = [q fetchIfNeeded];
            NSString *i1 = [j objectForKey:@"username"];
            NSString *i2 = [toBeAdded objectForKey:@"username"];
            if ([i1 isEqualToString:i2]){
                present = YES;
                break;
            }
         }
        BOOL aF = NO;
        PFQuery *query1 = [PFQuery queryWithClassName:@"Friends"];
        [query1 whereKey:@"from" equalTo:[PFUser currentUser]];
        NSMutableArray *people1 = [[query1 findObjects]mutableCopy];
        for (PFObject *o in people1){
            PFUser *q = [o objectForKey:@"to"];
            PFUser *j = [q fetchIfNeeded];
            NSString *i1 = [j objectForKey:@"username"];
            NSString *i2 = [toBeAdded objectForKey:@"username"];
            if ([i1 isEqualToString:i2]){
                aF = YES;
                break;
            }
        }
        PFQuery *query2 = [PFQuery queryWithClassName:@"Friends"];
        [query2 whereKey:@"to" equalTo:[PFUser currentUser]];
        NSMutableArray *people2 = [[query2 findObjects]mutableCopy];
        for (PFObject *o in people2){
            PFUser *q = [o objectForKey:@"from"];
            PFUser *j = [q fetchIfNeeded];
            NSString *i1 = [j objectForKey:@"username"];
            NSString *i2 = [toBeAdded objectForKey:@"username"];
            if ([i1 isEqualToString:i2]){
                aF = YES;
                break;
            }
        }
        
        if (!present){
            if (!aF){
                PFObject *follow = [PFObject objectWithClassName:@"Follow"];
                [follow setObject:[PFUser currentUser]  forKey:@"from"];
                [follow setObject:toBeAdded forKey:@"to"];
                [follow setObject:[NSDate date] forKey:@"date"];
                [follow saveInBackground];
                self.textF.text = @"";
        
            //Notify other user
               NSLog(@"Notifying other user");
               PFQuery *pushQuery = [PFInstallation query];
             [pushQuery whereKey:@"user" equalTo:toBeAdded];
             PFPush *push = [[PFPush alloc] init];
             [push setQuery:pushQuery]; // Set our Installation query
             NSString *message = [NSString stringWithFormat:@"%@ has added you to their contacts!", [PFUser currentUser].username];
             [push setMessage: message];
             [push sendPushInBackground];
            }else{
                self.textF.text = @"Already Friends";
            }
        }
        else{
            self.textF.text = @"Friend Request Sent";
        }
        [self.view endEditing:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(backgroundTouched)];
    
    [self.view addGestureRecognizer:tap];

}

//view the friend requests
- (void)viewFriendRequests:(id)sender{
    INLAcceptFriendshipTableViewController* frRe = [[INLAcceptFriendshipTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:frRe animated:YES];
}


//Methods dismissing the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"finished typing %@ to add friends",textField.text);
    [textField resignFirstResponder];
//    PFUser *user = [PFUser currentUser];
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"username" equalTo:textField.text]; // find the user
//    NSArray *befriend = [query findObjects];
//    if ([befriend count] == 0) NSLog(@"Error: no such person");
//    else {
//        NSMutableArray *friends = [(NSArray *)user[@"friends"] mutableCopy];
//        [friends addObject:befriend[0]];
//        user[@"friends"] = friends;
//        [user saveInBackground];
//    }
    return YES;
}

- (IBAction)backgroundTouched {
    [self.view endEditing:YES];
}


//Push button up when keyboard shows up

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveDown:) name:UIKeyboardWillHideNotification object:nil];
    _sear.layer.cornerRadius = 5;
    _sear.layer.borderWidth = 1.2;
    _sear.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



//Animations to move up/down view when keyboard appears/disappears
-(void)moveUp:(NSNotification *)aNotification
{
    //Get user info
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    //TODO: alter the function when orientation changes
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    //animate
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    [self.textF setFrame:CGRectMake(self.textF.frame.origin.x, self.textF.frame.origin.y - 60, self.textF.frame.size.width, self.textF.frame.size.height)];
    [self.sear setFrame:CGRectMake(self.sear.frame.origin.x, self.sear.frame.origin.y - 60, self.sear.frame.size.width, self.sear.frame.size.height)];
    [UIView commitAnimations];
}

-(void)moveDown:(NSNotification *)aNotification
{
    //Get user info
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    //TODO: alter the function when orientation changes
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    //animate
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    [self.sear setFrame:CGRectMake(self.sear.frame.origin.x, self.sear.frame.origin.y + 60, self.sear.frame.size.width, self.sear.frame.size.height)];
    [self.textF setFrame:CGRectMake(self.textF.frame.origin.x, self.textF.frame.origin.y + 60, self.textF.frame.size.width, self.textF.frame.size.height)];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

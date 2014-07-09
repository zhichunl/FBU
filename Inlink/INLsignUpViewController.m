//
//  INLsignUpViewController.m
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import <Parse/Parse.h>
#import "INLsignUpViewController.h"
#import "INLsignUpView.h"
#import "INLContactsTableViewController.h"


@interface INLsignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *toLogIn;


@end

@implementation INLsignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success! You are %@", user);
            
            //Initialize mutable arrays for friend lists
            user[@"friendRequests"] = [[NSMutableArray alloc]init];
            user[@"friends"] = [[NSMutableArray alloc]init];
            
            //Initialize mutable arrays for messages sent and received
            user[@"messagesSent"] = [[NSMutableArray alloc]init];
            user[@"messagesReceived"] = [[NSMutableArray alloc]init];
            
            //Name as well since Zhichun used name somewhere...
            user[@"name"] = self.username.text;
            
            INLContactsTableViewController *connect = [[INLContactsTableViewController alloc]init];
            [self.navigationController pushViewController:connect animated:YES];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
        }
    }];}

- (void)viewWillAppear:(BOOL)animated
{
    //Hide nav bar
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    NSLog(@"Will load Sign Up");
    // Create gradient background
    
    UIColor *lighterColor = [UIColor colorWithRed:0.278 green:0.858 blue:1 alpha:1];
    UIColor *darkerColor = [UIColor colorWithRed:0.165 green:0.514 blue:0.698 alpha:1];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)lighterColor.CGColor, (id)darkerColor.CGColor, nil];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Resign keyboard on outside touch
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}
- (IBAction)toLogIn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard{
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}



@end

//
//  INLloginViewController.m
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import "INLloginViewController.h"
#import "INLsignUpViewController.h"
#import "INLContactsTableViewController.h"
#import <QuartzCore/QuartzCore.h> //Image Framework
#import <Parse/Parse.h>

@interface INLloginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *logIn;
@property (weak, nonatomic) IBOutlet UIButton *toSignUp;

@end

@implementation INLloginViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //Hide nav bar
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    NSLog(@"Hello");
    // Create gradient background
    
    UIColor *lighterColor = [UIColor colorWithRed:0.278 green:0.858 blue:1 alpha:1];
    UIColor *darkerColor = [UIColor colorWithRed:0.165 green:0.514 blue:0.698 alpha:1];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:(id)lighterColor.CGColor, (id)darkerColor.CGColor, nil];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    //Is the user cached?
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser){
        INLContactsTableViewController *contacts = [[INLContactsTableViewController alloc]init];
        NSLog(@"Skip to contacts page");
        [self.navigationController pushViewController:contacts animated:YES];
    }
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logIn:(id)sender {
    [PFUser logInWithUsernameInBackground:self.username.text
                                 password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Successfully logged in!");
                                            INLContactsTableViewController *contactsView = [[INLContactsTableViewController alloc]init];
                                            [self.navigationController pushViewController:contactsView animated:YES];
                                            NSLog(@"Pushed contactsView");
                                        } else {
                                            NSLog(@"Error logging in: %@", error);
                                            //Try again message somewhere
                                        }
                                    }];
}
- (IBAction)toSignUp:(id)sender {
    INLsignUpViewController *signUp = [[INLsignUpViewController alloc]init];
    [self.navigationController pushViewController:signUp animated:YES];

}
//
//-(void)dismissKeyboard{
//    [_password resignFirstResponder];
//    [_username resignFirstResponder];
//}

@end

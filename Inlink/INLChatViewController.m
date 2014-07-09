//
//  INLChatViewController.m
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import "INLChatViewController.h"
#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>

@interface INLChatViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) PFUser *user;
@property (nonatomic) UITextView *message;
@property (weak, nonatomic) IBOutlet UITextView *Mes;

@end

@implementation INLChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _user = [PFUser currentUser];
    }
    return self;
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    NSMutableDictionary *message = _user[@"messagesSent"];
//    NSString *mess = message[_chatPartner[@"username"]];
    //animations for when a message disappears
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"to" equalTo:[PFUser currentUser]];
    NSMutableArray *people = [[query findObjects]mutableCopy];
    NSString *text;
    for (PFObject *o in people){
        PFUser*q = [o objectForKey:@"from"];
        PFUser*j =[q fetchIfNeeded];
        NSLog(@"%@, %@", j, self.chatPartner);
        NSString *i1 = [o objectForKey:@"senderName"];
        NSString *i2 = [self.chatPartner objectForKey:@"username"];
        if ([i1 isEqualToString:i2]){
            text = [o objectForKey:@"url"];
            [o deleteInBackground];
            break;
        }
    }
    if (text){
        self.message = [[UITextView alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.bounds.size.width/4, -100, self.view.bounds.size.width, 50)];
        [self.view addSubview:self.message];
        self.message.text = text;
        self.message.userInteractionEnabled = YES;
        [self.message setDataDetectorTypes:UIDataDetectorTypeLink];
        self.message.editable = NO;
        self.message.layer.cornerRadius = 6;
        self.message.layer.borderColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1].CGColor;
        self.message.layer.borderWidth = 2.0;
        self.message.alpha = 1.0;
        [self.message sizeToFit];
    
        [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.message.center = CGPointMake(self.view.center.x, self.view.center.y - 10);
        }
                     completion:^(BOOL success){
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             self.message.alpha = 0.0;
                             self.message.center = CGPointMake(self.view.center.x - 25, -100);
                         });
                    }];
//    [message removeObjectForKey:mess];
//    _user[@"messagesSent"] = message;
//    [_user saveInBackground];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    self.Mes.alpha = 0.0;
    self.textField.text = @"http://";
    self.sendButton.layer.cornerRadius = 6;
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.borderColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1].CGColor;
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveDown:) name:UIKeyboardWillHideNotification object:nil];
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
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
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
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}



//Methods dismissing the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"finished typing %@",textField.text);
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)backgroundTouched {
    [self.view endEditing:YES];
}

- (IBAction)sendMessage:(id)sender {
    
    //TODO: send self.textField.text to the chat
    NSLog(@"Sending %@ to the server",self.textField.text);
//    NSString *message = self.textField.text;
//    NSMutableDictionary* messages = _user[@"messagesSent"];
//    messages[self.chatPartner[@"name"]] = message;
//    _user[@"messageSent"] = messages;
//    [_user saveInBackground];
//    NSMutableDictionary *mes = self.chatPartner[@"messagesRec"];
//    mes[_user[@"username"]] = message;
//    [self.chatPartner saveInBackground];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    NSMutableArray *people = [[query findObjects]mutableCopy];
    BOOL present = NO;
    for (PFObject *o in people){
        PFUser*q = [o objectForKey:@"to"];
        PFUser*j =[q fetchIfNeeded];
        NSLog(@"%@, %@", j, self.chatPartner);
        NSString *i1 = [o objectForKey:@"receiverName"];
        NSString *i2 = [self.chatPartner objectForKey:@"username"];
        if ([i1 isEqualToString:i2]){
            present = YES;
            break;
        }
    }
    if (!present){
        PFObject *message = [PFObject objectWithClassName:@"Messages"];
        [message setObject:_user forKey:@"from"];
        [message setObject:[_user objectForKey:@"username"] forKey:@"senderName"];
        [message setObject:_chatPartner forKey:@"to"];
        [message setObject:[_chatPartner objectForKey:@"username"] forKey:@"receiverName"];
        [message setObject:self.textField.text forKey:@"url"];
        [message saveInBackground];
    
        [self.view endEditing:YES];
        self.textField.text = @"http://";
        if (!self.message){
            self.Mes.alpha = 1.0;
            self.Mes.text = @"The message has been sent!";
            self.Mes.font = [UIFont fontWithName:@"Helvetica" size:20.0];
            [UIView animateWithDuration:3.5 animations:^{self.Mes.alpha = 0.0;} completion:NULL];
        }
    }
    else{
        [self.view endEditing:YES];
        if (!self.message){
            self.Mes.alpha = 1.0;
            self.Mes.text = @"Please wait for the first message to be received!";
            [UIView animateWithDuration:3.5 animations:^{self.Mes.alpha = 0.0;} completion:NULL];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

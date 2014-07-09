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
@property (nonatomic, copy) NSDictionary *jsonObject;
@property (weak, nonatomic) IBOutlet UILabel *invalidUrlLabel;

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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"]; //set up query
    [query whereKey:@"to" equalTo:[PFUser currentUser]];
    NSMutableArray *people = [[query findObjects]mutableCopy]; //create array of objects from query
    
    NSString *text;
    for (PFObject *message in people){ //For message
        PFUser* fromQuery = [message objectForKey:@"from"];
        PFUser* fromUser =[fromQuery fetchIfNeeded];
        
        NSString *senderName = [message objectForKey:@"senderName"];
        NSString *partnerName = [self.chatPartner objectForKey:@"username"];
        if ([senderName isEqualToString:partnerName]){
            text = [message objectForKey:@"url"]; //get the URL message
            [message deleteInBackground]; //delete from PARSE
            break;
        }
    }
    if (text){
        //See if URL links to an image (jpg, gif, or png)
        NSString *fileExt = [text pathExtension];
        if ([fileExt isEqualToString:@"jpg"]){
            NSLog(@"Hey this is an image!");
        }
        self.message = [[UITextView alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.bounds.size.width/4, -100, self.view.bounds.size.width, 50)];
        [self.view addSubview:self.message];
        self.message.text = text;
        self.message.userInteractionEnabled = YES;
        [self.message setDataDetectorTypes:UIDataDetectorTypeLink];
        self.message.editable = NO;
        self.message.font = [UIFont fontWithName:@"Helvetica" size:20];
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
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @" "]) return NO;
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
        PFUser* q = [o objectForKey:@"to"];
        PFUser* j =[q fetchIfNeeded];
        NSString *i1 = [o objectForKey:@"receiverName"];
        NSString *i2 = [self.chatPartner objectForKey:@"username"];
        if ([i1 isEqualToString:i2]){
            present = YES;
            break;
        }
    }
    if (!present){
        NSString *link;
        if ([self.textField.text characterAtIndex:[self.textField.text length] - 1] != '/') link = [self.textField.text stringByAppendingString:@"/"]; else link = [NSString stringWithString:self.textField.text];
        [self validateURL:link];
        
    }else{
            [self.view endEditing:YES];
            if (!self.message){
                self.Mes.alpha = 1.0;
                
                self.Mes.text = [NSString stringWithFormat:@"%@ hasn't gotten your last message yet!", _chatPartner.username];
                [UIView animateWithDuration:3.5 animations:^{self.Mes.alpha = 0.0;} completion:NULL];
            }
            
        }
        


}
-(void)updateServer
{
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
        
        //Notify other user
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" equalTo:_chatPartner];
        
        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our Installation query
        NSString *message = [NSString stringWithFormat:@"%@ sent you a message!", [PFUser currentUser].username];
        [push setMessage: message];
        [push sendPushInBackground];
        
        [self.view endEditing:YES];
    } else {
        self.invalidUrlLabel.text = @"Message sent";
        self.invalidUrlLabel.hidden = NO;
        self.invalidUrlLabel.alpha = 1.0;
        [UIView animateWithDuration:2 animations:^{
            self.invalidUrlLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.invalidUrlLabel.hidden = YES;
            self.invalidUrlLabel.alpha = 1.0;
        }];
        
    }
}

-(void)validateURL:(NSString *)host
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSString *requestString = [NSString stringWithFormat:@"http://api.mywot.com/0.4/public_link_json2?hosts=%@&key=89f86712a5f21b66452d39a116b4383141252c2f", host];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if ([self.jsonObject count] != 1) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.invalidUrlLabel.text = @"This is not a website";
                self.invalidUrlLabel.hidden = NO;
            }];
            return;
        }
        NSArray *allValues = [self.jsonObject allValues];
        NSDictionary *firstValue = allValues[0];
        if ((!firstValue[@"0"] && !firstValue[@"4"])) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.invalidUrlLabel.text = @"This is not a website";
                self.invalidUrlLabel.hidden = NO;
            }];
            return;
        }
        if (firstValue[@"0"] && [(NSNumber *)firstValue[@"0"][0] intValue] <= 40) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.invalidUrlLabel.text = @"This website is not safe";
                self.invalidUrlLabel.hidden = NO;
            });
            return;
        }
        NSLog(@"passed trustworthieness");
        if (firstValue[@"4"] && [(NSNumber *)firstValue[@"4"][0] intValue] <= 40) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.invalidUrlLabel.text = @"This website is not safe";
                self.invalidUrlLabel.hidden = NO;
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.invalidUrlLabel.hidden = YES;
            [self updateServer];
        });
    }];
    
    [dataTask resume];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

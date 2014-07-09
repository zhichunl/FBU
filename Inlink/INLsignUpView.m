//
//  INLsignUpView.m
//  Inlink
//
//  Created by Lillian Choung on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import "INLsignUpView.h"
#import "INLSignUpViewController.h"

@interface INLsignUpView ()

@end

@implementation INLsignUpView



- (void)hello: (id)sender
{
    NSLog(@"Hi there I am testing a function");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"Signing up a user");
        
        UITextField *username = [[UITextField alloc]initWithFrame:CGRectMake(100, 210, 120, 22)];
        username.text = @"username";
        username.borderStyle = UITextBorderStyleRoundedRect;
        username.clearsOnBeginEditing = YES;
        [self addSubview: username];
        
        UITextField *password= [[UITextField alloc]initWithFrame:CGRectMake(100, 240, 120, 22)];
        password.text = @"password";
        password.borderStyle = UITextBorderStyleRoundedRect;
        password.clearsOnBeginEditing = YES;
        [self addSubview: password];
        
        UIButton *signup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [signup setTitle:@"Sign Up!" forState:UIControlStateNormal];
        
        signup.frame = CGRectMake(100, 270, 120, 25);
        [self addSubview: signup];
    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

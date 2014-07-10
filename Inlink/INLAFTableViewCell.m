//
//  INLAFTableViewCell.m
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import "INLAFTableViewCell.h"
#import "Parse/Parse.h"

@interface INLAFTableViewCell()


@end

@implementation INLAFTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)addedFriend:(id)sender {
    PFObject *friend = [PFObject objectWithClassName:@"Friends"];
    PFUser *currentUser = [PFUser currentUser];
    NSString *userRe = self.DisplayedName.text;
    if (userRe && self.fri){
        [friend setObject:currentUser forKey:@"to"];
        [friend setObject:self.fri forKey:@"from"];
        [friend setObject:[NSDate date] forKey:@"date"];
        [friend saveInBackground];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"to" equalTo:[PFUser currentUser]];
    NSMutableArray* people = [[query findObjects] mutableCopy];
    NSMutableArray* cool = [NSMutableArray array];
    NSMutableArray* ned = [NSMutableArray array];
    for (PFObject *o in people){
        PFUser*j = [o objectForKey:@"from"];
        PFUser *q = [j fetchIfNeeded];
        NSString *i1 = q[@"username"];
        NSString *i2 = self.fri[@"username"];
        if (![i1 isEqualToString:i2]){
            [cool addObject:o];
        }
        else{
            [ned addObject:o];
        }
    }
    for (PFObject *o in ned){
        [o delete];
    }
    
    [self.delegate reload:cool];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

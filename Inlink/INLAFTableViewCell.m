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

@property (weak, nonatomic) IBOutlet UIButton *friends;

@end

@implementation INLAFTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)addedFriend:(id)sender {
    PFQuery *query = [PFUser query];
    PFUser *currentUser = [PFUser currentUser];
    NSString *userRe = self.DisplayedName.text;
    if (userRe){
        [query whereKey:@"name" equalTo:userRe];
        NSArray* currentStrings = [query findObjects];
        PFUser* addUser = currentStrings[0];
        NSMutableArray *friendsRequested = currentUser[@"friendRequests"];
        [friendsRequested removeObject:addUser];
        currentUser[@"friendRequests"] = friendsRequested;
        [currentUser saveInBackground];
        NSMutableArray *friendsReceived = addUser[@"friendsRequestsR"];
        addUser[@"friendsRequestsR"] = friendsReceived;
        [friendsReceived removeObject:currentUser];
        [addUser saveInBackground];
        NSMutableArray *friends = currentUser[@"friends"];
        [friendsRequested addObject:addUser];
        currentUser[@"friends"] = friends;
        [currentUser saveInBackground];
        NSMutableArray *friends1 = addUser[@"friends"];
        addUser[@"friends"] = friends1;
        [friendsReceived addObject:currentUser];
        [addUser saveInBackground];
        
    }
    [self.delegate reload];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

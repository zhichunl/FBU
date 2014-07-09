//
//  INLAFTableViewCell.h
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"


@protocol INLAFProtocol;

@interface INLAFTableViewCell : UITableViewCell
@property id <INLAFProtocol> delegate;
@property (weak, nonatomic) IBOutlet UILabel *DisplayedName;
@property (nonatomic) PFUser *fri;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end


@protocol INLAFProtocol <NSObject>

-(void)reload: (NSMutableArray *)people;

@end

//
//  INLContactsTableViewCell.h
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/parse.h"
@interface INLContactsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *LinkLabel;

@end

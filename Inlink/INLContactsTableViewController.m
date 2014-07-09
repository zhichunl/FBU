//
//  INLContactsTableViewController.m
//  Inlink
//
//  Created by Zhichun Li on 7/8/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import "INLContactsTableViewController.h"
#import "INLContactsTableViewCell.h"
#import "INLAddFriendsViewController.h"
#import "INLloginViewController.h"
#import "Parse/parse.h"
#import "INLloginViewController.h"
#import "INLChatViewController.h"

@interface INLContactsTableViewController ()

@property (nonatomic) NSMutableArray *friends;

@end

@implementation INLContactsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UINavigationItem *navItem = self.navigationItem;

        //UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFriend:)];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add70_small"] style: UIBarButtonItemStylePlain target:self action:@selector(addNewFriend:)];
        
        bbi.tintColor = [UIColor whiteColor];
        
        //Set this bar button item as the left item in the navigation Item
        navItem.leftBarButtonItem = bbi;
        
        
        //Make a log out button
        UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout_s"] style: UIBarButtonItemStylePlain target:self action:@selector(logOut:)];
        
        logout.tintColor = [UIColor whiteColor];

        navItem.rightBarButtonItem = logout;
        
        
        self.title = @"Friends";
        
        
        //Set background
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inLinkLogoGrey.png"]];
        
        tempImageView.contentMode = UIViewContentModeCenter;
        
        [tempImageView setFrame:self.tableView.frame];
        
        self.tableView.backgroundView = tempImageView;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib *nib = [UINib nibWithNibName:@"INLContactsTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"INLContactsTableViewCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    // set up the query on the Follow table
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"from" equalTo:[PFUser currentUser]];
    __block NSMutableArray* friends;
    // execute the query
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        for(PFObject *o in objects) {
//            // o is an entry in the Follow table
//            // to get the user, we get the object with the to key
//            PFUser *otherUser = [o objectForKey:@"to"];
//            [friends addObject:otherUser];
////            NSLog(@"%d", [self.friends count]);
//        }
//    }];
//    self.friends = [friends copy];
//    NSLog(@"%d", [self.friends count]);
//
//    [self.tableView reloadData];
    self.friends = [NSMutableArray array];
    friends = [[query findObjects] mutableCopy];
    
            for(PFObject *o in friends) {
                    // o is an entry in the Follow table
                    // to get the user, we get the object with the to key
                    PFUser *otherUser = [o objectForKey:@"to"];
                PFUser *localOtherUser = [otherUser fetchIfNeeded];
                    [self.friends addObject:localOtherUser];
                NSLog(@"%@", otherUser);
        //            NSLog(@"%d", [self.friends count]);
                }
    

            NSLog(@"%d", [self.friends count]);

            [self.tableView reloadData];

}
-(void)viewDidAppear:(BOOL)animated
{
//    PFUser *currentUser = [PFUser currentUser];
//    if (currentUser) {
//        self.friends = currentUser[@"friends"];
//    } else {
//        INLloginViewController *login = [[INLloginViewController alloc] init];
//        [self.navigationController presentViewController:login animated:YES completion:nil];
//    }
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //TODO: get number of contacts of the current user
    // Return the number of rows in the section.
    NSLog(@"%d count", [self.friends count]);
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INLContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INLContactsTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
//    if (indexPath.row > 3) {
//        cell.LinkLabel.hidden = YES;
//        cell.nameLabel.text = @"Jane Doe";
//        
//    } else {
//        cell.nameLabel.text = @"John Doe";
//    }
//    switch (indexPath.row) {
//        case 0:
//            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
//            break;
//        case 1:
//            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.4 alpha:1.0];
//            break;
//        case 2:
//            cell.backgroundColor = [UIColor colorWithRed:0.4 green:1.0 blue:0.4 alpha:1.0];
//            break;
//        case 3:
//            cell.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
//            break;
//        case 4:
//            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:1.0 alpha:1.0];
//            break;
//
//            
//        default:
//            break;
//    }
    PFUser *friend = (PFUser *)self.friends[indexPath.row];
    cell.nameLabel.text = friend[@"username"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INLChatViewController *cvc = [[INLChatViewController alloc] init];
    
    //TODO: change title to name of friend clicked on
    cvc.title = ((INLContactsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).nameLabel.text;
    //cvc.chatPartner = self.friends[indexPath.row];
    [self.navigationController pushViewController:cvc animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)addNewFriend:(id)sender
{
    INLAddFriendsViewController *afvc = [[INLAddFriendsViewController alloc] init];
    [self.navigationController pushViewController:afvc animated:YES];
}

-(IBAction)logOut:(id)sender
{
    //Tell Parse to log the user out
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    INLloginViewController *login = [[INLloginViewController alloc]init];
    //Return to the log in screen
    [self.navigationController pushViewController:login animated:YES];
    NSLog(@"Logged out");
}

@end


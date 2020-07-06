//
//  ChatViewController.m
//  ParseChat
//
//  Created by Ria Vora on 7/6/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchChats) userInfo:nil repeats:true];
    
}
- (IBAction)pressedSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2020"];
    chatMessage[@"text"] = self.chatTextField.text;
    chatMessage[@"user"] = PFUser.currentUser;

    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message %@ was saved!", chatMessage);
            self.chatTextField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fetchChats {
   PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2020"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.limit = 20;
    
   [query findObjectsInBackgroundWithBlock:^(NSArray *chats, NSError *error) {
       if (chats != nil) {
           NSLog(@"Successful response!");
           self.chats = chats;
//           for (PFObject *chat in self.chats) {
//               NSLog(@"Text is %@", chat[@"text"]);
//           }
           [self.tableView reloadData];
       } else {
           NSLog(@"%@", error.localizedDescription);
       }
   }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    PFObject *chat = self.chats[indexPath.row];
    
    cell.chatLabel.text = chat[@"text"];
    
    PFUser *user = chat[@"user"];
    
    if (user) {
        cell.userLabel.text = user.username;
    } else {
        cell.userLabel.text = @"∆";
    }
    
    return cell;
    
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}
@end

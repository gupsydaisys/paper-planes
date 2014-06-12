//
//  HSThreadViewController.m
//  improvisio-v4.2
//
//  Created by lux on 6/11/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSThreadViewController.h"
#import "HSConversationViewController.h"
#import "HSCommentCell.h"
#import "HSComment.h"
#import "DateTools.h"

@interface HSThreadViewController ()

@end

@implementation HSThreadViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ parent conversation controller", [self getConversationViewController]);
}

- (HSConversationViewController*) getConversationViewController {
    return (HSConversationViewController*)self.parentViewController;
}

- (NSArray*) getComments {
    return [self getConversationViewController].conversation.comments;
}
- (void) commentAdded {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Comments array %@", [self getComments]);
    return [self getComments] == nil ? 0 : [self getComments].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    HSComment *comment = [self getComments][indexPath.row];
    NSLog(@"Current comment %@", comment);
    
    
    cell.content.text = comment.content;
    cell.timestamp.text = comment.updatedAt.timeAgoSinceNow;
    NSLog(@"comment creator %@", comment.creator);
    cell.creator.text = comment.creator.username;
    return cell;
}




@end

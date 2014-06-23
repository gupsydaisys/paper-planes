//
//  HSFeedViewController.m
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//
#import "HSUtilities.h"
#import "HSFeedViewController.h"
#import "HSSummaryCell.h"
#import "HSConversation.h"
#import "HSConversationViewController.h"
#import "HSComment.h"
#import "DateTools.h"

@interface HSFeedViewController () {
    HSConversation *selectedConversation;
    NSURL *imageFileUrl;
}

@end

@implementation HSFeedViewController

- (void)viewDidLoad {
    NSLog(@"viewDidLoad feed");
    [super viewDidLoad];
    PFQuery *query = [HSConversation query];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"creator"];
    [query includeKey:@"dotboxes"];
    [query includeKey:@"dotboxes.comments"];
    [query includeKey:@"comments"];
    [query includeKey:@"comments.creator"];
    [query includeKey:@"comments.dotBox"];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(handleGetConversations:error:)];
}


- (void) handleGetConversations:(NSArray *)result error:(NSError *)error {
    if (!error) {
        self.conversations = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
    } else {
        [HSUtilities showError:error];
        // TODO what should you do when error occurs
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationSummary" forIndexPath:indexPath];
    HSConversation *curr = (HSConversation*) self.conversations[indexPath.row];
    HSComment *lastComment = (HSComment*)(curr.comments.lastObject);

    cell.headingLabel.text = curr.title;
    cell.commentCountLabel.text = [NSString stringWithFormat:@"%d comments", curr.comments.count];
    cell.usernameLabel.text = curr.creator.username;
    
    cell.updatedLastLabel.text = [NSString stringWithFormat:@"Last Updated %@ by %@", curr.updatedAt.timeAgoSinceNow, lastComment.creator.username];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedConversation = self.conversations[indexPath.row];
    if (selectedConversation.image == nil || selectedConversation.image.url == nil) {
        imageFileUrl = nil;
    } else {
        imageFileUrl = [[NSURL alloc] initWithString:selectedConversation.image.url];
    }
    [self performSegueWithIdentifier:@"FeedToConversationSegue" sender:self];
}

- (IBAction)tapSettings:(id)sender {
    [self performSegueWithIdentifier:@"FeedToSettingsSegue" sender:self];
}

- (IBAction)tapAddConversation:(id)sender {
    [self performSegueWithIdentifier:@"FeedToNewConversationSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"FeedToConversationSegue"]) {
        HSConversationViewController *next = (HSConversationViewController*)segue.destinationViewController;
        next.conversation = selectedConversation;
        next.imageFileUrl = imageFileUrl;
    }
}


@end

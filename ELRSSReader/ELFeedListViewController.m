//
//  ELFeedsViewController.m
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import "ELFeedListViewController.h"
#import "ELDetailFeedViewController.h"
#import "ELFeedItem.h"
#import "ELFeedCell.h"

@interface ELFeedListViewController ()

@end

@implementation ELFeedListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"MyFeeds";
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self
                            action:@selector(actionRefreshTableView:)
                  forControlEvents:UIControlEventValueChanged];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Actions

- (void)actionRefreshTableView:(id)sender {
    [[ELServerManager sharedManager] getRSSForStreamURL:self.streamURL
                                              onSuccess:^(NSArray *feedItems) {
                                                  self.feedsArray = [NSMutableArray arrayWithArray:feedItems];
                                                  [self.tableView reloadData];
                                              }];
    [self.refreshControl endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    ELFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *) indexPath
{
    ELFeedItem *currentFeed = [self.feedsArray objectAtIndex:indexPath.row];
    [(ELFeedCell *)cell feedTitleLabel].text = currentFeed.title;
    [(ELFeedCell *)cell pubDateLabel].text = [NSString stringWithFormat:@"%@", currentFeed.pubDate];
}

#pragma  mark - Segue 

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        ELDetailFeedViewController *vc = (ELDetailFeedViewController *)segue.destinationViewController;
        vc.feedItem = [self.feedsArray objectAtIndex:indexPath.row];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 44.f;
    
    if (indexPath.row != self.feedsArray.count) {
        ELFeedItem *feedItem = [self.feedsArray objectAtIndex:indexPath.row];
        height = [ELFeedCell heightForText:feedItem.title];
    }
    
    return height;
}

@end

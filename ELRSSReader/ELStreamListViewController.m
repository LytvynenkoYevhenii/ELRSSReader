//
//  ELStreamsViewController.m
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import "ELStreamListViewController.h"
#import "ELStreamCell.h"
#import "ELFeedListViewController.h"
#import "ELServerManager.h"
#import "ELStreamItem.h"

@interface ELStreamListViewController ()

@end

@implementation ELStreamListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.streamsArray) {
        self.streamsArray = [NSMutableArray array];
        [self.streamsArray addObjectsFromArray:[ELStreamItem MR_findAll]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *newStreamsArray = [ELStreamItem MR_findAll];
    
    if (newStreamsArray.count > self.streamsArray.count) {
        self.streamsArray = [NSMutableArray arrayWithArray:newStreamsArray];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.streamsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    ELStreamCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *) indexPath
{
    [(ELStreamCell *)cell mainLabel].text = [self.streamsArray objectAtIndex:indexPath.row].title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ELStreamItem *currentStream = [self.streamsArray objectAtIndex:indexPath.row];
        
        [currentStream MR_deleteEntity];
        [self.streamsArray removeObject:currentStream];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    }
}

#pragma mark - UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    ELFeedListViewController *vc = (ELFeedListViewController *)segue.destinationViewController;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        
        NSIndexPath *indexPathOfSelectedCell = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        NSString *streamLink = [self.streamsArray objectAtIndex:indexPathOfSelectedCell.row].link;
        NSURL *streamURL = [NSURL URLWithString:streamLink];
        
        [[ELServerManager sharedManager] getRSSForStreamURL:streamURL
                                                  onSuccess:^(NSArray *feedItems) {
                                                      vc.streamURL = streamURL;
                                                      vc.feedsArray = [NSMutableArray arrayWithArray: feedItems];
                                                      [vc.tableView reloadData];
                                                  }];
    }
}

@end

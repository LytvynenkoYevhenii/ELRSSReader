//
//  ELFeedsViewController.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELServerManager.h"

@class ELFeedItem;

@interface ELFeedListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray <ELFeedItem *> *feedsArray;
@property (strong, nonatomic) NSURL *streamURL;

@end

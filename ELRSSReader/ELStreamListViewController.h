//
//  ELStreamsViewController.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELStreamItem;

@interface ELStreamListViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray <ELStreamItem *> *streamsArray;


@end

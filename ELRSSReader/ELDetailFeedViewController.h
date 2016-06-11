//
//  ELDetailFeedViewController.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 10.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELFeedItem;

@interface ELDetailFeedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) ELFeedItem *feedItem;

@end

//
//  ELDetailFeedViewController.m
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 10.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import "ELDetailFeedViewController.h"
#import "ELFeedItem.h"

@interface ELDetailFeedViewController ()

@end

@implementation ELDetailFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Datails";
    [self.webView loadHTMLString:self.feedItem.itemDescription baseURL:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

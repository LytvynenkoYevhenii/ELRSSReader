//
//  ELFeedItem.m
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import "ELFeedItem.h"
#import "ELStreamItem.h"

@implementation ELFeedItem

- (void)setRSSInfo:(NSDictionary *)responseObject {
    NSManagedObjectContext *restMOC = [NSManagedObjectContext MR_defaultContext];
    [restMOC performBlockAndWait:^{
        self.title              = [responseObject objectForKey:@"title"];
        self.itemDescription    = [responseObject objectForKey:@"itemDescription"];
        self.link               = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"link"]];
        self.commentsLink       = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"commentsLink"]];
        self.commentsFeed       = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"commentsFeed"]];
        self.commentsCount      = [responseObject objectForKey:@"commentsCount"];
        NSString *pubDate       = [responseObject objectForKey:@"pubDate"];
        self.pubDate            = [pubDate substringToIndex:pubDate.length - 8];
        self.author             = [responseObject objectForKey:@"author"];
        self.guid               = [responseObject objectForKey:@"guid"];
        self.stream             = [responseObject objectForKey:@"stream"];
    }];
}

@end

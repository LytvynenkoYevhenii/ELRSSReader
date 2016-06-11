//
//  ELServerManager.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 08.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

@interface ELServerManager : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

+ (ELServerManager *)sharedManager;

- (void) getRSSForStreamURL:(NSURL *)streamURL
               onSuccess:(void(^)(NSArray *feedItems))success;


@end


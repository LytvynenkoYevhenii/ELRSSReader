//
//  ELServerManager.m
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 08.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import "ELServerManager.h"
#import "ELFeedItem.h"
#import "ELStreamItem.h"

@interface ELServerManager()

@property (strong, nonatomic) NSSet *acceptableContentTypes;
@property (strong, nonatomic) NSMutableDictionary* responseObject;
@property (strong, nonatomic) NSMutableString* tmpString;
@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) NSURL *currentStreamURL;

@end

@implementation ELServerManager

#pragma mark - Initialization

+ (ELServerManager *)sharedManager {
    static ELServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ELServerManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.acceptableContentTypes = [NSSet setWithObjects:
                                       @"application/xml",
                                       @"text/xml",
                                       @"application/rss+xml",
                                       @"application/atom+xml", nil];
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
        self.requestOperationManager.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
        self.requestOperationManager.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
    }
    return self;
}

#pragma mark -

- (NSArray *) findAllFeedsOfStreamWithURL:(NSURL *)streamURL {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stream.link == %@", streamURL];
    return [ELFeedItem MR_findAllWithPredicate:predicate];
}

- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    operation.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
    operation.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id newResponseObject) {
        
        [(NSXMLParser *)newResponseObject abortParsing];
        
        NSArray *feedsOfCurrentStream = [self findAllFeedsOfStreamWithURL:urlRequest.URL];
        
        for (ELFeedItem *item in feedsOfCurrentStream) {
            [item MR_deleteEntity];
        }
        [(NSXMLParser *)newResponseObject setDelegate:self];
        [(NSXMLParser *)newResponseObject parse];
        
        if (success) {
            NSArray *itemsArray = [self findAllFeedsOfStreamWithURL:urlRequest.URL];
            success(itemsArray);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [operation start];
    
}
- (void) getRSSForStreamURL:(NSURL *)streamURL
               onSuccess:(void(^)(NSArray *feedItems))success {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getRSSForStreamURL:streamURL onSuccess:success];
    });
    
    self.currentStreamURL = streamURL;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:streamURL];

    [self parseRSSFeedForRequest:request
                         success:^(NSArray *feedItems) {
                             if (success) {
                                 success (feedItems);
                             }
                         }
                         failure:^(NSError *error) {
                             NSArray *feedItemsFromDataBase = [self findAllFeedsOfStreamWithURL:streamURL];
                             if (success) {
                                 success(feedItemsFromDataBase);
                             }
                         }];
}

#pragma mark NSXMLParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
        self.responseObject = [NSMutableDictionary new];
    }
    
    self.tmpString = [[NSMutableString alloc] init];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
        NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
       
        [moc performBlockAndWait:^{
            ELFeedItem *item = [ELFeedItem MR_findFirstOrCreateByAttribute:@"title"
                                                                 withValue:[self.responseObject objectForKey:@"title"]
                                                                 inContext:moc];
            [item setRSSInfo:self.responseObject];
            [moc MR_saveToPersistentStoreAndWait];
        }];
    }
    
    if (self.responseObject != nil && self.tmpString != nil) {
        
        if ([elementName isEqualToString:@"title"]) {
            [self.responseObject setObject:self.tmpString forKey:@"title"];
        }
        
        else if ([elementName isEqualToString:@"description"]) {
            [self.responseObject setObject:self.tmpString forKey:@"itemDescription"];
        }
        
        else if ([elementName isEqualToString:@"content:encoded"] || [elementName isEqualToString:@"content"]) {
            [self.responseObject setObject:self.tmpString forKey:@"content"];
        }
        
        else if ([elementName isEqualToString:@"link"]) {
            [self.responseObject setObject:[NSURL URLWithString:self.tmpString] forKey:@"link"];
        }
        
        else if ([elementName isEqualToString:@"comments"]) {
            [self.responseObject setObject:[NSURL URLWithString:self.tmpString] forKey:@"comments"];
        }
        
        else if ([elementName isEqualToString:@"pubDate"]) {
            [self.responseObject setObject:self.tmpString forKey:@"pubDate"];
        }
        if (![self.responseObject valueForKey:@"stream"]) {
            ELStreamItem *currentStream = [ELStreamItem MR_findFirstByAttribute:@"link"
                                                                      withValue:self.currentStreamURL];
            [self.responseObject setObject:currentStream forKey:@"stream"];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.tmpString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [parser abortParsing];
}


@end

//
//  ELFeedItem+CoreDataProperties.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ELFeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ELFeedItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSNumber *commentsCount;
@property (nullable, nonatomic, retain) NSString *commentsFeed;
@property (nullable, nonatomic, retain) NSString *commentsLink;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *guid;
@property (nullable, nonatomic, retain) NSString *itemDescription;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *pubDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) ELStreamItem *stream;

@end

NS_ASSUME_NONNULL_END

//
//  ELStreamItem+CoreDataProperties.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ELStreamItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ELStreamItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<ELFeedItem *> *feeds;

@end

@interface ELStreamItem (CoreDataGeneratedAccessors)

- (void)addFeedsObject:(ELFeedItem *)value;
- (void)removeFeedsObject:(ELFeedItem *)value;
- (void)addFeeds:(NSSet<ELFeedItem *> *)values;
- (void)removeFeeds:(NSSet<ELFeedItem *> *)values;

@end

NS_ASSUME_NONNULL_END

//
//  ELFeedItem.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ELStreamItem;

NS_ASSUME_NONNULL_BEGIN

@interface ELFeedItem : NSManagedObject

- (void)setRSSInfo:(NSDictionary *)responseObject;

@end

NS_ASSUME_NONNULL_END

#import "ELFeedItem+CoreDataProperties.h"

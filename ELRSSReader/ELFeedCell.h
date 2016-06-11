//
//  ELFeedCell.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *feedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

+ (CGFloat) heightForText:(NSString *)text;

@end

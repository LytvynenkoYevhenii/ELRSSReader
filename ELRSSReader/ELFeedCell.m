//
//  ELFeedCell.m
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import "ELFeedCell.h"

@implementation ELFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineImageView.backgroundColor = RANDOM_COLOR;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    // Configure the view for the selected state
}

+ (CGFloat) heightForText:(NSString *)text {
    
    CGFloat offset = 5.f;
    
    UIFont *font = [UIFont systemFontOfSize:15.f];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:attributes
                                      context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}


@end

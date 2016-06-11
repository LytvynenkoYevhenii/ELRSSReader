//
//  ELStreamConfigureViewController.h
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELStreamItem;

@interface ELStreamConfigureViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *linkField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) ELStreamItem *streamItem;

- (IBAction)actionSave:(UIButton *)sender;

@end

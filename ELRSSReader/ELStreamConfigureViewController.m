//
//  ELStreamConfigureViewController.m
//  ELRSSReader
//
//  Created by Yevhenii Lytvynenko on 09.06.16.
//  Copyright © 2016 Yevhenii Lytvynenko. All rights reserved.
//

#import "ELStreamConfigureViewController.h"
#import "ELStreamItem.h"

@interface ELStreamConfigureViewController ()

@end

@implementation ELStreamConfigureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"StreamConfig";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void) saveContext
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
//            NSLog(@"You successfully saved your context.");
        } else if (error) {
//            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

- (void) changeSaveButtonStatus:(UIButton *)saveButton {
    saveButton.enabled = !saveButton.isEnabled;
    
    UIColor *newColor;
    
    if (saveButton.isEnabled) {
        newColor = SAVE_BUTTON_ENABLED_COLOR;
    }
    else {
        newColor = SAVE_BUTTON_DISABLED_COLOR;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.saveButton.backgroundColor = newColor;
    }];
    
}

#pragma mark - Actions

- (IBAction)actionSave:(UIButton *)sender
{
    [self changeSaveButtonStatus:sender];
    
    if (!sender.isEnabled) {
        
        if (!self.streamItem) {
            
            if ([ELStreamItem MR_findFirstByAttribute:@"link" withValue:self.linkField.text]) {
             
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You can`t do it!"
                                                                                         message:@"Sorry, but you already have the same stream!"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      
                                                                      // OK button tapped
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                      }];
                                                                  }]];
                
                // Present alert
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else {
                self.streamItem = [ELStreamItem MR_createEntity];
                self.streamItem.title = self.titleField.text;
                self.streamItem.link = self.linkField.text;
                [self saveContext];
            }
        }
        if ([self.linkField isFirstResponder]) {
            [self.linkField resignFirstResponder];
        }
        else if ([self.titleField isFirstResponder]){
            [self.titleField resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (!self.saveButton.isEnabled) {
        [self changeSaveButtonStatus:self.saveButton];
    }
    return YES;
}

@end

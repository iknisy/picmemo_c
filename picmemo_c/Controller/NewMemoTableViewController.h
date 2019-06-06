//
//  NewMemoTableViewController.h
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/5/25.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewMemoTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet UIImageView *photoImageView;
    IBOutlet UITextField *timeTextField;
    IBOutlet UITextView *describTextView;
}

@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UITextField *timeTextField;
@property (strong, nonatomic) UITextView *describTextView;
@property (strong, nonatomic) NSString *photoID;

-(IBAction)backView:(id)sender;
-(IBAction)saveButton:(id)sender;

@end

NS_ASSUME_NONNULL_END

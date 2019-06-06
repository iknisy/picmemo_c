//
//  GridCollectionViewController.h
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/5/22.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface GridCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate> {
    IBOutlet UIButton *delbutton;
}

@property (strong, nonatomic) UIButton *delbutton;


-(IBAction)newMemo:(id)sender;
-(IBAction)delAction:(id)sender;


@end

NS_ASSUME_NONNULL_END

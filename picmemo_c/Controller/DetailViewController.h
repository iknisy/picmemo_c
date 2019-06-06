//
//  DetailViewController.h
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/6/4.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController<CAAnimationDelegate> {
    IBOutlet UIImageView *detailImageView;
    IBOutlet UILabel *detailLabel;
    IBOutlet UIView *detailView;
}

@property (strong, nonatomic) UIImageView *detailImageView;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) NSMutableArray *memoDetails;
@property (nonatomic) NSInteger index;

@end

NS_ASSUME_NONNULL_END

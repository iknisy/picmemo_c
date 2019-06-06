//
//  DetailViewController.m
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/6/4.
//  Copyright © 2019 Mike. All rights reserved.
//

#import "DetailViewController.h"
#import "picmemo_c+CoreDataModel.h"
#import <Photos/Photos.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize detailView;
@synthesize detailLabel;
@synthesize detailImageView;
@synthesize memoDetails;
@synthesize index;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (memoDetails.count > 0){
//        讀取Core的Detail
        [self loadDetail];
    }
//    監控單擊畫面
    UITapGestureRecognizer *singletouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelHidenSwitch:)];
    singletouch.numberOfTouchesRequired = 1;
    singletouch.numberOfTapsRequired = 1;
    [detailView addGestureRecognizer:singletouch];
//    監控左右滑動
    UISwipeGestureRecognizer *swipeToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewSwip:)];
    [swipeToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [detailView addGestureRecognizer:swipeToLeft];
    UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewSwip:)];
    [swipeToRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [detailView addGestureRecognizer:swipeToRight];
}

- (void) loadDetail {
//    顯示CoreData內容
    MemoDetail *memoDetail = [memoDetails objectAtIndex:index];
    detailLabel.text = memoDetail.describe;
    NSError *error = nil;
    detailLabel.textColor = [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:memoDetail.textColor error:&error];
    if (error != nil){
        NSLog(@"Unarchiver ERROR. %@", error);
    }
    PHFetchResult<PHAsset *> *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[memoDetail.imageID] options:nil];
    [[PHImageManager defaultManager] requestImageForAsset:asset[0] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *image, NSDictionary *info){
        if (image != nil){
            self.detailImageView.image = image;
        }
    }];
}

- (void) labelHidenSwitch: (UIGestureRecognizer *)gesture {
//    隱藏文字，只顯示圖片
    detailLabel.hidden = !detailLabel.isHidden;
}

- (void) viewSwip: (UISwipeGestureRecognizer *)gesture {
//    左右滑動後切換上下頁
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
//            由右向左滑，下一頁
            if (index < memoDetails.count-1){
                index += 1;
                [self loadDetail];
                [self swipeAnimationToLeft];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
//            由左向右滑，上一頁
            if (index > 0){
                index -= 1;
                [self loadDetail];
                [self swipeAnimationToRight];
            }
            break;
        default:
            break;
    }
}

- (void) swipeAnimationToLeft {
//    向左滑動的換頁動畫
    CATransition *animate = [[CATransition alloc] init];
    [animate setType:kCATransitionPush];
    [animate setSubtype:kCATransitionFromRight];
    [animate setDuration:0.5];
    [animate setDelegate:self];
    [animate setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [detailView.layer addAnimation:animate forKey:@"rightToLeftAnimation"];
}
- (void) swipeAnimationToRight {
//    向右滑動的換頁動畫
    CATransition *animate = [[CATransition alloc] init];
    [animate setType:kCATransitionPush];
    [animate setSubtype:kCATransitionFromLeft];
    [animate setDuration:0.5];
    [animate setDelegate:self];
    [animate setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [detailView.layer addAnimation:animate forKey:@"leftToRightAnimation"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

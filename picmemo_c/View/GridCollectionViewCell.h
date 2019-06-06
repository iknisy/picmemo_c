//
//  GridCollectionViewCell.h
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/5/22.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GridCollectionViewCell : UICollectionViewCell {
    IBOutlet UIImageView *gridImageView;
    
}
@property (strong, nonatomic) UIImageView *gridImageView;

@end

NS_ASSUME_NONNULL_END

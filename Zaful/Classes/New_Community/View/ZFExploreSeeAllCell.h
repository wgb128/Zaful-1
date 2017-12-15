//
//  ZFExploreSeeAllCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExploreSeeAllCompletionHandler)(void);

@interface ZFExploreSeeAllCell : UICollectionViewCell

@property (nonatomic, copy) ExploreSeeAllCompletionHandler      exploreSeeAllCompletionHandler;
@end

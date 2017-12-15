//
//  ZFSizeSelectQityNumberView.h
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SizeSelectQityNumberChangeCompletionHandler)(NSInteger number);

@interface ZFSizeSelectQityNumberView : UICollectionReusableView

@property (nonatomic, assign) NSInteger         number;
@property (nonatomic, assign) NSInteger         goodsNumber;

@property (nonatomic, copy) SizeSelectQityNumberChangeCompletionHandler     sizeSelectQityNumberChangeCompletionHandler;

@end

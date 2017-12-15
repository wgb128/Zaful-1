//
//  VideoHeaderView.h
//  Zaful
//
//  Created by huangxieyue on 16/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoDetailInfoModel;

@interface VideoHeaderView : UIView

@property (nonatomic, copy) void (^likeBlock)();//点赞

@property (nonatomic, strong) VideoDetailInfoModel *infoModel;

@property (nonatomic, strong) VideoDetailInfoModel *likeModel;
@property (nonatomic, copy) void (^refreshHeadViewBlock)();//My Style Block
@end

//
//  ZFCommunityAccountSelectView.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFCommunityAccountSelectType) {
    ZFCommunityAccountSelectTypeShow = 0,
    ZFCommunityAccountSelectTypeOutfits,
    ZFCommunityAccountSelectTypeLike,
};

typedef void(^CommunityAccountSelectCompletionHandler)(ZFCommunityAccountSelectType type);

@interface ZFCommunityAccountSelectView : UIView
@property (nonatomic, assign) ZFCommunityAccountSelectType currentType;

@property (nonatomic, copy) CommunityAccountSelectCompletionHandler communityAccountSelectCompletionHandler;
@end

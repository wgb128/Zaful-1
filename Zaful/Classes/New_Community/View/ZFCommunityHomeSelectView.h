//
//  ZFCommunityHomeSelectView.h
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFCommunityHomeSelectType) {
    ZFCommunityHomeSelectTypeExplore = 0,
    ZFCommunityHomeSelectTypeOutfits,
    ZFCommunityHomeSelectTypeFaves
};

typedef void(^CommunityHomeSelectCompletionHandler)(ZFCommunityHomeSelectType type);

typedef void(^CommunityLoginTipsCompletionHandler)(void);
 
@interface ZFCommunityHomeSelectView : UIView

@property (nonatomic, assign) ZFCommunityHomeSelectType     currentType;

@property (nonatomic, copy) CommunityHomeSelectCompletionHandler    communityHomeSelectCompletionHandler;

@property (nonatomic, copy) CommunityLoginTipsCompletionHandler     communityLoginTipsCompletionHandler;

@end


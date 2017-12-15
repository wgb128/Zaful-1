//
//  TopicDetailView.h
//  Zaful
//
//  Created by DBP on 16/12/2.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicDetailView : UIView
@property (nonatomic, copy) void (^topicDetailSelectBlock)(NSInteger sort);//My Style Block
@end

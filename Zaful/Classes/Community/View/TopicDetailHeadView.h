//
//  TopicDetailHeadView.h
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailHeadLabelModel.h"

@interface TopicDetailHeadView : UIView
@property (nonatomic, strong) TopicDetailHeadLabelModel *topicDetailHeadModel;
@property (nonatomic, copy) void (^joinInMyStyleBlock)(NSString *topicLabel);//My Style Block
@property (nonatomic, copy) void (^refreshHeadViewBlock)();//My Style Block
@end

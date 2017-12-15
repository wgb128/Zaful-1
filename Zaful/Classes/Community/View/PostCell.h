//
//  PostCell.h
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostModel;

typedef BOOL (^ChangeCountBlock)(BOOL selected);

@interface PostCell : UITableViewCell

@property (nonatomic,strong) PostModel *postModel;

@property (nonatomic,copy) ChangeCountBlock changeCountBlock;

@property (nonatomic,strong) UIButton *selectButton;

@end

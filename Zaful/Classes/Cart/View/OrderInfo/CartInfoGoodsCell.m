//
//  CartInfoGoodsCell.m
//  Zaful
//
//  Created by zhaowei on 2017/4/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CartInfoGoodsCell.h"
#import "FDStackView.h"
#import "CheckOutGoodListModel.h"

@interface CartInfoGoodsCell ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *itemsLabel;
@property (nonatomic, strong) YYAnimatedImageView *arrowImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contrainerView;
@property (nonatomic, strong) UIView    *maskView;
@property (nonatomic, strong) UILabel   *countLabel;
@end

@implementation CartInfoGoodsCell

+ (CartInfoGoodsCell *)goodsCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoGoodsCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.itemsLabel.text = nil;
    [self.contrainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [obj removeFromSuperview];
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.mas_equalTo(self.contentView);
            make.height.mas_equalTo(56);
        }];
        
        [self.topView addSubview:self.itemsLabel];
        [self.itemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_top).offset(16);
            make.leading.mas_equalTo(self.topView.mas_leading).offset(12);
        }];
        
        [self.topView addSubview:self.arrowImageView];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.topView.mas_trailing).offset(-12);
            make.centerY.mas_equalTo(self.topView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.scrollView];
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.leading.trailing.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).offset(-24);
        }];
        
        [self.scrollView addSubview:self.contrainerView];
        [self.contrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.scrollView).with.insets(UIEdgeInsetsZero);
            make.centerY.mas_equalTo(self.scrollView.mas_centerY);
        }];
    }
    return self;
}


- (void)setGoodsList:(NSArray *)goodsList {
    _goodsList = goodsList;
    
    NSInteger count = 0;
    for (CheckOutGoodListModel *goodImgListModel in goodsList) {
         count = count + [goodImgListModel.goods_number integerValue];
    }

    self.itemsLabel.text =  goodsList.count > 1 ? [NSString stringWithFormat:@"%ld %@",count, ZFLocalizedString(@"CartOrderInfo_Goods_Items", nil)] : [NSString stringWithFormat:@"%ld %@",count, ZFLocalizedString(@"CartOrderInfo_Goods_Item", nil)];

    CGFloat imgWidth = (SCREEN_WIDTH - 12*4)/3;
    
    [self.contrainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [obj removeFromSuperview];
    }];
    
    if (![NSArrayUtils isEmptyArray:goodsList]) {
        if (goodsList.count == 1) {
            CheckOutGoodListModel *goodImgListModel = goodsList.firstObject;
            YYAnimatedImageView *comtentImg = [YYAnimatedImageView new];
            comtentImg.contentMode = UIViewContentModeScaleAspectFill;
            if ([SystemConfigUtils isRightToLeftShow]) {
                comtentImg.transform = CGAffineTransformMakeRotation(M_PI);
            }
            comtentImg.clipsToBounds = YES;
            [comtentImg yy_setImageWithURL:[NSURL URLWithString:goodImgListModel.wp_image]
                              processorKey:NSStringFromClass([self class])
                               placeholder:[UIImage imageNamed:@"loading_cat_list"]
                                   options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                 transform:^UIImage *(UIImage *image, NSURL *url) {
                                     image = [image yy_imageByResizeToSize:CGSizeMake(imgWidth,imgWidth * 1.33) contentMode:UIViewContentModeScaleAspectFill];
                                     return image;
                                 }
                                completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                }];
            [self.contrainerView addSubview:comtentImg];
            
            [comtentImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contrainerView.mas_top);
                make.bottom.mas_equalTo(self.contrainerView.mas_bottom);
                make.leading.mas_equalTo(self.contrainerView.mas_leading).offset(12);
                make.trailing.mas_equalTo(self.contrainerView.mas_trailing).offset(-12);
                make.width.mas_equalTo(imgWidth);
                make.height.mas_equalTo(imgWidth * 1.33);
            }];
            
            UIView *maskView = [UIView new];
            maskView.backgroundColor = ZFCOLOR(51, 51, 51, 0.3);
            [comtentImg addSubview:maskView];
            [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            
            UILabel *countLabel = [UILabel new];
            countLabel.font = [UIFont systemFontOfSize:20];
            countLabel.textColor = ZFCOLOR(255, 255, 255, 1);
            countLabel.text = [NSString stringWithFormat:@"x%@",goodImgListModel.goods_number];
            
            [maskView addSubview:countLabel];
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(maskView);
            }];
            
        } else {
            NSMutableArray *tempArray = [NSMutableArray array];
            
            [goodsList enumerateObjectsUsingBlock:^(CheckOutGoodListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YYAnimatedImageView *comtentImg = [YYAnimatedImageView new];
                comtentImg.contentMode = UIViewContentModeScaleAspectFill;
                if ([SystemConfigUtils isRightToLeftShow]) {
                    comtentImg.transform = CGAffineTransformMakeRotation(M_PI);
                }
                comtentImg.clipsToBounds = YES;
                [comtentImg yy_setImageWithURL:[NSURL URLWithString:obj.wp_image]
                                  processorKey:NSStringFromClass([self class])
                                   placeholder:[UIImage imageNamed:@"loading_cat_list"]
                                       options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                      progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                     transform:^UIImage *(UIImage *image, NSURL *url) {
                                         image = [image yy_imageByResizeToSize:CGSizeMake(imgWidth,imgWidth * 1.33) contentMode:UIViewContentModeScaleAspectFill];
                                         return image;
                                     }
                                    completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                    }];
                [self.contrainerView addSubview:comtentImg];
                [tempArray addObject:comtentImg];
                
                UIView *maskView = [UIView new];
                maskView.backgroundColor = ZFCOLOR(51, 51, 51, 0.3);
                [comtentImg addSubview:maskView];
                [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsZero);
                }];
                
                UILabel *countLabel = [UILabel new];
                countLabel.font = [UIFont systemFontOfSize:20];
                countLabel.textColor = ZFCOLOR(255, 255, 255, 1);
                countLabel.text = [NSString stringWithFormat:@"x%@",obj.goods_number];
                
                [maskView addSubview:countLabel];
                [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(maskView);
                }];
            }];
            
            [tempArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:12 tailSpacing:12];
            [tempArray mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(imgWidth);
                make.height.mas_equalTo(imgWidth * 1.33);
                make.top.mas_equalTo(self.contrainerView.mas_top);
                make.bottom.mas_equalTo(self.contrainerView.mas_bottom);
            }];
        }
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
    }
    return _topView;
}

- (UILabel *)itemsLabel {
    if (!_itemsLabel) {
        _itemsLabel = [UILabel new];
        _itemsLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemsLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _itemsLabel;
}

- (YYAnimatedImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [YYAnimatedImageView new];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.image = [UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"account_arrow_left" : @"account_arrow_right"];
    }
    return _arrowImageView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _scrollView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)contrainerView {
    if (!_contrainerView) {
        _contrainerView = [UIView new];
    }
    return _contrainerView;
}


- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = ZFCOLOR(51, 51, 51, 0.3);
    }
    return _maskView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont systemFontOfSize:20];
        _countLabel.textColor = ZFCOLOR(255, 255, 255, 1);
    }
    return _countLabel;
}

@end

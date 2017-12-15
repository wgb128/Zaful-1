//
//  CartInfoGoodsCell.m
//  Zaful
//
//  Created by zhaowei on 2017/4/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CartInfoGoodsListCell.h"
#import "CheckOutGoodListModel.h"
#import "ZFOrderMultiAttributeInfoView.h"

@interface CartInfoGoodsListCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YYAnimatedImageView *goodImg;
@property (nonatomic, strong) UILabel *goodNameLabel;
@property (nonatomic, strong) UILabel *colorTitleLabel;
@property (nonatomic, strong) UILabel *colorValueLabel;
@property (nonatomic, strong) UILabel *goodsNumLabel;
@property (nonatomic, strong) UILabel *sizeTitleLabel;
@property (nonatomic, strong) UILabel *sizeValueLabel;
@property (nonatomic, strong) ZFOrderMultiAttributeInfoView      *attrView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *subTotalLabel;

@end

@implementation CartInfoGoodsListCell

+ (CartInfoGoodsListCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[CartInfoGoodsListCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(MIN_PIXEL);
            make.leading.mas_equalTo(self.contentView.mas_leading);
            make.trailing.mas_equalTo(self.contentView.mas_trailing);
            make.height.mas_equalTo(@(MIN_PIXEL));
        }];
        
        self.goodImg = [[YYAnimatedImageView alloc] init];
        self.goodImg.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.goodImg];
        [self.goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(12);
            make.height.mas_equalTo(@(133 * DSCREEN_WIDTH_SCALE));
            make.width.mas_equalTo(@(100 * DSCREEN_WIDTH_SCALE));
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
        }];
        
        self.goodNameLabel = [[UILabel alloc] init];
        self.goodNameLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.goodNameLabel.numberOfLines = 2;
        self.goodNameLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:self.goodNameLabel];
        [self.goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodImg.mas_trailing).offset(10);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.goodImg.mas_top);
        }];
        
        self.colorTitleLabel = [[UILabel alloc] init];
        self.colorTitleLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.colorTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [self.contentView addSubview:self.colorTitleLabel];
        [self.colorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodNameLabel);
            make.top.mas_equalTo(self.goodNameLabel.mas_bottom).offset(4);
        }];
        
        self.colorValueLabel = [[UILabel alloc] init];
        self.colorValueLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.colorValueLabel.font = [UIFont systemFontOfSize:14];
        [self.colorValueLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel
                                   forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:self.colorValueLabel];
        [self.colorValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.colorTitleLabel.mas_trailing);
            make.trailing.mas_equalTo(self.goodNameLabel);
            make.centerY.mas_equalTo(self.colorTitleLabel.mas_centerY);
        }];
        
        self.sizeTitleLabel = [[UILabel alloc] init];
        self.sizeTitleLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.sizeTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [self.contentView addSubview:self.sizeTitleLabel];
        [self.sizeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodNameLabel);
            make.top.mas_equalTo(self.colorTitleLabel.mas_bottom).offset(4);
        }];
        
        self.sizeValueLabel = [[UILabel alloc] init];
        self.sizeValueLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.sizeValueLabel.font = [UIFont systemFontOfSize:14];
        [self.sizeValueLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel
                                                forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:self.sizeValueLabel];
        [self.sizeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.sizeTitleLabel.mas_trailing);
            make.trailing.mas_equalTo(self.goodNameLabel);
            make.centerY.mas_equalTo(self.sizeTitleLabel.mas_centerY);
        }];
        
        self.attrView = [[ZFOrderMultiAttributeInfoView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.attrView];
        [self.attrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodNameLabel);
            make.top.mas_equalTo(self.sizeTitleLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(0);
        }];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodNameLabel.mas_leading);
            make.bottom.mas_equalTo(self.goodImg.mas_bottom);
        }];
        
       
        self.subTotalLabel = [[UILabel alloc] init];
        self.subTotalLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.subTotalLabel.font = [UIFont boldSystemFontOfSize:16];
        
        [self.contentView addSubview:self.subTotalLabel];
        [self.subTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.subTitleLabel.mas_trailing);
            make.bottom.mas_equalTo(self.subTitleLabel.mas_bottom).offset(1);
        }];

        self.goodsNumLabel = [[UILabel alloc] init];
        self.goodsNumLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.goodsNumLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [self.contentView addSubview:self.goodsNumLabel];
        [self.goodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
            make.bottom.mas_equalTo(self.subTitleLabel.mas_bottom);
        }];
        
    }
    return self;
}

- (void)setGoodsModel:(CheckOutGoodListModel *)goodsModel {
    [self.goodImg yy_setImageWithURL:[NSURL URLWithString:goodsModel.wp_image]
                         processorKey:NSStringFromClass([self class])
                          placeholder:[UIImage imageNamed:@"loading_cat_list"]
                              options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            transform:^UIImage *(UIImage *image, NSURL *url) {
                                image = [image yy_imageByResizeToSize:CGSizeMake(100 * DSCREEN_WIDTH_SCALE, 133 * DSCREEN_WIDTH_SCALE) contentMode:UIViewContentModeScaleAspectFit];
                                return image;
                            }
                           completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                               if (from == YYWebImageFromDiskCache) {
                                   ZFLog(@"load from disk cache");
                               }
                           }];
    
    self.goodNameLabel.text = goodsModel.goods_title;
    
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.colorTitleLabel.text = [NSString stringWithFormat:@":%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Color",nil)];
        self.colorValueLabel.text = [NSString stringWithFormat:@"%@",goodsModel.attr_color == nil ? @"" :goodsModel.attr_color];
        self.sizeTitleLabel.text = [NSString stringWithFormat:@":%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Size",nil)];
        self.sizeValueLabel.text = [NSString stringWithFormat:@"%@",goodsModel.attr_size == nil ? @"" :goodsModel.attr_size];
        self.goodsNumLabel.text = [NSString stringWithFormat:@"%@X",goodsModel.goods_number];
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@: ",ZFLocalizedString(@"OrderDetail_Goods_Cell_Total",nil)];
        self.subTotalLabel.text = [ExchangeManager transforPrice:goodsModel.goods_price];
    } else {
        self.colorTitleLabel.text = [NSString stringWithFormat:@"%@:",ZFLocalizedString(@"OrderDetail_Goods_Cell_Color",nil)];
        self.colorValueLabel.text = [NSString stringWithFormat:@"%@",goodsModel.attr_color == nil ? @"" :goodsModel.attr_color];
        self.sizeTitleLabel.text = [NSString stringWithFormat:@"%@:",ZFLocalizedString(@"OrderDetail_Goods_Cell_Size",nil)];
        self.sizeValueLabel.text = [NSString stringWithFormat:@"%@",goodsModel.attr_size == nil ? @"" :goodsModel.attr_size];
        self.goodsNumLabel.text = [NSString stringWithFormat:@"X%@",goodsModel.goods_number];
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@: ",ZFLocalizedString(@"OrderDetail_Goods_Cell_Total",nil)];
        self.subTotalLabel.text = [ExchangeManager transforPrice:goodsModel.goods_price];
    }
    
    if (goodsModel.multi_attr.count > 0) {
        self.attrView.attrsArray = goodsModel.multi_attr;
        [self.attrView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodNameLabel);
            make.top.mas_equalTo(self.sizeTitleLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(goodsModel.multi_attr.count * 16);
        }];
    }
}



@end

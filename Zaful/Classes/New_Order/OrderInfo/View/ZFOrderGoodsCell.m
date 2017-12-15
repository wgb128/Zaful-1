//
//  ZFOrderGoodsCell.m
//  Zaful
//
//  Created by TsangFa on 20/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderGoodsCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFPaymentGoodsInfoView.h"
#import "CheckOutGoodListModel.h"

@interface ZFOrderGoodsCell()<ZFInitViewProtocol>
@property (nonatomic, strong) UILabel                   *infoLabel;
@property (nonatomic, strong) YYAnimatedImageView       *arrowImageView;
@property (nonatomic, strong) ZFPaymentGoodsInfoView    *goodsInfoView;
@end

@implementation ZFOrderGoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - Public method
+ (NSString *)queryReuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.goodsInfoView];
}

- (void)zfAutoLayoutView {
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.infoLabel);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.goodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arrowImageView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 144));
        make.bottom.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Setter
-(void)setGoodsList:(NSArray<CheckOutGoodListModel *> *)goodsList {
    NSInteger count = 0;
    for (CheckOutGoodListModel *goodImgListModel in goodsList) {
        count = count + [goodImgListModel.goods_number integerValue];
    }
    self.infoLabel.text =  goodsList.count > 1 ? [NSString stringWithFormat:@"%ld %@",count, ZFLocalizedString(@"CartOrderInfo_Goods_Items", nil)] : [NSString stringWithFormat:@"%ld %@",count, ZFLocalizedString(@"CartOrderInfo_Goods_Item", nil)];
    
    self.goodsInfoView.dataArray = goodsList;
}

#pragma mark - Getter
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont boldSystemFontOfSize:14];
        _infoLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _infoLabel.text = ZFLocalizedString(@"CartOrderInfo_PromotionCodeCell_PromotionCodeLabel",nil);
        [_infoLabel sizeToFit];
    }
    return _infoLabel;
}

- (YYAnimatedImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [YYAnimatedImageView new];
        UIImage *image = [UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"account_arrow_left" : @"account_arrow_right"];
        _arrowImageView.image = image;
    }
    return _arrowImageView;
}

- (ZFPaymentGoodsInfoView *)goodsInfoView {
    if (!_goodsInfoView) {
        _goodsInfoView = [[ZFPaymentGoodsInfoView alloc] initWithFrame:CGRectZero];
    }
    return _goodsInfoView;
}


@end

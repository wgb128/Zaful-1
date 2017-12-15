//
//  MyOrderDetailGoodsCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "MyOrderDetailGoodsCell.h"

#import "RateModel.h"

@interface MyOrderDetailGoodsCell ()

@property (nonatomic, strong) UIView *hLineViewOne;

@property (nonatomic, strong) UIImageView *goodImg;

@property (nonatomic, strong) UILabel *goodName;

@property (nonatomic, strong) UILabel *goodSKULabel;

@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, strong) UILabel *goodsNumLabel;

@property (nonatomic, strong) UILabel *sizeLabel;

@property (nonatomic, strong) UILabel *subTotalLabel;

@property (nonatomic, strong) MASConstraint *goodsHeight;

@property (nonatomic, strong) BigClickAreaButton *productButton;  //评论按钮

@end

@implementation MyOrderDetailGoodsCell
{
    CGFloat _padding;
}

+ (MyOrderDetailGoodsCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[MyOrderDetailGoodsCell class] forCellReuseIdentifier:MY_ORDERS_DETAIL_GOODS_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:MY_ORDERS_DETAIL_GOODS_INENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviewsContraint];
    }
    return self;
}

-(void)initWithGoodsModel:(MyOrderDetailGoodModel *)goodsModel orderStatue:(NSInteger)orderStatue{
    
    _goodsModel = goodsModel;

    [self.goodImg yy_setImageWithURL:[NSURL URLWithString:goodsModel.goods_grid] processorKey:NSStringFromClass([self class]) placeholder:[UIImage imageNamed:@"pro_m"]];
    
    self.goodName.text = goodsModel.goods_title;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.goodSKULabel.text = [NSString stringWithFormat:@"%@:%@",goodsModel.goods_sn,ZFLocalizedString(@"OrderDetail_Goods_Cell_Sku",nil)];
        
        self.colorLabel.text = [NSString stringWithFormat:@"%@:%@",goodsModel.attr_color == nil ? @"" :goodsModel.attr_color,ZFLocalizedString(@"OrderDetail_Goods_Cell_Color",nil)];
        
        self.sizeLabel.text = [NSString stringWithFormat:@"%@:%@",goodsModel.attr_size == nil ? @"" :goodsModel.attr_size,ZFLocalizedString(@"OrderDetail_Goods_Cell_Size",nil)];
        
        self.goodsNumLabel.text = [NSString stringWithFormat:@"%@X",goodsModel.goods_number];
        self.subTotalLabel.text = [NSString stringWithFormat:@"%@: %@%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Total",nil),goodsModel.goods_price,goodsModel.order_currency];
    } else {
        self.goodSKULabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Sku",nil),goodsModel.goods_sn];
        
        self.colorLabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Color",nil),goodsModel.attr_color == nil ? @"" :goodsModel.attr_color];
        
        self.sizeLabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Size",nil),goodsModel.attr_size == nil ? @"" :goodsModel.attr_size];
        
        self.goodsNumLabel.text = [NSString stringWithFormat:@"X%@",goodsModel.goods_number];
        self.subTotalLabel.text = [NSString stringWithFormat:@"%@: %@%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Total",nil),goodsModel.order_currency,goodsModel.goods_price];
    }
    
    
    CGSize textSize = [self.goodName.text  boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.goodName.font} context:nil].size;
    
    CGFloat goodNameWidth = SCREEN_WIDTH - 12 * 3 - 100;
    
    if (textSize.width > goodNameWidth) { //text的宽度少于Label的宽度就是为1行,不然为多行
        _padding = 10;
    }else{
        _padding = 15;
    }
    
    [self.goodSKULabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodName.mas_bottom).offset(_padding);
    }];
    
    [self.colorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodSKULabel.mas_bottom).offset(_padding);
    }];
    
    [self.sizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorLabel.mas_bottom).offset(_padding);
    }];
    
    if (orderStatue == OrderStateEnumTypePaid || orderStatue == OrderStateEnumTypeProcessing || orderStatue == OrderStateEnumTypeShippedOut  || orderStatue == OrderStateEnumTypeDelivered  || orderStatue == OrderStateEnumTypePartialOrderDispatched ||  orderStatue == OrderStateEnumTypeDispatched || orderStatue == OrderStateEnumTypePartialOrderShipped) {
        self.productButton.hidden = NO;
        self.goodsHeight.mas_equalTo(-50);
        if (goodsModel.is_review == 0) {
            self.productButton.layer.borderColor = ZFCOLOR(255, 111, 0, 1.0).CGColor;
            self.productButton.tag = WriteReview;
            [self.productButton setTitleColor:ZFCOLOR(255, 111, 0, 1.0) forState:UIControlStateNormal];
            [self.productButton setTitle:ZFLocalizedString(@"OrderDetail_Goods_Cell_WriteReview",nil) forState:UIControlStateNormal];
            [self.productButton addTarget:self action:@selector(clickReview:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            self.productButton.layer.borderColor = ZFCOLOR_BLACK.CGColor;
            self.productButton.tag = CheckReview;
            [self.productButton setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
            [self.productButton setTitle:ZFLocalizedString(@"OrderDetail_Goods_Cell_CheckMyReview",nil) forState:UIControlStateNormal];
            [self.productButton addTarget:self action:@selector(clickReview:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else {
        self.goodsHeight.mas_equalTo(-12);
        self.productButton.hidden = YES;
    }

}

- (void)addSubviewsContraint
{
    [self addSubview:self.hLineViewOne];
    [self.hLineViewOne mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(MIN_PIXEL);
        make.leading.offset(12);
        make.trailing.offset(-12);
        make.height.equalTo(@(MIN_PIXEL));
    }];
    
    [self addSubview:self.goodImg];
    [self.goodImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(12);
        make.top.offset(12);
        make.width.equalTo(@100);
        make.height.equalTo(@(150));
        self.goodsHeight = make.bottom.offset(-12);
    }];
    
    [self addSubview:self.goodName];
    [self.goodName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodImg.mas_trailing).offset(10);
        make.trailing.offset(-12);
        make.top.offset(12);
    }];
    
    [self addSubview:self.subTotalLabel];
    [self.subTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.bottom.equalTo(self.goodImg.mas_bottom).offset(0);
    }];
    
    [self addSubview:self.goodSKULabel];
    [self.goodSKULabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.width.equalTo(self.goodName);
        make.top.equalTo(self.goodName.mas_bottom).offset(8);
    }];
    
    [self addSubview:self.colorLabel];
    [self.colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.width.equalTo(self.goodName);
        make.top.equalTo(self.goodSKULabel.mas_bottom).offset(8);
    }];
    
    [self addSubview:self.goodsNumLabel];
    [self.goodsNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.goodName);
        make.centerY.equalTo(self.subTotalLabel);
    }];
    
    [self addSubview:self.sizeLabel];
    [self.sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.width.equalTo(self.goodName);
        make.top.equalTo(self.colorLabel.mas_bottom).offset(8);
    }];
    
    [self addSubview:self.productButton];
    [self.productButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(100);
        make.trailing.offset(-10);
        make.top.mas_equalTo(self.goodsNumLabel.mas_bottom).offset(20);
    }];
}

-(UIView *)hLineViewOne{
    if (!_hLineViewOne) {
        _hLineViewOne = [[UIView alloc] init];
        _hLineViewOne.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
    }
    return _hLineViewOne;
}

-(UIImageView *)goodImg{
    if (!_goodImg) {
        _goodImg = [[UIImageView alloc] init];
        _goodImg.contentMode = UIViewContentModeScaleToFill;
    }
    return _goodImg;
}

-(UILabel *)goodName{
    if (!_goodName) {
        _goodName = [[UILabel alloc] init];
        _goodName.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _goodName.numberOfLines = 2;
        _goodName.font = [UIFont systemFontOfSize:14.0];
    }
    return _goodName;
}

-(UILabel *)goodSKULabel{
    if (!_goodSKULabel) {
        _goodSKULabel = [[UILabel alloc] init];
        _goodSKULabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _goodSKULabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _goodSKULabel;
}

-(UILabel *)colorLabel{
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] init];
        _colorLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _colorLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _colorLabel;
}


-(UILabel *)goodsNumLabel{
    if (!_goodsNumLabel) {
        _goodsNumLabel = [[UILabel alloc] init];
        _goodsNumLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _goodsNumLabel.font = [UIFont systemFontOfSize:14.0];
        _goodsNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _goodsNumLabel;
}

-(UILabel *)sizeLabel{
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _sizeLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _sizeLabel;
}

-(UILabel *)subTotalLabel{
    if (!_subTotalLabel) {
        _subTotalLabel = [[UILabel alloc] init];
        _subTotalLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _subTotalLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _subTotalLabel;
}

-(UIButton *)productButton{
    if (!_productButton) {
        _productButton = [[BigClickAreaButton alloc]init];
        _productButton.clickAreaRadious = 60;
        _productButton.layer.cornerRadius = 4.0;
        _productButton.layer.borderWidth = 0.5;
        _productButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _productButton;
}


- (void)clickReview:(UIButton*)sender {
    switch (sender.tag) {
        case WriteReview:
        {
            if (self.reviewBlock) {
                self.reviewBlock(sender.tag);
            }
        }
            break;
        case CheckReview:
        {
            if (self.reviewBlock) {
                self.reviewBlock(sender.tag);
            }
        }
            break;
        default:
            break;
    }
}


@end

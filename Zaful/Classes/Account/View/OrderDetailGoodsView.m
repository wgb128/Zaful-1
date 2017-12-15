//
//  OrderDetailGoodsView.m
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailGoodsView.h"
#import "OrderDetailGoodModel.h"
#import "ZFMultiAttributeInfoView.h"

@interface OrderDetailGoodsView ()
@property (nonatomic, strong) UIView *hLineViewOne;
@property (nonatomic, strong) YYAnimatedImageView *goodImg;
@property (nonatomic, strong) UILabel *goodName;
@property (nonatomic, strong) UILabel *goodSKULabel;
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *goodsNumLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) ZFMultiAttributeInfoView      *attrView;
@property (nonatomic, strong) UILabel *subTotalLabel;
@property (nonatomic, strong) UIView *reviewView;

@property (nonatomic, strong) MASConstraint *reviewConstraint;
@property (nonatomic, strong) BigClickAreaButton *productButton;  //评论按钮

@end

@implementation OrderDetailGoodsView
{
    CGFloat _padding;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:CGRectZero]) {
    
        self.hLineViewOne = [[UIView alloc] init];
        self.hLineViewOne.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
        
        [self addSubview:self.hLineViewOne];
        [self.hLineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(MIN_PIXEL);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(@(MIN_PIXEL));
        }];
        
        self.goodImg = [[YYAnimatedImageView alloc] init];
        self.goodImg.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.goodImg];
        [self.goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(12);
            make.top.mas_equalTo(self.hLineViewOne.mas_bottom).offset(12);
            make.width.mas_equalTo(@100);
            make.height.mas_equalTo(@(150));
        }];
        
        self.goodName = [[UILabel alloc] init];
        self.goodName.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.goodName.numberOfLines = 2;
        self.goodName.font = [UIFont systemFontOfSize:14];

        [self addSubview:self.goodName];
        [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodImg.mas_trailing).offset(10);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.goodImg.mas_top);
        }];
        
        self.goodSKULabel = [[UILabel alloc] init];
        self.goodSKULabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.goodSKULabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.goodSKULabel];
        [self.goodSKULabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.goodName);
            make.top.mas_equalTo(self.goodName.mas_bottom).offset(4);
            make.height.mas_equalTo(16);
        }];

        self.colorLabel = [[UILabel alloc] init];
        self.colorLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.colorLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.colorLabel];
        [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.goodName);
            make.top.mas_equalTo(self.goodSKULabel.mas_bottom).offset(4);
            make.height.mas_equalTo(16);
        }];
        
        self.sizeLabel = [[UILabel alloc] init];
        self.sizeLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.sizeLabel.font = [UIFont systemFontOfSize:14];

        [self addSubview:self.sizeLabel];
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.goodName);
            make.top.mas_equalTo(self.colorLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(16);
        }];
        
        self.attrView = [[ZFMultiAttributeInfoView alloc] init];
        [self addSubview:self.attrView];
        [self.attrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.goodName);
            make.top.mas_equalTo(self.sizeLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(0);
        }];
        
        self.subTotalLabel = [[UILabel alloc] init];
        self.subTotalLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.subTotalLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:self.subTotalLabel];
        [self.subTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodName.mas_leading);
            make.bottom.mas_equalTo(self.goodImg.mas_bottom);
        }];
        
        self.goodsNumLabel = [[UILabel alloc] init];
        self.goodsNumLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.goodsNumLabel.font = [UIFont systemFontOfSize:14];
        self.goodsNumLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.goodsNumLabel];
        [self.goodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.goodName.mas_trailing);
            make.centerY.mas_equalTo(self.subTotalLabel.mas_centerY);
        }];
        
        self.reviewView = [UIView new];
        [self addSubview:self.reviewView];
        [self.reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.goodImg.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.leading.trailing.mas_equalTo(self);
            self.reviewConstraint = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
            [self.reviewConstraint deactivate];
        }];
        
        self.productButton = [[BigClickAreaButton alloc]init];
        self.productButton.clickAreaRadious = 60;
        self.productButton.layer.cornerRadius = 4.0;
        self.productButton.layer.borderWidth = 0.5;
        self.productButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.productButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.reviewView addSubview:self.productButton];
        [self.productButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
            make.trailing.mas_equalTo(self.reviewView.mas_trailing).offset(-10);
            make.top.mas_equalTo(self.reviewView.mas_top).offset(10);
            make.bottom.mas_equalTo(self.reviewView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

- (void)setGoodsModel:(OrderDetailGoodModel *)goodsModel andOrderStatue:(NSString *)orderStatueValue andViewTag:(NSInteger )viewTag{
    [self.goodImg yy_setImageWithURL:[NSURL URLWithString:goodsModel.wp_image] processorKey:NSStringFromClass([self class]) placeholder:[UIImage imageNamed:@"pro_m"]];
    
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
        
        NSString *priceString;
        if ([goodsModel.order_currency isEqualToString:@"€"]) {
            NSMutableString *string = [NSMutableString stringWithFormat:@"%@", goodsModel.goods_price];
            NSRange range = [string rangeOfString:@"."];
            [string replaceCharactersInRange:range withString:@","];
            NSString *price = string;
            priceString = [NSString stringWithFormat:@"%@: %@ %@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Total",nil),price,goodsModel.order_currency];
        }else{
            priceString = [NSString stringWithFormat:@"%@: %@%@",ZFLocalizedString(@"OrderDetail_Goods_Cell_Total",nil),goodsModel.order_currency,goodsModel.goods_price];
        }
        
        self.subTotalLabel.text = priceString;
    }
    
    if (goodsModel.multi_attr.count > 0) {
        self.attrView.attrsArray = goodsModel.multi_attr;
        [self.attrView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.goodName);
            make.top.mas_equalTo(self.sizeLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(goodsModel.multi_attr.count * 16);
        }];
    }
    
    CGSize textSize = [self.goodName.text  boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.goodName.font} context:nil].size;
    
    CGFloat goodNameWidth = SCREEN_WIDTH - 12 * 3 - 100;
    
//    if (textSize.width > goodNameWidth) { //text的宽度少于Label的宽度就是为1行,不然为多行
//        _padding = 4;
//    }else{
//        _padding = 4;
//    }
//    
//    [self.goodSKULabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.goodName.mas_bottom).offset(_padding);
//    }];
//    
//    [self.colorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.goodSKULabel.mas_bottom).offset(_padding);
//    }];
//    
//    [self.sizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.colorLabel.mas_bottom).offset(_padding);
//    }];
//    
    self.orderStatue = [orderStatueValue integerValue];
    if (self.orderStatue == OrderStateEnumTypePaid || self.orderStatue == OrderStateEnumTypeProcessing || self.orderStatue == OrderStateEnumTypeShippedOut  || self.orderStatue == OrderStateEnumTypeDelivered  || self.orderStatue == OrderStateEnumTypePartialOrderDispatched ||  self.orderStatue == OrderStateEnumTypeDispatched || self.orderStatue == OrderStateEnumTypePartialOrderShipped) {
        self.productButton.hidden = NO;
        [self.reviewConstraint deactivate];
        
        if (goodsModel.is_review == 0) {
            self.productButton.layer.borderColor = ZFCOLOR(255, 111, 0, 1.0).CGColor;
            [self.productButton setTitleColor:ZFCOLOR(255, 111, 0, 1.0) forState:UIControlStateNormal];
            [self.productButton setTitle:ZFLocalizedString(@"OrderDetail_Goods_Cell_WriteReview",nil) forState:UIControlStateNormal];
        }else {
            self.productButton.layer.borderColor = ZFCOLOR_BLACK.CGColor;
            [self.productButton setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
            [self.productButton setTitle:ZFLocalizedString(@"OrderDetail_Goods_Cell_CheckMyReview",nil) forState:UIControlStateNormal];
        }
        self.productButton.tag = viewTag;
        [self.productButton addTarget:self action:@selector(clickReview:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [self.reviewConstraint activate];
        self.productButton.hidden = YES;
    }
}

- (void)clickReview:(BigClickAreaButton *)sender {
    
    if (self.reviewBlock) {
        self.reviewBlock(sender.tag);
    }
}


@end

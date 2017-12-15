//
//  MyOrdersListCell.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/8.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "MyOrdersListCell.h"
#import "MyOrderGoodListModel.h"
#import "FDStackView.h"
#import "DeliveryShippingView.h"
#import "OrderDetailPaymentView.h"
#import "OrderTrackingInfoView.h"
#import "RemindersApi.h"

@interface MyOrdersListCell ()
@property (nonatomic, strong) UILabel *payStatus;
@property (nonatomic, strong) UIView *vLeftLine;
@property (nonatomic, strong) UILabel *orderSNLabel;
@property (nonatomic, strong) YYAnimatedImageView *rightIcon;
@property (nonatomic, strong) UIView *hLineViewOne;
@property (nonatomic, strong) YYAnimatedImageView *timeIcon;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UIView *hLineViewTwo;
@property (nonatomic, strong) UIButton *goToDetailBtn;
@property (nonatomic, strong) UIScrollView *picturesScrollView;
@property (nonatomic, strong) UIView *imageContrainerView;
@property (nonatomic, strong) FDStackView *stackView;
@property (nonatomic, strong) DeliveryShippingView *deliveryShippingView;
@property (nonatomic, strong) OrderDetailPaymentView *paymentView;
@property (nonatomic, strong) OrderTrackingInfoView   *trackingInfoView;
@end

@implementation MyOrdersListCell

+ (MyOrdersListCell *)ordersListCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[MyOrdersListCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

-(void)prepareForReuse{
    self.payStatus.text = nil;
    self.orderSNLabel.text = nil;
    self.timeLabel.text = nil;
    self.totalPriceLabel.text = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviewsContraint];
    }
    return self;
}

-(void)setOrderModel:(MyOrdersModel *)orderModel{
    
    _orderModel = orderModel;
    
    self.payStatus.text = orderModel.order_status_str;
    
    self.timeLabel.text = orderModel.order_time;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.orderSNLabel.text = [NSString stringWithFormat:@"%@ :%@",orderModel.order_sn,ZFLocalizedString(@"MyOrders_Cell_Order",nil)];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%@: %@%@",ZFLocalizedString(@"MyOrders_Cell_TotalPayable",nil),orderModel.total_fee,orderModel.order_currency];
    } else {
        self.orderSNLabel.text = [NSString stringWithFormat:@"%@: %@",ZFLocalizedString(@"MyOrders_Cell_Order",nil),orderModel.order_sn];
        NSString *priceString;
        if ([orderModel.order_currency isEqualToString:@"€"]) {
            NSMutableString *string = [NSMutableString stringWithFormat:@"%@", orderModel.total_fee];
            NSRange range = [string rangeOfString:@"."];
            [string replaceCharactersInRange:range withString:@","];
            NSString *price = string;
            priceString = [NSString stringWithFormat:@"%@: %@ %@",ZFLocalizedString(@"MyOrders_Cell_TotalPayable",nil),price,orderModel.order_currency];
        }else{
            priceString = [NSString stringWithFormat:@"%@: %@%@",ZFLocalizedString(@"MyOrders_Cell_TotalPayable",nil),orderModel.order_currency,orderModel.total_fee];
        }
        
        self.totalPriceLabel.text = priceString;
    }
    
    
    CGFloat imgWidth = (SCREEN_WIDTH - 12*4)/3;
    
    [self.imageContrainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [obj removeFromSuperview];
    }];
    
    if (![NSArrayUtils isEmptyArray:orderModel.goods]) {
        if (orderModel.goods.count == 1) {
            MyOrderGoodListModel *goodImgListModel = orderModel.goods.firstObject;
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
            comtentImg.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToDetailBtnClick)];
            
            [comtentImg addGestureRecognizer:tap];
            
            [self.imageContrainerView addSubview:comtentImg];
            
            [comtentImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.imageContrainerView.mas_top);
                make.bottom.mas_equalTo(self.imageContrainerView.mas_bottom);
                make.leading.mas_equalTo(self.imageContrainerView.mas_leading).offset(12);
                make.trailing.mas_equalTo(self.imageContrainerView.mas_trailing).offset(-12);
                make.width.mas_equalTo(imgWidth);
                make.height.mas_equalTo(imgWidth * 1.33);
            }];
        } else {
            NSMutableArray *tempArray = [NSMutableArray array];
            
            [orderModel.goods enumerateObjectsUsingBlock:^(MyOrderGoodListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
                comtentImg.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToDetailBtnClick)];
                [comtentImg addGestureRecognizer:tap];
                
                [self.imageContrainerView addSubview:comtentImg];
                [tempArray addObject:comtentImg];
            }];
            
            [tempArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:12 tailSpacing:12];
            [tempArray mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(imgWidth);
                make.height.mas_equalTo(imgWidth * 1.33);
                make.top.mas_equalTo(self.imageContrainerView.mas_top);
                make.bottom.mas_equalTo(self.imageContrainerView.mas_bottom);
            }];
            
        }
    }
    
    
    @autoreleasepool {
        [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.stackView removeArrangedSubview:obj];
            [obj removeFromSuperview];
            obj = nil;
        }];
    }

    NSString *payMethod = self.orderModel.pay_id;
    if ([payMethod isEqualToString:@"boletoBancario"]) {
        [self.paymentView changeName:self.orderModel.pay_status];
    }
    
    if ([orderModel.pay_id isEqualToString:@"Cod"]) {
        [self.stackView removeArrangedSubview:self.paymentView];
        if ([orderModel.order_status integerValue] == 13) { // 13代表失败
            [self.stackView removeArrangedSubview:self.trackingInfoView];
            [self.stackView removeArrangedSubview:self.paymentView];
        }else{
            [self.stackView addArrangedSubview:self.deliveryShippingView];
            [self.stackView addArrangedSubview:self.trackingInfoView];
        }
    }else{
        if ([orderModel.order_status integerValue] == 0) {  // 显示 payNow
            [self.stackView removeArrangedSubview:self.deliveryShippingView];
            [self.stackView removeArrangedSubview:self.trackingInfoView];
            [self.stackView addArrangedSubview:self.paymentView];
        }else if ([orderModel.order_status integerValue] == 11) {  // 不显示
            [self.stackView removeArrangedSubview:self.deliveryShippingView];
            [self.stackView removeArrangedSubview:self.trackingInfoView];
            [self.stackView removeArrangedSubview:self.paymentView];
        }else { // 显示 物流追踪
            [self.stackView removeArrangedSubview:self.deliveryShippingView];
            [self.stackView removeArrangedSubview:self.paymentView];
            [self.stackView addArrangedSubview:self.trackingInfoView];
        }
    }
    
}

- (void)addSubviewsContraint {
    
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    
    [self.contentView addSubview:self.payStatus];
    [self.payStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(25);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.vLeftLine];
    [self.vLeftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.centerY.mas_equalTo(self.payStatus.mas_centerY);
        make.height.mas_equalTo(self.payStatus);
        make.width.mas_equalTo(@3);
    }];
    
    [self.contentView addSubview:self.orderSNLabel];
    [self.orderSNLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.payStatus.mas_leading);
        make.top.mas_equalTo(self.payStatus.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.rightIcon];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
        make.bottom.mas_equalTo(self.orderSNLabel.mas_top).offset(-10);
        make.width.mas_equalTo(@6);
    }];
    
    [self.contentView addSubview:self.hLineViewOne];
    [self.hLineViewOne mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.orderSNLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(@(MIN_PIXEL));
    }];
    
    [self.contentView addSubview:self.picturesScrollView];
    [self.picturesScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hLineViewOne.mas_bottom).offset(12);
        make.leading.trailing.mas_equalTo(self.contentView);
    }];
    
    [self.picturesScrollView addSubview:self.imageContrainerView];
    [self.imageContrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.picturesScrollView).insets(UIEdgeInsetsZero);
        make.centerY.mas_equalTo(self.picturesScrollView.mas_centerY);
        make.height.equalTo(self.picturesScrollView);
        
    }];
    
    [self.contentView addSubview:self.timeIcon];
    [self.timeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.picturesScrollView.mas_bottom).offset(16);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.size.mas_equalTo(@16);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeIcon);
        make.leading.mas_equalTo(self.timeIcon.mas_trailing).offset(5);
    }];
    
    [self.contentView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(16);//(12 + SCREEN_WIDTH - 12*3)/3 * 1.7
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
    }];
    
    [self.contentView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalPriceLabel.mas_bottom).offset(15);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        
    }];
    
    [self.stackView addSubview:self.hLineViewTwo];
    [self.hLineViewTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stackView.mas_top);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@(MIN_PIXEL));
    }];
    
    self.deliveryShippingView = [[DeliveryShippingView alloc] init];
    [self.stackView addArrangedSubview:self.deliveryShippingView];
    
    self.paymentView = [[OrderDetailPaymentView alloc] initWithPaymentStatus:YES];
    [self.stackView addArrangedSubview:self.paymentView];
    
    @weakify(self)
    self.paymentView.orderDetailPayStatueBlock = ^(NSInteger tag){
        @strongify(self)
        if (self.paymentBlock) {
            self.paymentBlock();
        }
    };
    
    self.trackingInfoView = [[OrderTrackingInfoView alloc] init];
    [self.stackView addArrangedSubview:self.trackingInfoView];
    
    self.trackingInfoView.orderTrackingInfoBlock = ^ {
        @strongify(self)
        if (self.trackingBlock) {
            self.trackingBlock(self.orderModel);
        }
    };
    
    
    /**
     *  进入订单详情页面的按钮
     */
    [self.contentView addSubview:self.goToDetailBtn];
    [self.goToDetailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.hLineViewOne);
    }];
    
    [self.totalPriceLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.totalPriceLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)goToDetailBtnClick {
    if (self.detailBlock) {
        self.detailBlock();
    }
}

#pragma mark - 懒加载
-(UILabel *)payStatus{
    if (!_payStatus) {
        _payStatus = [[UILabel alloc] init];
        _payStatus.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _payStatus.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _payStatus;
}

-(UIView *)vLeftLine{
    if (!_vLeftLine) {
        _vLeftLine = [[UIView alloc] init];
        _vLeftLine.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _vLeftLine;
}

-(UILabel *)orderSNLabel{
    if (!_orderSNLabel) {
        _orderSNLabel = [[UILabel alloc] init];
        _orderSNLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        _orderSNLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _orderSNLabel;
}

-(YYAnimatedImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[YYAnimatedImageView alloc] init];
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            _rightIcon.image = [UIImage imageNamed:@"to_left"];
        } else {
            _rightIcon.image = [UIImage imageNamed:@"to_right"];
        }
    }
    return _rightIcon;
}

-(UIView *)hLineViewOne{
    if (!_hLineViewOne) {
        _hLineViewOne = [[UIView alloc] init];
        _hLineViewOne.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
    }
    return _hLineViewOne;
}

-(YYAnimatedImageView *)timeIcon{
    if (!_timeIcon) {
        _timeIcon = [[YYAnimatedImageView alloc] init];
        _timeIcon.image = [UIImage imageNamed:@"time"];
    }
    return _timeIcon;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _timeLabel;
}

-(UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _totalPriceLabel.font = [UIFont systemFontOfSize:16.0];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalPriceLabel;
}


-(UIView *)hLineViewTwo{
    if (!_hLineViewTwo) {
        _hLineViewTwo = [[UIView alloc] init];
        _hLineViewTwo.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
    }
    return _hLineViewTwo;
}

-(UIButton *)goToDetailBtn{
    if (!_goToDetailBtn) {
        _goToDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goToDetailBtn.backgroundColor = [UIColor clearColor];
        [_goToDetailBtn addTarget:self action:@selector(goToDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goToDetailBtn;
}


- (UIScrollView *)picturesScrollView{
    if (!_picturesScrollView) {
        _picturesScrollView = [[UIScrollView alloc] init];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _picturesScrollView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        _picturesScrollView.showsHorizontalScrollIndicator = NO;
        _picturesScrollView.showsVerticalScrollIndicator = NO;
    }
    return _picturesScrollView;
}

- (UIView *)imageContrainerView {
    if (!_imageContrainerView) {
        _imageContrainerView = [UIView new];
    }
    return _imageContrainerView;
}

- (FDStackView *)stackView {
    if (!_stackView) {
        _stackView = [[FDStackView alloc] init];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.alignment = UIStackViewAlignmentFill;
    }
    return _stackView;
}

@end

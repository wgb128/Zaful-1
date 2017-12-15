//
//  CartInfoPaymentCell.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoPaymentCell.h"
#import "CartInfoPaymentView.h"
#import "FDStackView.h"

@interface CartInfoPaymentCell ()<RadioButtonDelegate>
@property (nonatomic, strong) FDStackView *stackView;
@end

@implementation CartInfoPaymentCell

+ (CartInfoPaymentCell *)paymentCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoPaymentCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    @autoreleasepool {
        [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.stackView removeArrangedSubview:obj];
            [obj removeFromSuperview];
            obj = nil;
        }];
    }
}

-(void)setPaymentListAry:(NSArray *)paymentListAry {
    _paymentListAry = paymentListAry;
    [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.stackView removeArrangedSubview:obj];
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    [paymentListAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CartInfoPaymentView *view = [[CartInfoPaymentView alloc] initWithFrame:CGRectZero index:idx];
        view.model = obj;
        [self.stackView addArrangedSubview:view];
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.stackView = [[FDStackView alloc] init];
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionFill;
        self.stackView.alignment = UIStackViewAlignmentFill;
        self.stackView.spacing = 10.f;
        
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
        
        [RadioButton addObserverForGroupId:@"payment" observer:self];
    }
    return self;
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    if ([groupId isEqualToString:@"payment"]) {
        self.selectedTouchBlock(self.paymentListAry[index]);
    }
}



@end

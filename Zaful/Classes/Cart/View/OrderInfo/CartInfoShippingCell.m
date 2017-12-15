//
//  CartInfoShippingCell.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoShippingCell.h"
#import "CartInfoShippingView.h"
#import "FDStackView.h"
#import "FilterManager.h"
#import "ShippingListModel.h"

@interface CartInfoShippingCell ()<RadioButtonDelegate>
@property (nonatomic, strong) FDStackView *stackView;
@end

@implementation CartInfoShippingCell

+ (CartInfoShippingCell *)shippingCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoShippingCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
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

- (void)setShippingListAry:(NSArray *)shippingListAry {
    _shippingListAry = shippingListAry;
    
    [shippingListAry enumerateObjectsUsingBlock:^(ShippingListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([FilterManager tempCOD]) {
            if ([obj.is_cod_ship boolValue]) {
                CartInfoShippingView *view = [[CartInfoShippingView alloc] initWithFrame:CGRectZero index:idx];
                view.model = obj;
                [self.stackView addArrangedSubview:view];
            }
        }else if (![obj.is_cod_ship boolValue]) {
            CartInfoShippingView *view = [[CartInfoShippingView alloc] initWithFrame:CGRectZero index:idx];
            view.model = obj;
            [self.stackView addArrangedSubview:view];
        }
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
        
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
        
        [RadioButton addObserverForGroupId:@"shipping" observer:self];

    }
    return self;
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    if ([groupId isEqualToString:@"shipping"]) {
        
        [self.shippingListAry setValue:@(NO) forKeyPath:@"default_select"];
         ShippingListModel *listModel = self.shippingListAry[index];
        listModel.default_select = @"1";

        self.selectedTouchBlock(listModel);
    }
}


@end

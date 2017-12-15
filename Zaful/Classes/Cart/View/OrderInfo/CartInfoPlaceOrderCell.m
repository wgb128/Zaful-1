//
//  CartInfoPlaceOrderCell.m
//  Zaful
//
//  Created by zhaowei on 2017/6/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CartInfoPlaceOrderCell.h"

@interface CartInfoPlaceOrderCell ()
@property (nonatomic, strong) UIButton *placeOrderBtn;
@end

@implementation CartInfoPlaceOrderCell

+ (CartInfoPlaceOrderCell *)placeOrderCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoPlaceOrderCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.placeOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.placeOrderBtn setTitle:ZFLocalizedString(@"CartOrderInformationBottomView_PlaceOrderBtn",nil) forState:UIControlStateNormal];
        [self.placeOrderBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        self.placeOrderBtn.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        self.placeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.placeOrderBtn addTarget:self action:@selector(placeOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.placeOrderBtn];
        [self.placeOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(49);
        }];
    }
    return self;
}

#pragma mark - Target Action
- (void)placeOrderBtnClick {
    if (self.placeOrderBlock) {
        self.placeOrderBlock();
    }
}



@end

//
//  ZFTrackingListHeaderView.m
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTrackingListHeaderView.h"
#import "ZFInitViewProtocol.h"
#import "ZFTrackingPackageModel.h"

@interface ZFTrackingListHeaderView ()<ZFInitViewProtocol>
@property (nonatomic, strong) UILabel   *shipNameLabel;
@property (nonatomic, strong) UILabel   *trackingNumLabel;
@property (nonatomic, strong) UIView    *line;
@end

@implementation ZFTrackingListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, KScreenWidth, 60);
        [self zfInitView];
        [self zfAutoLayoutView];
        
    }
    return self;
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    [self addSubview:self.shipNameLabel];
    [self addSubview:self.trackingNumLabel];
    [self addSubview:self.line];
}

- (void)zfAutoLayoutView {
    [self.shipNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(24);
        make.top.equalTo(self).offset(8);
        
    }];
    
    [self.trackingNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shipNameLabel.mas_leading);
        make.top.equalTo(self.shipNameLabel.mas_bottom).offset(1);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Setter
- (void)setModel:(ZFTrackingPackageModel *)model {
    _model = model;
    self.shipNameLabel.text = model.shipping_name;
    self.trackingNumLabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"ZFTracking_number", nil),model.shipping_no];
}

#pragma mark - Getter
- (UILabel *)shipNameLabel {
    if (!_shipNameLabel) {
        _shipNameLabel = [[UILabel alloc] init];
        _shipNameLabel.font = [UIFont systemFontOfSize:16.0];
        _shipNameLabel.textColor = ZFCOLOR(183, 96, 42, 1);
    }
    return _shipNameLabel;
}

- (UILabel *)trackingNumLabel {
    if (!_trackingNumLabel) {
        _trackingNumLabel = [[UILabel alloc] init];
        _trackingNumLabel.font = [UIFont systemFontOfSize:14];
        _trackingNumLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _trackingNumLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = ZFCOLOR(221, 221, 221, 1);
    }
    return _line;
}


@end

//
//  ZFTrackingListContentView.m
//  Zaful
//
//  Created by TsangFa on 6/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTrackingListContentView.h"
#import "ZFInitViewProtocol.h"
#import "ZFTrackingListModel.h"

static CGFloat const kLeftSpace = 68;

@interface ZFTrackingListContentView ()<ZFInitViewProtocol>
@property (nonatomic, strong) UILabel   *detailLabel;
@property (nonatomic, strong) UILabel   *timeLabel;
@property (nonatomic, strong) UIView    *line;
@end

@implementation ZFTrackingListContentView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    
    return self;
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    [self addSubview:self.detailLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.line];
}

- (void)zfAutoLayoutView {
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(68);
        make.top.equalTo(self).offset(20);
        make.trailing.equalTo(self).offset(-16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.detailLabel);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.detailLabel);
        make.trailing.equalTo(self).offset(-16);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self);
    }];
}

- (void)reloadDataWithModel:(ZFTrackingListModel* )model {
    self.detailLabel.text = model.status;
    self.timeLabel.text = model.ondate;
    [self setNeedsDisplay];
}

- (void)setCurrented:(BOOL)currented {
    _currented = currented;
    if (currented) {
        self.detailLabel.textColor = ZFCOLOR(183, 96, 42, 1);
        self.timeLabel.textColor = ZFCOLOR(183, 96, 42, 1);
    } else {
        self.detailLabel.textColor = ZFCOLOR(153, 153, 153, 1);
        self.timeLabel.textColor = ZFCOLOR(153, 153, 153, 1);
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat height = self.bounds.size.height;
    CGFloat cicleWith = self.currented ? 12 : 6;
    
    if (self.hasUpLine) {
        UIBezierPath *topBezier = [UIBezierPath bezierPath];
        
        CGFloat movePointX  = [SystemConfigUtils isRightToLeftShow] ? KScreenWidth - (kLeftSpace/2) : kLeftSpace / 2;
        
        [topBezier moveToPoint:CGPointMake(movePointX, 0)];
        [topBezier addLineToPoint:CGPointMake(movePointX, height / 2 - cicleWith / 2 - cicleWith / 6)];
        
        topBezier.lineWidth = 1.0;
        UIColor *stroke = ZFCOLOR(221, 221, 221, 1);
        [stroke set];
        [topBezier stroke];
    }
    
    if (self.currented) {
        
        CGFloat movePointX  = [SystemConfigUtils isRightToLeftShow] ? KScreenWidth - (kLeftSpace / 2 - cicleWith / 2 + cicleWith) : kLeftSpace / 2 - cicleWith / 2;
        
        UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(movePointX, height / 2 - cicleWith / 2, cicleWith, cicleWith)];
        
        cicle.lineWidth = cicleWith / 3;
        UIColor *cColor = ZFCOLOR(183, 96, 42, 1);
        [cColor set];
        [cicle fill];
        
        UIColor *shadowColor = ZFCOLOR(183, 96, 42, 0.5);
        [shadowColor set];
        
        
        [cicle stroke];
    } else {
        CGFloat movePointX  = [SystemConfigUtils isRightToLeftShow] ? KScreenWidth - (kLeftSpace/2.0 - cicleWith/2.0 + cicleWith) : kLeftSpace/2.0 - cicleWith/2.0;
        UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(movePointX, height/2.0 - cicleWith/2.0, cicleWith, cicleWith)];
        
        UIColor *cColor = ZFCOLOR(221, 221, 221, 1);
        [cColor set];
        [cicle fill];
        
        [cicle stroke];
    }
    
    if (self.hasDownLine) {
        UIBezierPath *downBezier = [UIBezierPath bezierPath];
         CGFloat movePointX  = [SystemConfigUtils isRightToLeftShow] ? KScreenWidth - (kLeftSpace/2) : kLeftSpace / 2;
        [downBezier moveToPoint:CGPointMake(movePointX, height / 2 + cicleWith / 2 + cicleWith / 6)];
        [downBezier addLineToPoint:CGPointMake(movePointX, height)];
        
        downBezier.lineWidth = 1.0;
        UIColor *stroke = ZFCOLOR(221, 221, 221, 1);
        [stroke set];
        [downBezier stroke];
    }
}

#pragma mark - Getter
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14.0];
        _detailLabel.textColor = ZFCOLOR(183, 96, 42, 1);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        _detailLabel.preferredMaxLayoutWidth = KScreenWidth - 84;
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        _timeLabel.textColor = ZFCOLOR(183, 96, 42, 1);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = ZFCOLOR(221, 221, 221, 1);
    }
    return _line;
}

@end

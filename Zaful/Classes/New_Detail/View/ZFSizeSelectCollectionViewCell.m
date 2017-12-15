//
//  ZFSizeSelectCollectionViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFSizeSelectCollectionViewCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFSizeSelectCollectionViewCell() <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *attrLabel;
@end

@implementation ZFSizeSelectCollectionViewCell
- (void)prepareForReuse {
    self.attrLabel.text = nil;
}

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.attrLabel];
}

- (void)zfAutoLayoutView {
    [self.attrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
    
    self.attrLabel.layer.cornerRadius = 22;
}

#pragma mark - setter
- (void)setModel:(ZFSizeSelectItemsModel *)model {
    _model = model;
    self.attrLabel.backgroundColor = ZFCOLOR_WHITE;
    self.attrLabel.text = model.attrName;

    if (_model.is_click) {
        self.attrLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        if (_model.isSelect) {
            self.attrLabel.layer.borderColor = ZFCOLOR(51, 51, 51, 1.f).CGColor;
        } else {
            self.attrLabel.layer.borderColor = ZFCOLOR(221, 221, 221, 1.f).CGColor;
        }
    } else {
        self.attrLabel.layer.borderColor = ZFCOLOR(247, 247, 247, 1.f).CGColor;
        self.attrLabel.textColor = ZFCOLOR(221, 221, 221, 1.f);
    }
}

#pragma mark - getter
- (UILabel *)attrLabel {
    if (!_attrLabel) {
        _attrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _attrLabel.font = [UIFont systemFontOfSize:16];
        _attrLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _attrLabel.textAlignment = NSTextAlignmentCenter;
        _attrLabel.clipsToBounds = YES;
        _attrLabel.layer.borderColor = ZFCOLOR(51, 51, 51, 1.f).CGColor;
        _attrLabel.layer.borderWidth = 1.f;
    }
    return _attrLabel;
}

@end

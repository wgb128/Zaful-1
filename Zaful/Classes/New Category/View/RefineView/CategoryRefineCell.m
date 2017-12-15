//
//  CategoryRefineCell.m
//  ListPageViewController
//
//  Created by TsangFa on 3/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryRefineCell.h"
#import "CategoryRefineCellModel.h"

@interface CategoryRefineCell ()
@property (nonatomic,strong)  YYLabel           *titleLabel;
@property (nonatomic,strong)  YYLightView       *arrowImgView;
@property (nonatomic,strong)  CALayer           *line;

@end

@implementation CategoryRefineCell
#pragma mark - Init Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}

#pragma mark - Initialize
- (void)configureSubViews {
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.layer addSublayer:self.line];
}

- (void)autoLayoutSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(24);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
        make.size.mas_equalTo(CGSizeMake(15, 10));
    }];
    
    self.line.frame = CGRectMake(0, 44 - KLineHeight, KScreenWidth - 75, KLineHeight);
}

#pragma mark - Setter
- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.arrowImgView.image = isSelect ? [UIImage imageNamed:@"refine_select"] : nil;
    
    [self setNeedsDisplay];
}


#pragma mark - Public Methods
+ (NSString *)setIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - Rewrite Methods
-(void)prepareForReuse {
    self.titleLabel.text = @"";
    self.arrowImgView.image = nil;
}

#pragma mark - Getter
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [YYLabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = ZFCOLOR(153, 153, 153, 1);
        _titleLabel.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    }
    return _titleLabel;
}


- (YYLightView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[YYLightView alloc] init];
    }
    return _arrowImgView;
}


- (CALayer *)line {
    if (!_line) {
        _line = [CALayer layer];
        _line.backgroundColor = ZFCOLOR(221, 221, 221, 1).CGColor;
    }
    return _line;
}


@end
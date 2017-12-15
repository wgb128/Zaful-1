//
//  CategorySortSectionView.m
//  ListPageViewController
//
//  Created by TsangFa on 6/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategorySortSectionView.h"

@interface CategorySortSectionView ()
@property (nonatomic, strong)  YYLabel          *titleLabel;
@property (nonatomic, strong)  YYLightView      *arrowImgView;
@property (nonatomic, strong)  CALayer          *line;
@end

@implementation CategorySortSectionView
#pragma mark - Init Method
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubViews];
        [self autoLayoutSubViews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandPropertyTouch)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Initialize
- (void)configureSubViews {
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.layer addSublayer:self.line];
}

- (void)autoLayoutSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-20);
        make.size.mas_equalTo(CGSizeMake(15, 10));
    }];
    
    self.line.frame = CGRectMake(0, 44 - KLineHeight, KScreenWidth, KLineHeight);
}

#pragma mark - Gesture Handle
- (void)expandPropertyTouch {
    self.isSelect = !self.isSelect;
    
    if (self.categorySortSectionViewTouchHandler) {
        self.categorySortSectionViewTouchHandler(self.sortType,self.isSelect);
    }
}

#pragma mark - Setter
- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.arrowImgView.image = isSelect ? [UIImage imageNamed:@"refine_select"] : nil;
}

- (void)setSortType:(NSString *)sortType {
    _sortType = sortType;
    self.titleLabel.text = sortType;
}

#pragma mark - Rewrite Methods
-(void)prepareForReuse {
    self.titleLabel.text = @"";
    self.arrowImgView.image = nil;
}

#pragma mark - Public Methods
+ (NSString *)setIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - Getter
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [YYLabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1);
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

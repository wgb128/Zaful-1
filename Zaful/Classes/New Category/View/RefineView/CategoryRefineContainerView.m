//
//  CategoryRefineView.m
//  ListPageViewController
//
//  Created by TsangFa on 29/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryRefineContainerView.h"
#import "CategoryRefineInfoView.h"

static NSString *const khideRefineInfoViewAnimationIdentifier = @"khideRefineInfoViewAnimationIdentifier";
static NSString *const kshowRefineInfoViewAnimationIdentifier = @"kshowRefineInfoViewAnimationIdentifier";

@interface CategoryRefineContainerView ()<CAAnimationDelegate>
@property (nonatomic, strong) UIView                    *maskView;
@property (nonatomic, strong) CategoryRefineInfoView    *refineInfoView;
@property (nonatomic, strong) CABasicAnimation          *showRefineInfoViewAnimation;
@property (nonatomic, strong) CABasicAnimation          *hideRefineInfoViewAnimation;
@end

@implementation CategoryRefineContainerView
#pragma mark - Init Method
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}

#pragma mark - Initialize
- (void)configureSubViews {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    [self addSubview:self.maskView];
    [self addSubview:self.refineInfoView];
}

- (void)autoLayoutSubViews {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.width.mas_equalTo(75);
    }];
    
    [self.refineInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 75, 0, 0));
    }];
}

#pragma mark - Setter
-(void)setModel:(CategoryRefineSectionModel *)model {
    _model = model;
    self.refineInfoView.model = model;
}

#pragma mark - Public Methods
- (void)showRefineInfoViewWithAnimation:(BOOL)animation {
    if (!animation) {
        return ;
    }
    self.refineInfoView.hidden = NO;

    [self.refineInfoView.layer addAnimation:self.showRefineInfoViewAnimation forKey:kshowRefineInfoViewAnimationIdentifier];

}

- (void)hideRefineInfoViewViewWithAnimation:(BOOL)animation {
    if (!animation) {
        return ;
    }
    [self.refineInfoView.layer addAnimation:self.hideRefineInfoViewAnimation forKey:khideRefineInfoViewAnimationIdentifier];
}

- (void)clearRefineInfoViewData {
    [self.refineInfoView clearRequestParmaters];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.hideRefineViewCompletionHandler) {
        self.refineInfoView.hidden = YES;
        self.hideRefineViewCompletionHandler();
    }
}

#pragma mark - Gesture Handle
- (void)hideRefineView {
    [self hideRefineInfoViewViewWithAnimation:YES];
}

#pragma mark - Getter
-(UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRefineView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (CategoryRefineInfoView *)refineInfoView {
    if (!_refineInfoView) {
        _refineInfoView = [[CategoryRefineInfoView alloc] init];
        _refineInfoView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
        _refineInfoView.hidden = NO;
        @weakify(self)
        _refineInfoView.applyRefineSelectInfoCompletionHandler = ^(NSDictionary *parms) {
            @strongify(self);
            if (self.applyRefineContainerViewInfoCompletionHandler) {
                self.applyRefineContainerViewInfoCompletionHandler(parms);
            }
        };
    }
    return _refineInfoView;
}

- (CABasicAnimation *)showRefineInfoViewAnimation {
    if (!_showRefineInfoViewAnimation) {
        _showRefineInfoViewAnimation = [CABasicAnimation animation];
        _showRefineInfoViewAnimation.keyPath = @"position.x";
        _showRefineInfoViewAnimation.fromValue = [SystemConfigUtils isRightToLeftShow] ? @(-KScreenWidth * 0.5) : @(KScreenWidth * 1.5);
        _showRefineInfoViewAnimation.toValue = [SystemConfigUtils isRightToLeftShow] ?  @((KScreenWidth-75) / 2) : @((KScreenWidth-75) / 2 + 75);
        _showRefineInfoViewAnimation.duration = 0.25f;
        _showRefineInfoViewAnimation.removedOnCompletion = NO;
        _showRefineInfoViewAnimation.fillMode = kCAFillModeForwards;
    }
    return _showRefineInfoViewAnimation;
}

- (CABasicAnimation *)hideRefineInfoViewAnimation {
    if (!_hideRefineInfoViewAnimation) {
        _hideRefineInfoViewAnimation = [CABasicAnimation animation];
        _hideRefineInfoViewAnimation.keyPath = @"position.x";
        _hideRefineInfoViewAnimation.fromValue = [SystemConfigUtils isRightToLeftShow] ? @((KScreenWidth-75) / 2) : @((KScreenWidth-75) / 2 + 75);
        _hideRefineInfoViewAnimation.toValue = [SystemConfigUtils isRightToLeftShow] ? @(-KScreenWidth * 0.5) : @(KScreenWidth * 1.5);
        _hideRefineInfoViewAnimation.duration = 0.25f;
        _hideRefineInfoViewAnimation.removedOnCompletion = NO;
        _hideRefineInfoViewAnimation.fillMode = kCAFillModeForwards;
        _hideRefineInfoViewAnimation.delegate = self;
    }
    return _hideRefineInfoViewAnimation;
}



@end

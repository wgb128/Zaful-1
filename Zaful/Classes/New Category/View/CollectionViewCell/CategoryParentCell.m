//
//  ParentCell.m
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryParentCell.h"

@interface CategoryParentCell ()
@property (nonatomic, strong) YYLightView   *categoryImgView;
@end

@implementation CategoryParentCell
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
-(void)configureSubViews {
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.categoryImgView];
}

-(void)autoLayoutSubViews {
    [self.categoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = (KScreenWidth - 12 - 12 - 7) / 2;
        CGFloat height = 120 * SCREEN_WIDTH_SCALE;
        make.top.leading.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(width,height));
    }];
}

#pragma mark - Setter
-(void)setModel:(CategoryNewModel *)model {
    _model = model;
    
    [self.categoryImgView.layer removeAnimationForKey:@"contents"];

    [self.categoryImgView.layer yy_setImageWithURL:[NSURL URLWithString:model.cat_pic]
                                      processorKey:NSStringFromClass([self class])
                                       placeholder:[UIImage imageNamed:@"category1"]
                                           options:YYWebImageOptionAvoidSetImage
                                        completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                            if (image && stage == YYWebImageStageFinished) {
                                                self.categoryImgView.image = image;
                                                if (from != YYWebImageFromMemoryCacheFast) {
                                                    CATransition *transition = [CATransition animation];
                                                    transition.duration = 0.25;
                                                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                                    transition.type = kCATransitionFade;
                                                    [self.categoryImgView.layer addAnimation:transition forKey:@"contents"];
                                                }
                                            }
                                            
                                        }];
}

#pragma mark - Public Methods
+ (NSString *)setIdentifier {
    return @"ParentCell_identifier";
}

#pragma mark - Rewrite Methods
-(void)prepareForReuse {
    [self.categoryImgView.layer yy_cancelCurrentImageRequest];
    self.categoryImgView.image = nil;
}

#pragma mark - Getter
-(YYLightView *)categoryImgView {
    if (!_categoryImgView) {
        _categoryImgView = [[YYLightView alloc] init];
        _categoryImgView.userInteractionEnabled = YES;
        _categoryImgView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
        _categoryImgView.clipsToBounds = YES;
    }
    return _categoryImgView;
}
@end

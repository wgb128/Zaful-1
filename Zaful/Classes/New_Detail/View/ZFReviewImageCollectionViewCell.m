
//
//  ZFReviewImageCollectionViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/11/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFReviewImageCollectionViewCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFReviewImageCollectionViewCell() <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView       *imageView;
@end

@implementation ZFReviewImageCollectionViewCell
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
    [self.contentView addSubview:self.imageView];
}

- (void)zfAutoLayoutView {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setUrl:(NSString *)url {
    _url = url;
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:_url]
                     processorKey:NSStringFromClass([self class])
                      placeholder:[UIImage imageNamed:@"loading_cat_list"]
                          options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                         progress:nil
                        transform:nil
                       completion:nil];
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

@end

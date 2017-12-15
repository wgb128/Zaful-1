//
//  ZFCommunityDetailReviewsCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailReviewsCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityDetailReviewsModel.h"

@interface ZFCommunityDetailReviewsCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView       *userImageView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *contentLabel;
@property (nonatomic, strong) UILabel           *replyLabel;

@end

@implementation ZFCommunityDetailReviewsCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.replyLabel];
}

- (void)zfAutoLayoutView {
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userImageView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.userImageView.mas_top);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
        make.top.mas_equalTo(self.userImageView.mas_bottom).offset(-15);
    }];
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userImageView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
        make.top.mas_equalTo(self.contentLabel.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    
}

#pragma mark - setter
- (void)setModel:(ZFCommunityDetailReviewsModel *)model {
    _model = model;
    //头像
    [self.userImageView yy_setImageWithURL:[NSURL URLWithString:_model.avatar]
                        processorKey:NSStringFromClass([self class])
                         placeholder:[UIImage imageNamed:@"account"]
                             options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                           transform:^UIImage *(UIImage *image, NSURL *url) {
                               image = [image yy_imageByResizeToSize:CGSizeMake(40,40) contentMode:UIViewContentModeScaleToFill];
                               return [image yy_imageByRoundCornerRadius:20];
                           }
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                          }];
    
    //昵称
    self.nameLabel.text = _model.nickname;
    
    //评论内容
    if (![NSStringUtils isEmptyString:_model.isSecondFloorReply]) {
        if ([_model.isSecondFloorReply isEqualToString:@"1"]) {
            self.contentLabel.text = nil;
            NSMutableAttributedString *mutableAttribuedString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Re %@ : %@",_model.replyNickName,_model.content]];
            NSRange range = NSMakeRange(0, _model.replyNickName.length + 5);
            [mutableAttribuedString addAttribute:NSForegroundColorAttributeName value:ZFCOLOR(51, 51, 51, 1.0) range:range];
            [mutableAttribuedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:range];
            self.replyLabel.attributedText = mutableAttribuedString;
        }else {
            self.replyLabel.text = nil;
            self.contentLabel.text = _model.content;
        }
    }

}

#pragma mark - getter
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userImageView.userInteractionEnabled = YES;
        _userImageView.contentMode = UIViewContentModeScaleToFill;
        _userImageView.userInteractionEnabled = YES;
    }
    return _userImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
    }
    return _contentLabel;
}

- (UILabel *)replyLabel {
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLabel.userInteractionEnabled = YES;
        _replyLabel.numberOfLines = 0;
        _replyLabel.font = [UIFont systemFontOfSize:12];
        _replyLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);

    }
    return _replyLabel;
}
@end

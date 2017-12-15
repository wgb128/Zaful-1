//
//  PostRecentCell.m
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "PostRecentCell.h"

@interface PostRecentCell()
@property (nonatomic,strong) YYAnimatedImageView *imgView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *priceLable;
@property (nonatomic,strong) BigClickAreaButton *selectButton;
@end

@implementation PostRecentCell

+ (PostRecentCell *)postRecentCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[PostRecentCell class] forCellReuseIdentifier:NSStringFromClass([PostRecentCell class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PostRecentCell class]) forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imgView = [[YYAnimatedImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        _selectButton = [[BigClickAreaButton alloc] init];
        _selectButton.clickAreaRadious = 60;
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
         [_selectButton setBackgroundImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectGoods:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView).offset(-38);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        _titleLable = [UILabel new];
        _titleLable.textColor = ZFCOLOR(102, 102, 102, 1);
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.numberOfLines = 2;
        _titleLable.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLable];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView.mas_top).offset(2);
            make.leading.equalTo(_imgView.mas_trailing).offset(12);
            make.trailing.equalTo(_selectButton.mas_leading).offset(-40);
        }];
        
        _priceLable = [UILabel new];
        _priceLable.textColor = ZFCOLOR(51, 51, 51, 1);
        _priceLable.font = [UIFont systemFontOfSize:18];
        _priceLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLable];
        [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imgView.mas_bottom).offset(-2);
            make.leading.equalTo(_imgView.mas_trailing).offset(12);
            make.trailing.equalTo(_selectButton.mas_leading).offset(-40);
        }];
    }
    return self;
}

- (void)selectGoods:(UIButton *)sender {
    if (self.recentSelectBlock) {
        self.recentSelectBlock(sender);
    }
}

- (void)setGoodsListModel:(CommendModel *)goodsListModel {
    _goodsListModel = goodsListModel;
    
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:goodsListModel.goodsThumb] processorKey:NSStringFromClass([self class]) placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        //CGFloat height = 80;
        //image = [image yy_imageByResizeToSize:CGSizeMake(height,height * DSCREEN_WIDTH_SCALE) contentMode:UIViewContentModeScaleAspectFill];
        return image;
    } completion:nil];
    
    NSString *shopPrice = [ExchangeManager transforPrice:goodsListModel.goodsPrice];
    self.priceLable.text = shopPrice;
    self.titleLable.text = goodsListModel.goodsName;
    
    self.selectButton.selected = goodsListModel.isSelected;
}

- (void)prepareForReuse {
    [self.imgView yy_cancelCurrentImageRequest];
    self.imgView.image = nil;
    self.priceLable.text = nil;
    self.titleLable.text = nil;
    self.selectButton.selected = NO;
}

@end

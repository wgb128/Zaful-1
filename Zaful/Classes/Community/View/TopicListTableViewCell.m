//
//  TopicListTableViewCell.m
//  Zaful
//
//  Created by DBP on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicListTableViewCell.h"

@interface TopicListTableViewCell ()
@property (nonatomic, strong) YYAnimatedImageView *topicImageView;
@property (nonatomic, strong) UILabel *topicNumberLabel;
@property (nonatomic, strong) UIView *topicView;
@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TopicListTableViewCell

+ (TopicListTableViewCell *)topicListTableViewCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[TopicListTableViewCell class] forCellReuseIdentifier:TOPIC_LIST_CELL_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:TOPIC_LIST_CELL_IDENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        __weak typeof(self.contentView) ws = self.contentView;
        
        YYAnimatedImageView *topicImageView = [YYAnimatedImageView new];
        topicImageView.contentMode = UIViewContentModeScaleAspectFill;
        topicImageView.clipsToBounds = YES;
        [ws addSubview:topicImageView];
        
        [topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(ws);
            make.height.mas_equalTo(210 *DSCREEN_WIDTH_SCALE);
        }];
        self.topicImageView = topicImageView;
        
        UIView *topicView = [UIView new];
        topicView.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [ws addSubview:topicView];
        
        [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topicImageView.mas_bottom).offset(12);
            make.leading.mas_equalTo(ws);
            make.height.mas_equalTo(@16);
            make.width.mas_equalTo(@3);
        }];
        
        UILabel *topicTitleLabel = [UILabel new];
        topicTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        topicTitleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [ws addSubview:topicTitleLabel];
        
        [topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(topicView.mas_trailing).offset(10);
            make.trailing.mas_equalTo(ws.mas_trailing).offset(-100);
            make.top.mas_equalTo(topicImageView.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        self.topicTitleLabel = topicTitleLabel;
        
        UILabel *topicNumberLabel = [UILabel new];
        topicNumberLabel.font = [UIFont systemFontOfSize:12];
        topicNumberLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [ws addSubview:topicNumberLabel];
        
        [topicNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(ws.mas_trailing).offset(- 10);
            make.top.mas_equalTo(topicImageView.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(ws.mas_bottom).offset(-10);
        }];
        self.topicNumberLabel = topicNumberLabel;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
        [ws addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.mas_bottom).offset(-1);
            make.leading.trailing.mas_equalTo(ws);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

- (void)setListModel:(TopicListModel *)listModel {
    
    [self.topicImageView yy_setImageWithURL:[NSURL URLWithString:listModel.iosListpic]
                  processorKey:NSStringFromClass([self class])
                   placeholder:[UIImage imageNamed:@"community_index_banner_loading"]
                       options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                      }
                     transform:^UIImage *(UIImage *image, NSURL *url) {
                         //                                image = [image yy_imageByResizeToSize:CGSizeMake(80, 80) contentMode:UIViewContentModeScaleAspectFit];
                         //                            return [image yy_imageByRoundCornerRadius:10];
                         return image;
                     }
                    completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                        if (from == YYWebImageFromDiskCache) {
                            ZFLog(@"load from disk cache");
                        }
                    }];
    
    self.topicTitleLabel.text = [NSString stringWithFormat:@"%@",listModel.title];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",listModel.joinNumber,ZFLocalizedString(@"Community_Big_Views",nil)]];
    
    if(listModel.joinNumber.length > 0) {
        [content addAttribute:NSForegroundColorAttributeName value:ZFCOLOR(255, 168, 0, 1.0) range:NSMakeRange(0,listModel.joinNumber.length)];
    }
    
    self.topicNumberLabel.attributedText = content;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

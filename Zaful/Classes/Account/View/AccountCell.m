//
//  AccountCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "AccountCell.h"

@interface AccountCell ()

@property (nonatomic, strong) UIImageView *rightIcon;


@end

@implementation AccountCell

+ (AccountCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[AccountCell class] forCellReuseIdentifier:ACCOUNT_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ACCOUNT_IDENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        kContentView;
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [wc addSubview:self.imgView];
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(12);
            make.centerY.offset(0);
            make.size.equalTo(@24);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        [wc addSubview:self.nameLabel];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.imgView.mas_trailing).offset(12);
            make.height.equalTo(@44);
            make.top.bottom.offset(0);
        }];
        
        self.rightIcon = [[UIImageView alloc] init];
        if ([SystemConfigUtils isRightToLeftShow]) {
            self.rightIcon.image = [UIImage imageNamed:@"account_arrow_left"];
        } else {
            self.rightIcon.image = [UIImage imageNamed:@"account_arrow_right"];
        }
        
        [wc addSubview:self.rightIcon];
        [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-12);
            make.centerY.offset(0);
            make.size.equalTo(@16);
        }];
    }
    return self;
}

@end

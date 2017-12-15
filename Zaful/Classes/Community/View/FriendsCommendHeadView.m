//
//  FriendsCommendHeadView.m
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FriendsCommendHeadView.h"

@interface FriendsCommendHeadView ()
@property (nonatomic,weak) UIView *containerView;
@property (nonatomic,weak) UIView *contactsView;

@property (nonatomic,weak) YYAnimatedImageView *contactsImageView;
@property (nonatomic,weak) UILabel *contactsLabel;

@property (nonatomic,weak) UIView *lineOneView;
@property (nonatomic,weak) UIView *inviteView;

@property (nonatomic,weak) YYAnimatedImageView *inviteImageView;
@property (nonatomic,weak) UILabel *inviteLabel;

@property (nonatomic,weak) UIView *lineTwoView;
@property (nonatomic,weak) UIView *commendView;

@property (nonatomic,weak) UIView *blackView;
@property (nonatomic,weak) UILabel *titleLabel;
@end

@implementation FriendsCommendHeadView

+ (FriendsCommendHeadView *)friendsCommendHeadViewWithTableView:(UITableView *)tableView {
    [tableView registerClass:[FriendsCommendHeadView class]  forHeaderFooterViewReuseIdentifier:NSStringFromClass([FriendsCommendHeadView class])];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FriendsCommendHeadView class])];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        
        UIView *containerView = [UIView new];
        containerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self.contentView);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        self.containerView = containerView;
        
        UIView *contactsView = [UIView new];
        contactsView.userInteractionEnabled = YES;
        UITapGestureRecognizer *contactsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactsEvent:)];
        contactsTap.numberOfTapsRequired = 1;
        [contactsView addGestureRecognizer:contactsTap];
        [containerView addSubview:contactsView];
        [contactsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(containerView);
        }];
        self.contactsView = contactsView;
        
        YYAnimatedImageView *contactsImageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"contacts"]];
        [contactsView addSubview:contactsImageView];
        [contactsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(contactsView.mas_leading).offset(16);
            make.width.height.mas_equalTo(35);
            make.top.mas_equalTo(contactsView.mas_top).offset(13);
            make.bottom.mas_equalTo(contactsView.mas_bottom).offset(-13);
            make.centerY.mas_equalTo(contactsView.mas_centerY);
        }];
        self.contactsImageView = contactsImageView;
        
        UILabel *contactsLabel = [UILabel new];
        contactsLabel.font = [UIFont systemFontOfSize:16];
        contactsLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        contactsLabel.text = ZFLocalizedString(@"AddMoreFriends_Contacts",nil);
        [contactsView addSubview:contactsLabel];
        [contactsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(contactsImageView.mas_trailing).offset(16);
            make.centerY.mas_equalTo(contactsView.mas_centerY);
        }];
        self.contactsLabel = contactsLabel;
        
        
        UIView *lineOneView = [UIView new];
        lineOneView.backgroundColor = ZFCOLOR(212, 212, 212, 1.0);
        [containerView addSubview:lineOneView];
        [lineOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contactsView.mas_bottom);
            make.leading.mas_equalTo(containerView.mas_leading).offset(68);
            make.trailing.mas_equalTo(containerView.mas_trailing);
            make.height.mas_equalTo(MIN_PIXEL);
        }];
        self.lineOneView = lineOneView;

        UIView *inviteView = [UIView new];
        inviteView.userInteractionEnabled = YES;
        UITapGestureRecognizer *inviteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inviteEvent:)];
        inviteTap.numberOfTapsRequired = 1;
        [inviteView addGestureRecognizer:inviteTap];
        [containerView addSubview:inviteView];
        [inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(containerView);
            make.top.mas_equalTo(lineOneView.mas_bottom);
        }];
        self.inviteView = inviteView;
        
        YYAnimatedImageView *inviteImageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"fb"]];
        [inviteView addSubview:inviteImageView];
        [inviteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(inviteView.mas_leading).offset(16);
            make.width.height.mas_equalTo(35);
            make.top.mas_equalTo(inviteView.mas_top).offset(13);
            make.bottom.mas_equalTo(inviteView.mas_bottom).offset(-13);
            make.centerY.mas_equalTo(inviteView.mas_centerY);
        }];
        self.inviteImageView = inviteImageView;
        
        UILabel *inviteLabel = [UILabel new];
        inviteLabel.font = [UIFont systemFontOfSize:16];
        inviteLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        inviteLabel.text = ZFLocalizedString(@"AddMoreFriends_FaceBook",nil);
        [inviteView addSubview:inviteLabel];
        [inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(inviteImageView.mas_trailing).offset(16);
            make.centerY.mas_equalTo(inviteView.mas_centerY);
        }];
        self.inviteLabel = inviteLabel;
        
        UIView *lineTwoView = [UIView new];
        lineTwoView.backgroundColor = ZFCOLOR(212, 212, 212, 1.0);
        [containerView addSubview:lineTwoView];
        [lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(inviteView.mas_bottom);
            make.bottom.mas_equalTo(containerView.mas_bottom);
            make.leading.mas_equalTo(containerView.mas_leading);
            make.trailing.mas_equalTo(containerView.mas_trailing);
            make.height.mas_equalTo(MIN_PIXEL);
        }];
        self.lineTwoView = lineTwoView;

        UIView *commendView = [UIView new];
        commendView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:commendView];
        [commendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.mas_equalTo(self.contentView);
            make.top.mas_equalTo(inviteView.mas_bottom).offset(16);
            make.height.mas_equalTo(38);
        }];
        self.commendView = commendView;
        
        UIView *blackView = [UIView new];
        blackView.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [commendView addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.mas_equalTo(commendView);
            make.width.mas_equalTo(@3);
        }];
        self.blackView = blackView;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        titleLabel.text = ZFLocalizedString(@"AddMoreFriends_Suggested",nil);
        [commendView addSubview:titleLabel];
        [titleLabel sizeToFit];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(blackView.mas_trailing).offset(16);
            make.centerY.mas_equalTo(blackView.mas_centerY);
            make.top.mas_equalTo(blackView.mas_top).offset(10);
            make.bottom.mas_equalTo(blackView.mas_bottom).offset(-10);
        }];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)contactsEvent:(UITapGestureRecognizer *)gesture {
    if (self.contactsTouchBlock) {
        self.contactsTouchBlock();
    }
}

- (void)inviteEvent:(UITapGestureRecognizer *)gesture {
    if (self.inviteTouchBlock) {
        self.inviteTouchBlock();
    }
}

@end

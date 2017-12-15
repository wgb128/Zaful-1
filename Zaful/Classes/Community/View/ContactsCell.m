//
//  ContactsCell.m
//  Zaful
//
//  Created by TsangFa on 17/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ContactsCell.h"
#import "PPGetAddressBook.h"

@interface ContactsCell ()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) BigClickAreaButton *selectButton;
@end

@implementation ContactsCell

+ (ContactsCell *)contactsCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    [tableView registerClass:[ContactsCell class] forCellReuseIdentifier:NSStringFromClass([ContactsCell class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactsCell class]) forIndexPath:indexPath];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        _nameLabel = [UILabel new];
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(16);
            make.centerY.equalTo(self.contentView);
        }];
        
        _selectButton = [[BigClickAreaButton alloc] init];
        _selectButton.clickAreaRadious = 60;
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectPeople:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = ZFCOLOR(238, 238, 238, 1);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(16);
            make.trailing.equalTo(self.contentView).offset(-16);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.6);
        }];
        
    }
    
    return self;
}

-(void)setModel:(PPPersonModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.selectButton.selected =  model.isSelect;
}

- (void)selectPeople:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.isSelect = sender.selected;
    if (self.contactsSelectBlock) {
        self.contactsSelectBlock(self.model);
    }
}

- (void)prepareForReuse {
    self.nameLabel.text = nil;
    self.selectButton.selected = NO;
}

@end

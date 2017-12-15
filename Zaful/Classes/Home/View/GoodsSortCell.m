//
//  GoodsSortCell.m
//  Dezzal
//
//  Created by Y001 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "GoodsSortCell.h"

@interface GoodsSortCell ()
@property (nonatomic, strong) NSIndexPath * indexPath;
@end

@implementation GoodsSortCell

+ (GoodsSortCell *)GoodsSortCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath * )indexPath
{
    [tableView registerClass:[GoodsSortCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    GoodsSortCell * cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        __weak typeof(self.contentView) ws = self.contentView;
        _selectImg = [[YYAnimatedImageView alloc]init];
        [_selectImg setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgClick:)];
        [_selectImg addGestureRecognizer:gest];
        [ws addSubview:_selectImg];
        
        
        _typeLabel = [[UILabel alloc]init];
        [_typeLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [ws addSubview:_typeLabel];
        
        //选择的图片
        [_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.trailing.equalTo(@-10);
            make.width.height.equalTo(@24);
        }];
        
        //显示类型
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.leading.mas_offset(10);
            make.width.mas_offset(200);
        }];
    }
    return self;
}

/**
 *  点击选择图片
 *
 *  @param gest <#gest description#>
 */
- (void)selectImgClick:(UIGestureRecognizer *)gest
{
    if(self.selectImgClick ){
        _selectImgClick(_indexPath);
       }
}

@end

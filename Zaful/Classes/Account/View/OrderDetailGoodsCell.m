//
//  OrderDetailGoodsCell.m
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailGoodsCell.h"
#import "OrderDetailGoodsView.h"
#import "FDStackView.h"

@interface OrderDetailGoodsCell ()
@property (nonatomic, strong) FDStackView *stackView;
@property (nonatomic, strong) NSMutableArray *array;
@end
@implementation OrderDetailGoodsCell

+ (OrderDetailGoodsCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[OrderDetailGoodsCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    @autoreleasepool {
        [self.stackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.stackView removeArrangedSubview:obj];
            [obj removeFromSuperview];
        }];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.array = [[NSMutableArray alloc] init];
        self.stackView = [[FDStackView alloc] init];
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionFill;
        self.stackView.alignment = UIStackViewAlignmentFill;
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
       
    }
    return self;
}

- (void)setArray:(NSMutableArray *)array andOrderStatue:(NSString *)orderStatue {
    _array = array;
    if (![NSArrayUtils isEmptyArray:_array]) {
        [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OrderDetailGoodsView *subtotalView = [[OrderDetailGoodsView alloc] init];
            [subtotalView setGoodsModel:[_array objectAtIndex:idx] andOrderStatue:orderStatue andViewTag:idx];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsDertailClick:)];
            [subtotalView addGestureRecognizer:tap];
            UIView *singleTapView = [tap view];
            singleTapView.tag = idx;
            
            @weakify(self)
            subtotalView.reviewBlock = ^(NSInteger row){
                @strongify(self)
                if (self.reviewBlock) {
                    self.reviewBlock(row);
                }
            };
            
            [self.stackView addArrangedSubview:subtotalView];
        }];
    }
}

- (void)goodsDertailClick:(UITapGestureRecognizer *)gesture {
    NSInteger selectRow = gesture.view.tag;
    if (self.goosDetailBlock) {
        self.goosDetailBlock(selectRow);
    }
}


@end

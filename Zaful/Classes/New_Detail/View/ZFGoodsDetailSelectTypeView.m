//
//  ZFGoodsDetailSelectTypeView.m
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailSelectTypeView.h"
#import "ZFInitViewProtocol.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "ZFSizeSelectNormalHeaderView.h"
#import "ZFSizeSelectSizeHeaderView.h"
#import "ZFSizeSelectSizeFooterView.h"
#import "ZFSizeSelectCollectionViewCell.h"
#import "ZFColorSelectCollectionViewCell.h"
#import "ZFSizeSelectQityNumberView.h"
#import "UIView+GBGesture.h"
#import "ZFSizeSelectSectionModel.h"

static NSString *const kZFSizeSelectNormalHeaderViewIdentifier = @"kZFSizeSelectNormalHeaderViewIdentifier";
static NSString *const kZFSizeSelectSizeHeaderViewIdentifier = @"kZFSizeSelectSizeHeaderViewIdentifier";
static NSString *const kZFSizeSelectCollectionViewCellIdentifier = @"kZFSizeSelectCollectionViewCellIdentifier";
static NSString *const kZFSizeSelectSizeFooterViewIdentifier = @"kZFSizeSelectSizeFooterViewIdentifier";
static NSString *const kZFColorSelectCollectionViewCellIdentifier = @"kZFColorSelectCollectionViewCellIdentifier";
static NSString *const kZFSizeSelectQityNumberViewIdentifier = @"kZFSizeSelectQityNumberViewIdentifier";


@interface ZFGoodsDetailSelectTypeView() <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout, CAAnimationDelegate>
@property (nonatomic, strong) UIView            *maskView;
@property (nonatomic, strong) UIView            *containView;
@property (nonatomic, strong) UIView            *topView;

@property (nonatomic, strong) UIImageView       *goodsImageView;
@property (nonatomic, strong) UILabel           *shopPriceLabel;
@property (nonatomic, strong) UILabel           *marketPriceLabel;
@property (nonatomic, strong) UIView            *deleteLine;
@property (nonatomic, strong) BigClickAreaButton*closeButton;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UICollectionViewLeftAlignedLayout    *flowLayout;

@property (nonatomic, strong) CABasicAnimation  *showAnimation;
@property (nonatomic, strong) CABasicAnimation  *hideAnimation;
@property (nonatomic, strong) NSMutableArray<ZFSizeSelectSectionModel *>        *dataArray;
@end

@implementation ZFGoodsDetailSelectTypeView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)closeButtonAction:(UIButton *)sender {
    [self hideSelectTypeView];
}

#pragma mark - private methods
- (CGFloat)calculateAttrInfoWidthWithAttrName:(NSString *)attrName {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize  size = [attrName boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)   attributes:attribute context:nil].size;
    return size.width + 32 <= 44 ? 44 : size.width + 32;
}

- (void)initializeSizeSelectInfo {
    [self.dataArray removeAllObjects];
    //color
    if (self.model.same_goods_spec.color.count > 0) {
        ZFSizeSelectSectionModel *sectionModel = [[ZFSizeSelectSectionModel alloc] init];
        sectionModel.type = ZFSizeSelectSectionTypeColor;
        sectionModel.typeName = ZFLocalizedString(@"Color", nil);
        sectionModel.itmesArray = [NSMutableArray array];
        
        [self.model.same_goods_spec.color enumerateObjectsUsingBlock:^(GoodsDetialColorModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFSizeSelectItemsModel *model = [[ZFSizeSelectItemsModel alloc] init];
            model.type = ZFSizeSelectItemTypeColor;
            model.color = obj.color_code;
            model.attrName = obj.attr_value;
            model.is_click = obj.is_click;
            model.goodsId = obj.goods_id;
            model.width = 44;
            model.isSelect = [self.model.goods_id isEqualToString:obj.goods_id];
            [sectionModel.itmesArray addObject:model];
        }];
        [self.dataArray addObject:sectionModel];
    }
    //size
    if (self.model.same_goods_spec.size.count > 0) {
        __block NSString *sizeTips = @"";
        ZFSizeSelectSectionModel *sectionModel = [[ZFSizeSelectSectionModel alloc] init];
        sectionModel.type = ZFSizeSelectSectionTypeSize;
        sectionModel.typeName = ZFLocalizedString(@"Size", nil);
        sectionModel.itmesArray = [NSMutableArray array];
        [self.model.same_goods_spec.size enumerateObjectsUsingBlock:^(GoodsDetialSizeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFSizeSelectItemsModel *model = [[ZFSizeSelectItemsModel alloc] init];
            model.type = ZFSizeSelectItemTypeSize;
            model.attrName = obj.attr_value;
            model.is_click = obj.is_click;
            model.goodsId = obj.goods_id;
            model.width = [self calculateAttrInfoWidthWithAttrName:obj.attr_value];
            model.isSelect = [self.model.goods_id isEqualToString:obj.goods_id];
            if ([self.model.goods_id isEqualToString:obj.goods_id]) {
                sizeTips = obj.data_tips;
            }
            [sectionModel.itmesArray addObject:model];
        }];
        [self.dataArray addObject:sectionModel];
        if (![NSStringUtils isEmptyString:sizeTips]) {
            ZFSizeSelectSectionModel *sizeTipsModel = [[ZFSizeSelectSectionModel alloc] init];
            sizeTipsModel.type = ZFSizeSelectSectionTypeSizeTips;
            sizeTipsModel.typeName = sizeTips;
            [self.dataArray addObject:sizeTipsModel];
        }
    }
    //mult attr
    if (self.model.goods_mulit_attr.count > 0) {
        [self.model.goods_mulit_attr enumerateObjectsUsingBlock:^(GoodsDetailMulitAttrModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFSizeSelectSectionModel *sectionModel = [[ZFSizeSelectSectionModel alloc] init];
            sectionModel.type = ZFSizeSelectSectionTypeMultAttr;
            sectionModel.typeName = obj.name;
            sectionModel.itmesArray = [NSMutableArray array];
            [obj.value enumerateObjectsUsingBlock:^(GoodsDetailMulitAttrInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZFSizeSelectItemsModel *model = [[ZFSizeSelectItemsModel alloc] init];
                model.type = ZFSizeSelectItemTypeMultAttr;
                model.attrName = obj.attr_value;
                model.is_click = obj.is_click;
                model.goodsId = obj.goods_id;
                model.width = [self calculateAttrInfoWidthWithAttrName:obj.attr_value];
                model.isSelect = [self.model.goods_id isEqualToString:obj.goods_id];
                [sectionModel.itmesArray addObject:model];
            }];
            [self.dataArray addObject:sectionModel];
        }];
    }
    //Qity
    ZFSizeSelectSectionModel *sectionModel = [[ZFSizeSelectSectionModel alloc] init];
    sectionModel.type = ZFSizeSelectSectionTypeQity;
    sectionModel.itmesArray = [NSMutableArray array];
    [self.dataArray addObject:sectionModel];

    [self.collectionView reloadData];
}

#pragma mark - animation methods
- (void)openSelectTypeView {
    [self.containView.layer addAnimation:self.showAnimation forKey:@"showAnimation"];
}

- (void)hideSelectTypeView {
    [self.containView.layer addAnimation:self.hideAnimation forKey:@"hideAnimation"];
    if (self.goodsDetailSelectHideAnimationCompletionHandler) {
        self.goodsDetailSelectHideAnimationCompletionHandler();
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ZFSizeSelectSectionModel *sectionModel = self.dataArray[section];
    return sectionModel.itmesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFSizeSelectSectionModel *sectionModel = self.dataArray[indexPath.section];

    if (sectionModel.type == ZFSizeSelectSectionTypeColor) {
        ZFColorSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFColorSelectCollectionViewCellIdentifier forIndexPath:indexPath];
        cell.model = sectionModel.itmesArray[indexPath.item];
        return cell;
    } else if (sectionModel.type == ZFSizeSelectSectionTypeSize) {
        ZFSizeSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFSizeSelectCollectionViewCellIdentifier forIndexPath:indexPath];
        cell.model = sectionModel.itmesArray[indexPath.item];
        return cell;
    } else if (sectionModel.type == ZFSizeSelectSectionTypeMultAttr) {
        ZFSizeSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFSizeSelectCollectionViewCellIdentifier forIndexPath:indexPath];
        cell.model = sectionModel.itmesArray[indexPath.item];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZFSizeSelectSectionModel *sectionModel = self.dataArray[indexPath.section];
    ZFSizeSelectItemsModel *model = sectionModel.itmesArray[indexPath.item];
    if (!model.is_click || [model.goodsId isEqualToString:self.model.goods_id]) {
        return ;
    }
    NSString *itemName = model.type == ZFSizeSelectItemTypeColor ? @"Color" : @"Size";
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Selected_%@_%@_%@", itemName, model.attrName, model.goodsId] itemName:itemName ContentType:@"Goods - Detail" itemCategory:itemName];
    if (self.goodsDetailSelectTypeCompletionHandler) {
        self.goodsDetailSelectTypeCompletionHandler(model.goodsId);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {                                                                
    ZFSizeSelectSectionModel *sectionModel = self.dataArray[indexPath.section];

    if (sectionModel.type == ZFSizeSelectSectionTypeColor) {
        ZFSizeSelectNormalHeaderView *normalView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectNormalHeaderViewIdentifier forIndexPath:indexPath];
        normalView.title = sectionModel.typeName;
        return normalView;
    } else if (sectionModel.type == ZFSizeSelectSectionTypeSize) {
        ZFSizeSelectSizeHeaderView *sizeView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectSizeHeaderViewIdentifier forIndexPath:indexPath];
        @weakify(self);
        sizeView.sizeSelectGuideJumpCompletionHandler = ^{
            @strongify(self);
            if (self.goodsDetailSelectSizeGuideCompletionHandler) {
                self.goodsDetailSelectSizeGuideCompletionHandler();
            }
        };
        return sizeView;
    } else if (sectionModel.type == ZFSizeSelectSectionTypeSizeTips) {
        ZFSizeSelectSizeFooterView *sizeTipsView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectSizeFooterViewIdentifier forIndexPath:indexPath];
        sizeTipsView.tipsInfo = sectionModel.typeName;
        return sizeTipsView;
    } else if (sectionModel.type == ZFSizeSelectSectionTypeMultAttr) {
        ZFSizeSelectNormalHeaderView *normalView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectNormalHeaderViewIdentifier forIndexPath:indexPath];
        normalView.title = sectionModel.typeName;
        return normalView;
    } else if (sectionModel.type == ZFSizeSelectSectionTypeQity) {
        ZFSizeSelectQityNumberView *qityView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectQityNumberViewIdentifier forIndexPath:indexPath];
        qityView.goodsNumber = self.model.goods_number;
        qityView.number = self.chooseNumebr;
        @weakify(self);
        qityView.sizeSelectQityNumberChangeCompletionHandler = ^(NSInteger number) {
            @strongify(self);
            if (self.goodsDetailSelectNumberChangeCompletionHandler) {
                self.goodsDetailSelectNumberChangeCompletionHandler(number);
            }
        };
        return qityView;
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegateLeftAlignedLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    ZFSizeSelectSectionModel *sectionModel = self.dataArray[section];
    if (sectionModel.type == ZFSizeSelectSectionTypeQity) {
        return CGSizeMake(SCREEN_WIDTH, 140);
    }
    return CGSizeMake(SCREEN_WIDTH, 48);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFSizeSelectSectionModel *sectionModel = self.dataArray[indexPath.section];
    ZFSizeSelectItemsModel *model = sectionModel.itmesArray[indexPath.item];
    return CGSizeMake(model.width, 44);
}

#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.goodsDetailSelectTypeCloseCompletionHandler) {
        self.goodsDetailSelectTypeCloseCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:self.maskView];
    [self addSubview:self.containView];
    [self.containView addSubview:self.topView];
    [self.topView addSubview:self.goodsImageView];
    [self.topView addSubview:self.shopPriceLabel];
    [self.topView addSubview:self.marketPriceLabel];
    [self.marketPriceLabel addSubview:self.deleteLine];
    [self.topView addSubview:self.closeButton];
    [self.containView addSubview:self.collectionView];
    
}

- (void)zfAutoLayoutView {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_HEIGHT - 440);
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(440);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.containView);
        make.height.mas_equalTo(80);
    }];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.topView.mas_bottom).offset(-8);
        make.leading.mas_equalTo(self.topView.mas_leading).offset(16);
        make.width.mas_equalTo(48);
    }];
    
    [self.shopPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(16);
        make.top.mas_equalTo(self.topView.mas_top).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(16);
        make.top.mas_equalTo(self.shopPriceLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(20);
    }];
    
    [self.deleteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.trailing.mas_equalTo(self.marketPriceLabel);
        make.height.mas_equalTo(1);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_top).offset(16);
        make.trailing.mas_equalTo(self.topView.mas_trailing).offset(-16);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.containView);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}

#pragma mark - setter
- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:_model.wp_image] processorKey:NSStringFromClass([self class]) placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:nil];
    self.shopPriceLabel.text = [ExchangeManager transforPrice:_model.shop_price];
    self.marketPriceLabel.text = [ExchangeManager transforPrice:_model.market_price];
    [self initializeSizeSelectInfo];
}

- (void)setChooseNumebr:(NSInteger)chooseNumebr {
    _chooseNumebr = chooseNumebr;
}

#pragma mark - getter
- (NSMutableArray<ZFSizeSelectSectionModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor clearColor];
        @weakify(self);
        [_maskView addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            [self hideSelectTypeView];
        }];
    }
    return _maskView;
}

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectZero];
        _containView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _containView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = ZFCOLOR(245, 245, 245, 1.f);
    }
    return _topView;
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _goodsImageView;
}

- (UILabel *)shopPriceLabel {
    if (!_shopPriceLabel) {
        _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLabel.textColor = ZFCOLOR(183, 96, 42, 1.f);
        _shopPriceLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _shopPriceLabel;
}

- (UILabel *)marketPriceLabel {
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketPriceLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _marketPriceLabel;
}

- (UIView *)deleteLine {
    if (!_deleteLine) {
        _deleteLine = [[UIView alloc] initWithFrame:CGRectZero];
        _deleteLine.backgroundColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _deleteLine;
}

- (BigClickAreaButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"size_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.clickAreaRadious = 64;
    }
    return _closeButton;
}

- (UICollectionViewLeftAlignedLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        _flowLayout.minimumLineSpacing = 16;
        _flowLayout.minimumInteritemSpacing = 16;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _flowLayout.alignedLayoutType = [SystemConfigUtils isRightToLeftShow] ? UICollectionViewLeftAlignedLayoutTypeRight : UICollectionViewLeftAlignedLayoutTypeLeft;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ZFCOLOR_WHITE;
        
        [_collectionView registerClass:[ZFSizeSelectCollectionViewCell class] forCellWithReuseIdentifier:kZFSizeSelectCollectionViewCellIdentifier];
        [_collectionView registerClass:[ZFColorSelectCollectionViewCell class] forCellWithReuseIdentifier:kZFColorSelectCollectionViewCellIdentifier];
        [_collectionView registerClass:[ZFSizeSelectNormalHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectNormalHeaderViewIdentifier];
        [_collectionView registerClass:[ZFSizeSelectSizeFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectSizeFooterViewIdentifier];
        [_collectionView registerClass:[ZFSizeSelectSizeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectSizeHeaderViewIdentifier];
        [_collectionView registerClass:[ZFSizeSelectQityNumberView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZFSizeSelectQityNumberViewIdentifier];
    }
    return _collectionView;
}

- (CABasicAnimation *)showAnimation {
    if (!_showAnimation) {
        _showAnimation = [CABasicAnimation animation];
        _showAnimation.keyPath = @"position.y";
        _showAnimation.fromValue = @(SCREEN_HEIGHT * 1.5);
        _showAnimation.toValue = @(SCREEN_HEIGHT - 270);
        _showAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        _showAnimation.duration = 0.35f;
        _showAnimation.fillMode = kCAFillModeForwards;
        _showAnimation.removedOnCompletion = NO;
    }
    return _showAnimation;
}

- (CABasicAnimation *)hideAnimation {
    if (!_hideAnimation) {
        _hideAnimation = [CABasicAnimation animation];
        _hideAnimation.keyPath = @"position.y";
        _hideAnimation.fromValue = @(SCREEN_HEIGHT - 270);
        _hideAnimation.toValue = @(SCREEN_HEIGHT * 1.5);
        _hideAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        _hideAnimation.duration = 0.35f;
        _hideAnimation.fillMode = kCAFillModeForwards;
        _hideAnimation.removedOnCompletion = NO;
        _hideAnimation.delegate = self;
    }
    return _hideAnimation;
}
@end

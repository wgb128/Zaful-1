//
//  CategorySelectView.m
//  ListPageViewController
//
//  Created by TsangFa on 8/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategorySelectView.h"  
#import "CategoryNewModel.h"
#import "CategorySectionViewCell.h"
#import "CategorySortSectionView.h"
#import "CategoryPriceListSectionView.h"
#import "CategorySubCell.h"
#import "CategoryPriceListModel.h"

static CGFloat    const kSelectCellHeight = 44.0f;

@interface CategorySelectView ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>
@property (nonatomic, strong) UITableView        *selectTableView;
@property (nonatomic, strong) UIView             *maskView;
@end

@implementation CategorySelectView

#pragma mark - Init Method
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}

#pragma mark - Initialize
- (void)configureSubViews {
    self.hidden = YES;
    [self addSubview:self.maskView];
    [self addSubview:self.selectTableView];
}

- (void)autoLayoutSubViews{
    self.maskView.frame = CGRectMake(0, 0, KScreenWidth,KScreenHeight - 108);
    self.selectTableView.frame = CGRectMake(0, 0, KScreenWidth, 0);
}

#pragma mark - Setter
- (void)setCategoryArray:(NSArray *)categoryArray {
    _categoryArray = categoryArray;
    [self.selectTableView reloadData];
}

- (void)setSortArray:(NSArray<NSString *> *)sortArray {
    _sortArray = sortArray;
    [self.selectTableView reloadData];
}

#pragma mark - UITableViewDelegate - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataType == SelectViewDataTypeCategory ? self.categoryArray.count : self.sortArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isPriceList
        || self.dataType != SelectViewDataTypeCategory) {
        return 0;
    } else {
        CategoryNewModel *model = self.categoryArray[section];
        if ([model.is_child boolValue] && model.isOpen) {
            return [self loadSubCategory:model.cat_id].count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategorySubCell *cell = [tableView dequeueReusableCellWithIdentifier:[CategorySubCell setIdentifier] forIndexPath:indexPath];
    CategoryNewModel *sectionModel = self.categoryArray[indexPath.section];
    NSArray<CategoryNewModel *> *childs = [[CategoryDataManager shareManager] querySubCategoryDataWithParentID:sectionModel.cat_id];
    CategoryNewModel *cellModel = childs[indexPath.row];
    cellModel.isSelect = [self.currentCategory isEqualToString:cellModel.cat_name] ? YES : NO;
    cell.titleLabel.text = cellModel.cat_name;
    cell.isSelect = cellModel.isSelect;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataType == SelectViewDataTypeCategory ) {
        if (self.isPriceList) {
            CategoryPriceListSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[CategoryPriceListSectionView setIdentifier]];
            CategoryPriceListModel *model = self.categoryArray[section];
            headerView.priceRange = model.price_range;
            headerView.isSelect = [self.currentSortType isEqualToString:headerView.priceRange] ? YES : NO;
            headerView.categoryPriceListSectionViewTouchHandler = ^(NSString *selectTitle, BOOL isSelect) {
                if (self.selectCompletionHandler) {
                    self.selectCompletionHandler(section, self.dataType);
                }
                self.currentSortType = selectTitle;
                [self reloadTableViewData];
            };
            return headerView;
        }else{
            CategorySectionViewCell *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[CategorySectionViewCell setIdentifier]];
            CategoryNewModel *model = self.categoryArray[section];
            model.isSelect = [self.currentCategory isEqualToString:model.cat_name] ? YES : NO;
            headerView.model = model;
            @weakify(headerView)
            headerView.categorySectionViewTouchHandler = ^(CategoryNewModel *model) {
                @strongify(headerView)
                if ([model.is_child boolValue]) {
                    NSArray *childArray = [self loadSubCategory:model.cat_id];
                    NSMutableArray *indexPaths = [NSMutableArray array];
                    for (int i = 0; i < childArray.count; i++) {
                        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
                    }

                    headerView.model = model;
                    
                    if (model.isOpen) {
                        [self.selectTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        [self.selectTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                    NSMutableArray *openArray = [NSMutableArray array];
                    for (CategoryNewModel *model in self.categoryArray) {
                        if (model.isOpen) {
                            [openArray addObjectsFromArray:[self loadSubCategory:model.cat_id]];
                        }
                    }
                    [openArray addObjectsFromArray:self.categoryArray];
                    CGFloat  resultHeight = MIN(openArray.count * kSelectCellHeight, self.bounds.size.height - [self queryPhonePadding]);
                    [UIView animateWithDuration:0.3 animations:^{
                        self.selectTableView.frame = CGRectMake(0, 0, KScreenWidth, resultHeight);
                    }];
                }else{
                    for (CategoryNewModel *model in self.categoryArray) {
                        model.isOpen = NO;
                    }
                    if (self.selectCompletionHandler) {
                        self.selectCompletionHandler(section, self.dataType);
                    }
                    self.currentCategory = model.cat_name;
                    [self reloadTableViewData];
                }
            };
            return headerView;
        }

    }else{
        CategorySortSectionView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[CategorySortSectionView setIdentifier]];
        headerView.sortType = self.sortArray[section];
        headerView.isSelect = [self.currentSortType isEqualToString:headerView.sortType] ? YES : NO;
        headerView.categorySortSectionViewTouchHandler = ^(NSString *selectTitle, BOOL isSelect) {
            if (self.selectCompletionHandler) {
                self.selectCompletionHandler(section, self.dataType);
            }
            self.currentSortType = selectTitle;
            [self reloadTableViewData];
        };
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    CategoryNewModel *sectionModel = self.categoryArray[indexPath.section];
    NSArray<CategoryNewModel *> *childs = [self loadSubCategory:sectionModel.cat_id];
    CategoryNewModel *cellModel = childs[indexPath.row];
    cellModel.isSelect = !cellModel.isSelect;
    self.currentCategory = cellModel.cat_name;
    [self reloadTableViewData];
    if (self.selectSubCellHandler) {
        self.selectSubCellHandler(cellModel, self.dataType);
    }

}

#pragma mark - Private Methods
- (NSArray<CategoryNewModel *> *)loadSubCategory:(NSString *)catID {
    NSArray<CategoryNewModel *> *childs = [[CategoryDataManager shareManager] querySubCategoryDataWithParentID:catID];
    return childs;
}

#pragma mark - Public Methods
- (void)showCompletion:(void (^)())completion {
    NSMutableArray *openArray = [NSMutableArray array];
    
    if (self.isPriceList) {
        [openArray addObjectsFromArray:self.categoryArray];
    }else{
        for (CategoryNewModel *model in self.categoryArray) {
            if (model.isOpen) {
                [openArray addObjectsFromArray:[self loadSubCategory:model.cat_id]];
            }
        }
        [openArray addObjectsFromArray:self.categoryArray];
    }
    
    CGFloat resultHeight;
    if (self.dataType == SelectViewDataTypeSort) {
        resultHeight = self.sortArray.count * kSelectCellHeight;
    }else{
        resultHeight = MIN(openArray.count * kSelectCellHeight, self.bounds.size.height - [self queryPhonePadding]);
    }
    self.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectTableView.frame = CGRectMake(0, 0, KScreenWidth, resultHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.03 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        } completion:^(BOOL finished) {
            if (finished) {
                completion();
            }
            if (self.selectAnimationStopCompletionHandler) {
                self.selectAnimationStopCompletionHandler();
            }
        }];
    }];
}

- (CGFloat)queryPhonePadding {
    CGFloat padding;
    if (IPHONE_5X_4_0) {
        padding = 158;
    }else if (IPHONE_6X_4_7) {
        padding = 170;
    }else if (IPHONE_7P_5_5) {
        padding = 188;
    }else{
        padding = 0; // 为了取消警告写的
    }
    return padding;
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.selectTableView.frame = CGRectMake(0, 0, KScreenWidth, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.08 animations:^{
                    self.hidden = YES;
                    if (self.selectAnimationStopCompletionHandler) {
                        self.selectAnimationStopCompletionHandler();
                    }
                }];
            }];
        }
    }];
}

- (void)reloadTableViewData {
    [self.selectTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)reloadRowData:(NSArray *)dataArray {
    [self.selectTableView beginUpdates];
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < dataArray.count; i++) {
        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.selectTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    [self.selectTableView endUpdates];
}

#pragma mark - Gesture Handle
- (void)hideSelectView {
    [self dismiss];
    if (self.maskTapCompletionHandler) {
        self.maskTapCompletionHandler(self.dataType);
    }
}

#pragma mark - Getter
- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selectTableView.dataSource = self;
        _selectTableView.delegate = self;
        _selectTableView.backgroundColor = [UIColor clearColor];
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectTableView.tableFooterView = [UIView new];
        _selectTableView.sectionHeaderHeight = 44.0;
        _selectTableView.rowHeight = kSelectCellHeight;
         [_selectTableView registerClass:[CategorySectionViewCell class] forHeaderFooterViewReuseIdentifier:[CategorySectionViewCell setIdentifier]];
        [_selectTableView registerClass:[CategorySortSectionView class] forHeaderFooterViewReuseIdentifier:[CategorySortSectionView setIdentifier]];
        [_selectTableView registerClass:[CategoryPriceListSectionView class] forHeaderFooterViewReuseIdentifier:[CategoryPriceListSectionView setIdentifier]];
        [_selectTableView registerClass:[CategorySubCell class] forCellReuseIdentifier:[CategorySubCell setIdentifier]];
    }
    return _selectTableView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end

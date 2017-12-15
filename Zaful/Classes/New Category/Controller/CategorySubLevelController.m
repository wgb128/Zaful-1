//
//  CategorySubLevelController.m
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategorySubLevelController.h"
#import "CategorySubLevelCell.h"
#import "CategorySubLevelViewModel.h"
#import "CategoryListPageViewController.h"

@interface CategorySubLevelController ()
@property (nonatomic, strong) UICollectionView            *categoryView;
@property (nonatomic, strong) CategorySubLevelViewModel   *viewModel;
@end

@implementation CategorySubLevelController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubViews];
    [self autoLayoutSubViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //谷歌统计
    [ZFAnalytics screenViewQuantityWithScreenName:[NSString stringWithFormat:@"Cate - %@", self.model.cat_name]];
    
    /**
     *  此方法是为了防止控制器的title发生偏移，造成这样的原因是因为返回按钮的文字描述占位
     */
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    
    if ([viewControllerArray containsObject:self]) {
        long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
        UIViewController *previous;
        if (previousViewControllerIndex >= 0) {
            previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
            previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:nil];
        }
    }
    
}

#pragma mark - Initialize
-(void)configureSubViews {
    self.title = self.model.cat_name;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.view addSubview:self.categoryView];
}

-(void)autoLayoutSubViews {
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Private Methods
- (void)loadData {
    [self.viewModel requestSubLevelDataWithParentID:self.model.cat_id completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.categoryView reloadData];
        });
    }];
}

#pragma mark - Getter
-(UICollectionView *)categoryView {
    if (!_categoryView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 7.5;
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        CGFloat itemWidth = (KScreenWidth - 12 - 12 - 15) / 3;
        layout.itemSize = CGSizeMake(itemWidth, 138);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _categoryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _categoryView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
        [_categoryView registerClass:[CategorySubLevelCell class] forCellWithReuseIdentifier:[CategorySubLevelCell setIdentifier]];
        _categoryView.delegate = self.viewModel;
        _categoryView.dataSource = self.viewModel;
        _categoryView.alwaysBounceVertical = YES;
    }
    return _categoryView;
}

-(CategorySubLevelViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CategorySubLevelViewModel alloc] init];
        @weakify(self)
        _viewModel.handler = ^(CategoryNewModel *model) {
            @strongify(self)
            // firebase统计
            [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Category_Item_%@", model.cat_name] itemName:model.cat_name ContentType:@"Category_Sub_List" itemCategory:@"List"];
            
            CategoryListPageViewController *listPageVC = [[CategoryListPageViewController alloc] init];
            listPageVC.model = model;
            [self.navigationController pushViewController:listPageVC animated:YES];
        };
    }
    return _viewModel;
}

@end

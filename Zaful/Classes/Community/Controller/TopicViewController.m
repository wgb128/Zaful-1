//
//  TopicViewController.m
//  Zaful
//
//  Created by huangxieyue on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//  话题详情

#import "TopicViewController.h"
#import "TopicViewModel.h"
#import "TopicTableViewCell.h"
#import "TopicDetailHeadView.h"
#import "TopicDetailHeadLabelModel.h"
#import "TopicDetailListModel.h"
#import "StyleLikesModel.h"

#import "PostViewController.h"
#import "TZImagePickerController.h"
#import "PostPhotosManager.h"
#import "ZFLoginViewController.h"

#import "ZFShare.h"

@interface TopicViewController ()<TZImagePickerControllerDelegate,ZFShareViewDelegate>
@property (nonatomic, strong) TopicViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopicDetailHeadView *topView;
@property (nonatomic, strong) TopicDetailHeadLabelModel *topicDetailHeadModel;

@property (nonatomic, strong) ZFShareView      *shareView;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"Topic_VC_Title",nil);
     [self configureRightBarItem];
    [self initView];
    [self requestData];
    
    //接收关注状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    //接收点赞状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
    //接收评论状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewCountsChangeValue:) name:kReviewCountsChangeNotification object:nil];
    //接收登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
    //刷新topicDetail页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTopicValue:) name:kRefreshTopicNotification object:nil];
    //隐藏空白页提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTopicHeightValue:) name:@"VIEWALL" object:nil];
    //接收删除状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
}

- (void)refreshTopicValue:(NSNotification *)nofi {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:KTopicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.sort = @"1";
    [self requestData];
    
}

- (void)refreshTopicHeightValue:(NSNotification *)nofi {
    NSDictionary *isShowDictionary = [nofi userInfo];
    BOOL isShow  = [[isShowDictionary objectForKey:@"isShow"] boolValue];
    [_viewModel isHiddenEmpty:isShow];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:KTopicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark - requestApi
- (void)requestData {
    if (!self.sort) {
        self.sort = @"1";
    }
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestTopicDetailListNetwork:@[LoadMore,self.topicId,self.sort,@(NO)] completion:^(id obj) {
            @strongify(self)
            if([obj isKindOfClass:[NSString class]] && [obj isEqual: NoMoreToLoad]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            }else {
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView.mj_footer endRefreshing];
        }];
        
    }];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [MBProgressHUD showLoadingView:nil];
        [self.viewModel requestNetwork:@[self.topicId,self.sort,@(NO)] completion:^(NSArray *objs) {
            @strongify(self)
            if (objs[0]) {
                self.topView.topicDetailHeadModel = objs[0];
                self.topicDetailHeadModel = objs[0];
                NSString *test = [NSString stringWithFormat:@"%@?actiontype=6&url=3,%@&name=@""&source=sharelink&lang=%@",CommunityShareURL,self.topicId, [ZFLocalizationString shareLocalizable].nomarLocalizable];
                ZFLog(@"%@",test);
            }
            
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView.mj_header endRefreshing];
        } failure:^(id obj) {
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - requestApi
- (void)changeRequestData {
    if (!self.sort) {
        self.sort = @"1";
    }
    @weakify(self)
    [self.viewModel requestNetwork:@[self.topicId,self.sort,@(YES)] completion:^(NSArray *objs) {
        @strongify(self)
        if (objs[0]) {
            self.topView.topicDetailHeadModel = objs[0];
            self.topicDetailHeadModel = objs[0];
        }
        
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
        if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
            [self.tableView.mj_footer resetNoMoreData];
            self.tableView.mj_footer.hidden = NO;
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(id obj) {
        @strongify(self)
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];

}

#pragma mark - initView
- (void) initView {
    self.topView = [[TopicDetailHeadView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = ZFCOLOR(255, 255, 255, 0.5);
    CGRect rect = CGRectZero;
    rect.size = [self.topView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.topView.frame = rect;
    
    @weakify(self)
    self.topView.refreshHeadViewBlock = ^(){
        @strongify(self)
        CGRect rect = CGRectZero;
        rect.size = [self.topView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.topView.frame = rect;
        self.tableView.tableHeaderView = self.topView;
    };
    
    
    self.topView.joinInMyStyleBlock = ^(NSString *topicLabel){
        @strongify(self)
        if ([AccountManager sharedManager].isSignIn) {
            [self pushImagePickerController];
        } else {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self)
                [self pushImagePickerController];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    };
    [self.view addSubview:self.topView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[TopicTableViewCell class] forCellReuseIdentifier:TOPIC_CELL_IDENTIFIER];
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = ZFCOLOR_WHITE;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.topView;
    self.tableView.bounces = YES;
    self.tableView.dataSource = self.viewModel;
    self.tableView.delegate = self.viewModel;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)configureRightBarItem {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(64, 2, 20, 19)];
    [btn setImage:[UIImage imageNamed:@"community_share"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareHandle) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 84, 24)];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:btn];
    
    UIBarButtonItem *accountItme = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    self.navigationItem.rightBarButtonItem = accountItme;
}

- (void)shareHandle {
    [self.shareView open];
}

#pragma mark - ZFShareViewDelegate
- (void)zfShsreView:(ZFShareView *)shareView didSelectItemAtIndex:(NSUInteger)index {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    model.share_url = [NSString stringWithFormat:@"%@?actiontype=6&url=3,%@&name=@""&source=sharelink&lang=%@",CommunityShareURL,self.topicId,[ZFLocalizationString shareLocalizable].nomarLocalizable];
    model.fromviewController = self;
    [ZFShareManager shareManager].model = model;
    switch (index) {
        case ZFShareTypeFacebook:
        {
            [[ZFShareManager shareManager] shareToFacebook];
        }
            break;
        case ZFShareTypeMessenger:
        {
            [[ZFShareManager shareManager] shareToMessenger];
        }
            break;
        case ZFShareTypeCopy:
        {
            [[ZFShareManager shareManager] copyLinkURL];
        }
            break;
    }
}


#pragma mark - LazyLoad
- (TopicViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[TopicViewModel alloc] init];
        _viewModel.controller = self;
        @weakify(self)
        _viewModel.topicclickEventBlock = ^(NSInteger sort) {
            @strongify(self)
            self.sort = [NSString stringWithFormat: @"%d", (int)sort];
            [self changeRequestData];
            
        };
    }
    return _viewModel;
}

#pragma mark - 接收关注通知
- (void)followStatusChangeValue:(NSNotification *)noti {
    //接收通知传过来的两个值 dict[@"isFollow"],dict[@"userId"]
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    //遍历当前列表数组找到相同userId改变关注按钮状态
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(TopicDetailListModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
        }
    }];
    [self.tableView reloadData];
}

/*========================================分割线======================================*/
#pragma mark - 接收删除通知
- (void)deleteChangeValue:(NSNotification *)nofi {
    [self requestData];
}


/*========================================分割线======================================*/

#pragma mark - 接收点赞通知
- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    StyleLikesModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(TopicDetailListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewsId isEqualToString:likesModel.reviewId]) {
            if (likesModel.isLiked) {
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
            }else{
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
            }
            obj.isLiked = likesModel.isLiked;
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
}

/*========================================分割线======================================*/

#pragma mark - 接收评论通知
- (void)reviewCountsChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    StyleLikesModel *reviewsModel = nofi.object;
    //遍历当前列表数组找到相同reviewId增加评论数
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(TopicDetailListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewsId isEqualToString:reviewsModel.reviewId]) {
            obj.replyCount = [NSString stringWithFormat:@"%d", [obj.replyCount intValue] +1];
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - 接收登录通知
- (void)loginChangeValue:(NSNotification *)nofi {
    [self requestData];
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    TZImagePickerController *customImagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    customImagePickerController.isSelectOriginalPhoto = YES;
    // 1.设置目前已经选中的图片数组
    customImagePickerController.selectedAssets = [PostPhotosManager sharedManager].selectedAssets; // 目前已经选中的图片数组
    
    customImagePickerController.allowTakePicture = YES; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    customImagePickerController.allowPickingVideo = NO;
    customImagePickerController.allowPickingImage = YES;
    customImagePickerController.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    customImagePickerController.sortAscendingByModificationDate = NO;
    
    customImagePickerController.minImagesCount = 1;
    customImagePickerController.maxImagesCount = 6;
    
    [self presentViewController:customImagePickerController animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [PostPhotosManager sharedManager].selectedPhotos = [NSMutableArray arrayWithArray:photos];
    [PostPhotosManager sharedManager].selectedAssets = [NSMutableArray arrayWithArray:assets];
    [PostPhotosManager sharedManager].isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    PostViewController *postVC = [[PostViewController alloc] init];
    postVC.topic = self.topicDetailHeadModel.topicLabel;
    postVC.title = self.topicDetailHeadModel.topicLabel;
    postVC.selectedPhotos = [PostPhotosManager sharedManager].selectedPhotos;
    postVC.selectedAssets = [PostPhotosManager sharedManager].selectedAssets;
    if ([picker isKindOfClass:[TZImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:postVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - getter
- (ZFShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ZFShareView alloc] init];
        _shareView.delegate = self;
        
        ZFShareTopView *topView = [[ZFShareTopView alloc] init];
        topView.imageName = self.topicDetailHeadModel.iosDetailpic;
        topView.title = ZFLocalizedString(@"ZFShare_Community_topic", nil);
        _shareView.topView = topView;
    }
    return _shareView;
}

@end

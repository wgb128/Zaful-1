//
//  PostViewController.m
//  Zaful
//
//  Created by TsangFa on 16/11/26.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "PostViewController.h"
//#import "YYText.h"
#import "PostPhotoCell.h" // 选择照片Cell
#import "GoodsImageCell.h" // 关联商品 Cell
#import "TTGTextTagCollectionView.h" // 标签
#import "GoodsPageViewController.h" // 关联商品控制器
#import "PostApi.h"
#import "PostViewModel.h"
#import "TZImagePickerController.h"
#import "PostPhotosManager.h"
#import "PostGoodsManager.h"
#import "YSTextView.h"


// 最大输入字符数
static const NSInteger  KMaxInputCount = 500;
static const NSInteger  KImageMargin  = 10;

@interface PostViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,TTGTextTagCollectionViewDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *containView;

@property (nonatomic,strong) YSTextView *textView; // YYTextView

@property (nonatomic, strong) MASConstraint *imagesViewHeight;
@property (nonatomic,strong) UICollectionView *imageCollectionView;

@property (nonatomic,strong) UIView *tagView;
@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;
@property (nonatomic,strong) YYAnimatedImageView *topicImageView;
@property (nonatomic,strong) UILabel *topicLabel;

@property (nonatomic,strong) UIView *goodsView;
@property (nonatomic,strong) YYAnimatedImageView *itemImageView;
@property (nonatomic,strong) UILabel *itemsLabel;
@property (nonatomic,strong) MASConstraint *goodsViewHeight;
@property (nonatomic,strong) UICollectionView *goodsCollectionView;

@property (nonatomic,strong) NSMutableArray *tipArray;
@property (nonatomic, strong) PostViewModel *viewModel;
@property (nonatomic,strong) NSMutableArray *selectGoods;

@end

@implementation PostViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedPhotos = [NSMutableArray array];
        self.selectedAssets = [NSMutableArray array];
        self.isSelectOriginalPhoto = NO;
    }
    return self;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;

    self.tipArray = [NSMutableArray array];
    [self setupUIBarButtonItem];

    // 请求话题数据
    [self.viewModel requestTabObtainNetwork:nil completion:^(id obj) {
        ZFLog(@"标签个数 ： %ld",(unsigned long)[obj count]);
        
        [self setupSubViews];
        CGFloat height;
        if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
            height = self.selectedPhotos.count >= 4 ? 162 : 85;
        } else if (IPHONE_6X_4_7) {
            height = self.selectedPhotos.count >= 4 ? 192 : 101;
        } else if (IPHONE_6P_5_5) {
            height = self.selectedPhotos.count >= 4 ? 212 : 112;
        }
        self.imagesViewHeight.mas_equalTo(height);
        
        [self.tagCollectionView addTags:obj];
        [self.tagCollectionView setTagAtIndex:[obj indexOfObject:self.topic] selected:YES];
        [self.tagCollectionView reload];
        [self.view setNeedsLayout];
    } failure:^(id obj) {
        
    }];
}

- (void)setupUIBarButtonItem {
    UIImage *image = [UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"];
    
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [leftButton addTarget:self action:@selector(canclePost) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -5;
    self.navigationItem.leftBarButtonItems = @[spaceItem, item];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, 0, 83, 30);
    [rightBtn setFrame:frame];
    [rightBtn setTitle:ZFLocalizedString(@"Post_VC_Post",nil) forState:UIControlStateNormal];
    [rightBtn setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(postData:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightItem.width = -30;
    self.navigationItem.rightBarButtonItems = @[rightItem, buttonItem];
    
}

- (void)setupSubViews {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.scrollView addSubview:self.containView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    /******************************* 输入框 *******************************************/
    
    [self.containView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.containView);
        make.height.mas_equalTo(135);
    }];
    
    /******************************* 选择照片 ******************************************/
    [self.containView addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.leading.trailing.equalTo(self.containView);
//        self.imagesViewHeight = make.height.mas_equalTo(101);
        
        CGFloat height;
        if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
            height = 85;
        } else if (IPHONE_6X_4_7) {
            height = 101;
        } else if (IPHONE_6P_5_5) {
            height = 112;
        }
        self.imagesViewHeight = make.height.mas_equalTo(height);
    }];
        
    /******************************** 标签 ********************************************/
    
    [self.containView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageCollectionView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.containView);
    }];
    
    [self.tagView addSubview:self.topicImageView];
    [self.topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.tagView).offset(12);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.tagView addSubview:self.topicLabel];
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topicImageView.mas_trailing).offset(6);
        make.centerY.equalTo(self.topicImageView);
    }];
    
    [self.tagView addSubview:self.tagCollectionView];
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicImageView.mas_bottom).offset(12);
        make.leading.trailing.equalTo(self.tagView);
        make.bottom.equalTo(self.tagView.mas_bottom).offset(-12);
    }];
    
    /********************************* 关联商品 ********************************************/
    
    [self.containView addSubview:self.goodsView];
    [self.goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.containView);
    }];
    
    [self.goodsView addSubview:self.itemImageView];
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.goodsView).offset(12);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];

    [self.goodsView addSubview:self.itemsLabel];
    [self.itemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.itemImageView.mas_trailing).offset(6);
        make.centerY.equalTo(self.itemImageView);
    }];

    [self.goodsView addSubview:self.goodsCollectionView];
    [self.goodsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemImageView.mas_bottom).offset(12);
        make.leading.trailing.bottom.equalTo(self.goodsView);
        CGFloat height;
        if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
            height = 101;
        } else if (IPHONE_6X_4_7) {
            height = 140;
        } else if (IPHONE_6P_5_5) {
            height = 190;
        }
        self.goodsViewHeight = make.height.mas_equalTo(height);
    }];

    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsView.mas_bottom);
    }];
    
    
}

#pragma mark - UIBarButtonItem Action
- (void)canclePost{
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle: nil
                                           message:ZFLocalizedString(@"Post_VC_Post_Cancel_Message",nil)
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Post_VC_Post_Cancel_No",nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Post_VC_Post_Cancel_Yes",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[PostPhotosManager sharedManager] clearData];
            [[PostGoodsManager sharedManager] clearData];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)postData:(UIButton *)sender {
    
    if (self.selectedPhotos.count <= 0) {
        [self showAlertMessage:ZFLocalizedString(@"Post_VC_Post_NoPhotos_Tip",nil)];
        return;
    }

    if (self.tipArray && ![NSStringUtils isEmptyString:self.topic]) {
        [self.tipArray insertObject:self.topic atIndex:0];
    }

    NSArray *goods = [self.selectGoods valueForKeyPath:@"goodsID"];
    NSDictionary *dict = @{@"content" : [NSStringUtils isEmptyString:self.textView.text] ? @"" :self.textView.text,
                           @"goodsId" : [NSArrayUtils isEmptyArray:goods] ? @"" : [goods componentsJoinedByString:@","],
                           @"images"  : [self uploadImages],
                           @"topic"   : [NSArrayUtils isEmptyArray:self.tipArray] ? @[] :  self.tipArray};
    
    [self.viewModel requestPostNetwork:dict completion:^(id obj) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshPopularNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTopicNotification object:nil];
            NSString *msg = (NSString *)obj;
            [[NSNotificationCenter defaultCenter] postNotificationName:kCommunityPostSuccessNotification object:msg];
            [[PostPhotosManager sharedManager] clearData];
            [[PostGoodsManager sharedManager] clearData];
            [self.selectedPhotos removeAllObjects];
        }];
    } failure:^(id obj) {
        
    }];
}

#pragma mark - Image compress
- (NSArray *)uploadImages {
    NSMutableArray *imgArr = [NSMutableArray array];
    
    if ([self.selectedPhotos count]>0)
    {
        for (NSInteger i = 0; i<[self.selectedPhotos count]; i++)
        {
            UIImage *image = [self.selectedPhotos objectAtIndex:i];
            if (image.size.width != 640)
            {
                image = [self scaleImage:image toScale:640/image.size.width];
            }
            //图片压缩
            NSData* imageData = [self compressImageWithOriginImage:image];
            
            UIImage *temp = [UIImage imageWithData:imageData];
            [imgArr addObject:temp];
        }
    }
    
    return imgArr;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (NSData *)compressImageWithOriginImage:(UIImage *)originImg {
    NSData* imageData;
    float i = 1.0;
    do {
        imageData = UIImageJPEGRepresentation(originImg, i);
        i -= 0.1;
    } while (imageData.length > 2*1024*1024);
    
    return imageData;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (collectionView == _imageCollectionView) ? self.selectedPhotos.count + 1 : self.selectGoods.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _imageCollectionView)
    {
        PostPhotoCell *cell = [PostPhotoCell postPhotoCellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.isNeedHiddenAddView = indexPath.row == 6 ? YES : NO;
        cell.photo = (indexPath.row == self.selectedPhotos.count) ? [UIImage imageNamed:@"add_photo"] : self.selectedPhotos[indexPath.row];
        cell.deletePhotoBlock = ^(UIImage *photo){
            NSUInteger index = [self.selectedPhotos indexOfObject:photo];
            [self.selectedPhotos removeObjectAtIndex:index];
            [self.selectedAssets removeObjectAtIndex:index];
            [collectionView performBatchUpdates:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                NSMutableArray *newPhotos = [NSMutableArray arrayWithArray:self.selectedPhotos];
                self.selectedPhotos = newPhotos;
            } completion:^(BOOL finished) {
                if (finished) [collectionView reloadData];
                CGFloat height;
                if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                    height = self.selectedPhotos.count >= 4 ? 162 : 85;
                } else if (IPHONE_6X_4_7) {
                    height = self.selectedPhotos.count >= 4 ? 192 : 101;
                } else if (IPHONE_6P_5_5) {
                    height = self.selectedPhotos.count >= 4 ? 212 : 112;
                }
                self.imagesViewHeight.mas_equalTo(height);
            }];
        };
        return cell;
    }
    else
    {
        GoodsImageCell *cell = [GoodsImageCell goodsImageCellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.isNeedHiddenAddView = indexPath.row == 6 ? YES : NO;
        if (indexPath.row == self.selectGoods.count) {
            cell.goodsImage = [UIImage imageNamed:@"add_photo"];
        }else{
            cell.model = self.selectGoods[indexPath.row];
        }
        cell.deleteGoodBlock = ^(SelectGoodsModel *model) {
            NSUInteger index = [self.selectGoods indexOfObject:model];
            [self.selectGoods removeObject:model];
            
            if ([SystemConfigUtils isRightToLeftShow]) {
                self.itemsLabel.text = [NSString stringWithFormat:@"(%ld/6) %@",(unsigned long)self.selectGoods.count,ZFLocalizedString(@"Post_VC_Post_AddItems",nil)];
            } else {
                self.itemsLabel.text = [NSString stringWithFormat:@"%@ (%ld/6)",ZFLocalizedString(@"Post_VC_Post_AddItems",nil),(unsigned long)self.selectGoods.count];
            }
            
            [[PostGoodsManager sharedManager] removeGoodsWithModel:model];
            [collectionView performBatchUpdates:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                NSMutableArray *newGoods = [NSMutableArray arrayWithArray:self.selectGoods];
                self.selectGoods = newGoods;
            } completion:^(BOOL finished) {
                if (finished) [collectionView reloadData];
                CGFloat height;
                if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                    height = self.selectGoods.count >= 4 ? 162 : 85;
                } else if (IPHONE_6X_4_7) {
                    height = self.selectGoods.count >= 4 ? 192 : 101;
                } else if (IPHONE_6P_5_5) {
                    height = self.selectGoods.count >= 4 ? 212 : 112;
                }
                self.goodsViewHeight.mas_equalTo(height);
            }];
        };
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WIDTH - 5 * KImageMargin) / 4;
    return CGSizeMake(width,width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (collectionView == _imageCollectionView)
    {
        if (indexPath.item == self.selectedPhotos.count) {
            // 弹出照片选择器
            [self pushImagePickerController];
        } else {
            // 预览照片
        }
    }
    else
    {
        GoodsPageViewController *pageVC = [[GoodsPageViewController alloc] init];
        pageVC.title = ZFLocalizedString(@"Post_VC_Post_AddItems",nil);
        
        pageVC.doneBlock = ^(NSMutableArray *selectArray){
            @strongify(self)
            self.selectGoods = selectArray;

            if ([SystemConfigUtils isRightToLeftShow]) {
                self.itemsLabel.text = [NSString stringWithFormat:@"(%ld/6) %@",(unsigned long)selectArray.count,ZFLocalizedString(@"Post_VC_Post_AddItems",nil)];
            } else {
                self.itemsLabel.text = [NSString stringWithFormat:@"%@ (%ld/6)",ZFLocalizedString(@"Post_VC_Post_AddItems",nil),(unsigned long)selectArray.count];
            }
            
            [self.goodsCollectionView reloadData];
            CGFloat height;
            if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                height = self.selectGoods.count >= 4 ? 162 : 85;
            } else if (IPHONE_6X_4_7) {
                height = self.selectGoods.count >= 4 ? 192 : 101;
            } else if (IPHONE_6P_5_5) {
                height = self.selectGoods.count >= 4 ? 212 : 112;
            }
            self.goodsViewHeight.mas_equalTo(height);
        };
        [self.navigationController pushViewController:pageVC animated:YES];
    }
    
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    if (selected) {
        [self.tipArray addObject:tagText];
    } else {
        [self.tipArray removeObject:tagText];
    }
}

- (void)showMaxSelectTagsMessage {
    [self showAlertMessage:ZFLocalizedString(@"Post_VC_Post_MaxTag_Tip",nil)];
}


#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    TZImagePickerController *customImagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    customImagePickerController.isSelectOriginalPhoto = YES;
    // 1.设置目前已经选中的图片数组
    customImagePickerController.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
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
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    //页面刷新
    CGFloat height;
    if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
        height = self.selectedPhotos.count >= 4 ? 162 : 85;
    } else if (IPHONE_6X_4_7) {
        height = self.selectedPhotos.count >= 4 ? 192 : 101;

    } else if (IPHONE_6P_5_5) {
        height = self.selectedPhotos.count >= 4 ? 212 : 112;
    }
    
    self.imagesViewHeight.mas_equalTo(height);
    [self.imageCollectionView reloadData];
}

//#pragma mark - YYTextView
//- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    //if ([textView.text isEqualToString:self.topic] && [NSStringUtils isEmptyString:text]) {
//        //return NO;
//    //}
//
//    if (textView.text.length >= KMaxInputCount && text.length > range.length) {
//        [self showAlertMessage:@"Must be under 500 characters."];
//        return NO;
//    }
//    return YES;
//}

#pragma mark - YSTextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length >= KMaxInputCount && text.length > range.length) {
        [self showAlertMessage:ZFLocalizedString(@"Post_VC_Post_TextView_Tip",nil)];
        return NO;
    }
    return YES;
}

#pragma mark - UIAlertController 
- (void)showAlertMessage:(NSString *)message {
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle: nil
                                           message:message
                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Post_VC_Post_Alert_OK",nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Setter/Getter
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

-(UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = ZFCOLOR(245, 245, 245, 1);
    }
    return _containView;
}

-(YSTextView *)textView {
    if (!_textView) {
        _textView = [[YSTextView alloc] init];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor blackColor];
        _textView.placeholderFont = [UIFont systemFontOfSize:14];
        _textView.placeholder = ZFLocalizedString(@"Post_VC_Post_TextView_Placeholder",nil);
        _textView.placeholderColor = ZFCOLOR(153, 153, 153, 1.0);
        _textView.placeholderPoint = CGPointMake(10, 8.3);
        _textView.textContainerInset = UIEdgeInsetsMake(8.3, 7, 0, 0);
        if ([SystemConfigUtils isRightToLeftShow]) {
            _textView.textAlignment = NSTextAlignmentRight;
        } else {
            _textView.textAlignment = NSTextAlignmentLeft;
        }
    }
    return _textView;
}

-(UICollectionView *)imageCollectionView {
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageCollectionView.scrollEnabled = NO;
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.alwaysBounceVertical = YES;
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        _imageCollectionView.tag = 100;
        [_imageCollectionView registerClass:[PostPhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([PostPhotoCell class])];
        
    }
    return _imageCollectionView;
}

-(UIView *)tagView {
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
    }
    return _tagView;
}

-(TTGTextTagCollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        _tagCollectionView = [[TTGTextTagCollectionView alloc] init];
        _tagCollectionView.tagTextFont = [UIFont systemFontOfSize:14.0f];
        
        _tagCollectionView.tagTextColor = ZFCOLOR(102, 102, 102, 1);
        _tagCollectionView.tagSelectedTextColor = ZFCOLOR(255, 168, 0, 1);
        
        _tagCollectionView.tagBackgroundColor = [UIColor whiteColor];
        _tagCollectionView.tagSelectedBackgroundColor = [UIColor whiteColor];
        
        _tagCollectionView.horizontalSpacing = 12.0;
        _tagCollectionView.verticalSpacing = 12.0;
        
        _tagCollectionView.tagBorderColor = ZFCOLOR(221, 221, 221, 1);
        _tagCollectionView.tagSelectedBorderColor = ZFCOLOR(255, 168, 0, 1);
        _tagCollectionView.tagBorderWidth = 2;
        _tagCollectionView.tagSelectedBorderWidth = 2;
        
        _tagCollectionView.tagCornerRadius = 2;
        _tagCollectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _tagCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _tagCollectionView.delegate = self;
    }
    return _tagCollectionView;
}

-(YYAnimatedImageView *)topicImageView {
    if (!_topicImageView) {
        _topicImageView = [[YYAnimatedImageView alloc] init];
        _topicImageView.image = [UIImage imageNamed:@"topic"];
    }
    return _topicImageView;
}

-(UILabel *)topicLabel {
    if (!_topicLabel) {
        _topicLabel = [[UILabel alloc] init];
        _topicLabel.text = ZFLocalizedString(@"Post_VC_Post_AddTopics",nil);
        _topicLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _topicLabel.textAlignment = kCTTextAlignmentLeft;
        _topicLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _topicLabel;
}

-(UIView *)goodsView {
    if (!_goodsView) {
        _goodsView = [[UIView alloc] init];
        _goodsView.backgroundColor = [UIColor whiteColor];
    }
    return _goodsView;
}

-(YYAnimatedImageView *)itemImageView {
    if (!_itemImageView) {
        _itemImageView = [[YYAnimatedImageView alloc] init];
        _itemImageView.image = [UIImage imageNamed:@"items"];
    }
    return _itemImageView;
}

-(UILabel *)itemsLabel {
    if (!_itemsLabel) {
        _itemsLabel = [[UILabel alloc] init];
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            _itemsLabel.text = [NSString stringWithFormat:@"(0/6) %@",ZFLocalizedString(@"Post_VC_Post_AddItems",nil)];
        } else {
            _itemsLabel.text = [NSString stringWithFormat:@"%@ (0/6)",ZFLocalizedString(@"Post_VC_Post_AddItems",nil)];
        }
        
        
        _itemsLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _itemsLabel.textAlignment = kCTTextAlignmentLeft;
        _itemsLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _itemsLabel;
}

-(UICollectionView *)goodsCollectionView {
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _goodsCollectionView.scrollEnabled = NO;
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.alwaysBounceVertical = YES;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.tag = 200;
        [_goodsCollectionView registerClass:[GoodsImageCell class] forCellWithReuseIdentifier:NSStringFromClass([GoodsImageCell class])];
        
    }
    return _goodsCollectionView;
}

-(void)setSelectedPhotos:(NSMutableArray *)selectedPhotos {
    self.view.backgroundColor = [UIColor lightGrayColor];
    _selectedPhotos = selectedPhotos;
}

-(NSMutableArray *)selectGoods {
    if (!_selectGoods) {
        _selectGoods = [NSMutableArray array];
    }
    return _selectGoods;
}

-(PostViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PostViewModel alloc] init];
    }
    return _viewModel;
}

@end

//
//  WriteReviewViewController.m
//  Zaful
//
//  Created by DBP on 16/12/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "StarRatingControl.h"
#import "PlacehoderTextView.h"
#import "WriteReviewViewModel.h"
#import "OrderDetailGoodModel.h"
#import "TZImagePickerController.h"

@interface WriteReviewViewController ()<StarRatingDelegate,UITextViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *containerView;

//商品
@property (nonatomic, strong) YYAnimatedImageView *goodImg;

@property (nonatomic, strong) UILabel *goodName;

@property (nonatomic, strong) UILabel *goodSKULabel;

@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, strong) UILabel *goodsNumLabel;

@property (nonatomic, strong) UILabel *sizeLabel;

@property (nonatomic, strong) UILabel *subTotalLabel;

//评论
@property (nonatomic,weak) UIView *reviewView;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic,weak) StarRatingControl *starRating;//等级评分
@property (nonatomic, strong) UILabel *contentLabel;
// textView
@property (nonatomic, strong) PlacehoderTextView *reviewTextView;
// downView
@property (nonatomic, strong) UIView *downBackView;
@property (nonatomic, strong) UIView *pictureView;
@property (nonatomic, strong) UIButton *uploadPic;//上传图片
@property (nonatomic, assign) CGFloat rateCount;
@property (nonatomic, strong) UILabel *textCountLab;
@property (nonatomic, assign) BOOL isLimit;  // 限制文字输入
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) NSMutableArray *imagesArray;
// upView
@property (nonatomic, strong) UIView *upBackView;
@property (nonatomic, strong) UILabel *ratingNameLabel;
@property (nonatomic, strong) WriteReviewViewModel *viewModel;
@end

@implementation WriteReviewViewController
{
    CGFloat _padding;
}

typedef NS_ENUM(NSUInteger, ChoiceUploadType){
    ChoiceUploadTypePhoto= 0,
    ChoiceUploadTypeVideo
};
#pragma mark - Life Cycle
- (instancetype)init
{
    if (self = [super init]) {
        self.selectedPhotos = [NSMutableArray array];
        self.selectedAssets = [NSMutableArray array];
        self.isSelectOriginalPhoto = NO;
        _rateCount = 0;
    }
    return self;
}

- (NSMutableArray*)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ZFLocalizedString(@"WriteReview_VC_Title",nil);

    [self initSubViews];
    [self requestLoadData];
}

#pragma mark - MakeUI
- (void)initSubViews {
    
    __weak typeof(self.view) ws = self.view;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];;
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.userInteractionEnabled = YES;
    scrollerView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    [ws addSubview:scrollerView];
    
    [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.scrollerView = scrollerView;
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = ZFCOLOR_WHITE;
    [scrollerView addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollerView.mas_top).offset(10);
        make.height.mas_equalTo(180);
        make.width.mas_equalTo(scrollerView);
    }];
    self.containerView = containerView;
    
    YYAnimatedImageView *goodImg = [YYAnimatedImageView new];
    goodImg.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:goodImg];
    [goodImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(containerView.mas_leading).offset(10);
        make.top.mas_equalTo(containerView.mas_top).offset(20);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@(150));
    }];
    self.goodImg = goodImg;
    
    UILabel *goodName = [[UILabel alloc] init];
    goodName.textColor = ZFCOLOR(0, 0, 0, 1.0);
    goodName.numberOfLines = 2;
    goodName.font = [UIFont systemFontOfSize:14.0];
    
    [containerView addSubview:goodName];
    [goodName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodImg.mas_trailing).offset(10);
        make.trailing.mas_equalTo(containerView.mas_trailing).offset(-12);
        make.top.mas_equalTo(containerView.mas_top).offset(20);
    }];
    self.goodName = goodName;
    
    
    UILabel *subTotalLabel = [[UILabel alloc] init];
    subTotalLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
    subTotalLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [containerView addSubview:subTotalLabel];
    [subTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodName.mas_leading);
        make.bottom.mas_equalTo(self.goodImg.mas_bottom);
    }];
    self.subTotalLabel = subTotalLabel;
    
    
    UILabel *goodSKULabel = [[UILabel alloc] init];
    goodSKULabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
    goodSKULabel.font = [UIFont systemFontOfSize:14.0];
    [containerView addSubview:goodSKULabel];
    [goodSKULabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodName.mas_leading);
        make.width.mas_equalTo(self.goodName);
        make.top.mas_equalTo(self.goodName.mas_bottom).offset(8);
    }];
    self.goodSKULabel = goodSKULabel;
    
    
    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
    colorLabel.font = [UIFont systemFontOfSize:14.0];
    [containerView addSubview:colorLabel];
    [colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodName.mas_leading);
        make.width.mas_equalTo(self.goodName);
        make.top.mas_equalTo(self.goodSKULabel.mas_bottom).offset(8);
    }];
    self.colorLabel = colorLabel;
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
    sizeLabel.font = [UIFont systemFontOfSize:14.0];
    [containerView addSubview:sizeLabel];
    [sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodName.mas_leading);
        make.width.mas_equalTo(self.goodName);
        make.top.mas_equalTo(self.colorLabel.mas_bottom).offset(8);
    }];
    self.sizeLabel = sizeLabel;
    
    UILabel *goodsNumLabel = [[UILabel alloc] init];
    goodsNumLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
    goodsNumLabel.font = [UIFont systemFontOfSize:14.0];
    goodsNumLabel.textAlignment = NSTextAlignmentRight;
    
    [containerView addSubview:goodsNumLabel];
    [goodsNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.goodName.mas_trailing);
        make.centerY.mas_equalTo(self.subTotalLabel.mas_centerY);
    }];
    self.goodsNumLabel = goodsNumLabel;
    
    
    UIView *reviewView = [UIView new];
    reviewView.backgroundColor = ZFCOLOR_WHITE;
    reviewView.userInteractionEnabled = YES;
    [scrollerView addSubview:reviewView];
    
    [reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_bottom);
        make.leading.mas_equalTo(ws.mas_leading);
        make.width.mas_equalTo(scrollerView);
        make.bottom.mas_equalTo(scrollerView.mas_bottom);
        
    }];
    self.reviewView = reviewView;
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    noteLabel.font = [UIFont systemFontOfSize:14.0];
    noteLabel.numberOfLines = 3;
    noteLabel.text = ZFLocalizedString(@"WriteReview_Note",nil);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    
    [reviewView addSubview:noteLabel];
    [noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reviewView.mas_top);
        make.leading.mas_equalTo(reviewView.mas_leading).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    self.noteLabel = noteLabel;
    
    UILabel *ratingLabel = [[UILabel alloc] init];
    ratingLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    ratingLabel.font = [UIFont systemFontOfSize:12.0];
    NSMutableAttributedString *rating = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",ZFLocalizedString(@"WriteReview_Rating",nil)]];
    [rating addAttribute:NSForegroundColorAttributeName value:ZFCOLOR(255, 168, 0, 1.0)  range:NSMakeRange(0, 1)];
    ratingLabel.attributedText = rating;
    
   // ratingLabel.textAlignment = NSTextAlignmentLeft;
    [reviewView addSubview:ratingLabel];
    [ratingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteLabel.mas_bottom).offset(20);
        make.leading.mas_equalTo(reviewView.mas_leading).offset(10);
        make.width.mas_equalTo(100);
    }];
    self.ratingLabel = ratingLabel;
    
    
    StarRatingControl *starRating = [[StarRatingControl alloc] initWithFrame:CGRectZero andDefaultStarImage:[UIImage imageNamed:@"starNormal_review"] highlightedStar:[UIImage imageNamed:@"starheight_review"]];
    starRating.enabled = YES;
    starRating.delegate = self;
    starRating.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    starRating.rating = _rateCount;
    if ([SystemConfigUtils isRightToLeftShow]) {
        starRating.transform = CGAffineTransformMakeRotation(M_PI);
    }
    [reviewView addSubview:starRating];
    
    [starRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ratingLabel.mas_bottom).offset(12);
        make.leading.mas_equalTo(reviewView.mas_leading).offset(12);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(@130);
    }];
    self.starRating = starRating;
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    contentLabel.font = [UIFont systemFontOfSize:12.0];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",ZFLocalizedString(@"WriteReview_Content",nil)]];
    [content addAttribute:NSForegroundColorAttributeName value:ZFCOLOR(255, 168, 0, 1.0)  range:NSMakeRange(0, 1)];
    contentLabel.attributedText = content;
   // contentLabel.textAlignment = NSTextAlignmentLeft;
    [reviewView addSubview:contentLabel];
    [contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(starRating.mas_bottom).offset(12);
        make.leading.mas_equalTo(reviewView.mas_leading).offset(10);
        make.width.mas_equalTo(100);
    }];
    self.contentLabel = contentLabel;
    
    PlacehoderTextView *reviewTextView = [[PlacehoderTextView alloc] init];
    reviewTextView.placeholder = ZFLocalizedString(@"WriteReview_Textfiled_Placeholder",nil);
    reviewTextView.layer.borderWidth = MIN_PIXEL;
    reviewTextView.layer.borderColor = [ZFCOLOR(170, 170, 170, 1.0) CGColor];
    reviewTextView.editable = YES;
    reviewTextView.font = [UIFont systemFontOfSize:12];
    reviewTextView.delegate = self;
    if ([SystemConfigUtils isRightToLeftShow]) {
        reviewTextView.textAlignment = NSTextAlignmentRight;
    } else {
        reviewTextView.textAlignment = NSTextAlignmentLeft;
    }
    reviewTextView.textContainerInset =  UIEdgeInsetsMake(10, 15, 0, 10);  // 改变文字编辑的位置
    [reviewView addSubview:reviewTextView];
    [reviewTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(12);
        make.leading.mas_equalTo(reviewView.mas_leading).offset(10);
        make.trailing.mas_equalTo(reviewView.mas_trailing).offset(-10);
        make.height.mas_equalTo(@185);
    }];
    self.reviewTextView = reviewTextView;
    
    UILabel *textCountLab = [[UILabel alloc] init];
    textCountLab.text = @"0/3000";
    textCountLab.font = [UIFont systemFontOfSize:12];
    textCountLab.textColor = ZFCOLOR_BLACK;
    [reviewView addSubview:textCountLab];
    [textCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.reviewTextView.mas_trailing).offset(-10);
        make.bottom.mas_equalTo(self.reviewTextView.mas_bottom).offset(-10);
    }];
    
    self.textCountLab = textCountLab;
    
    UIView *downBackView = [[UIView alloc] init];
    downBackView.backgroundColor = [UIColor whiteColor];
    [reviewView addSubview:downBackView];
    [downBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reviewTextView.mas_bottom).offset(20);
        make.leading.trailing.mas_equalTo(reviewView);
    }];
    self.downBackView = downBackView;
    
    UIView *pictureView = [[UIView alloc] init];
    [downBackView addSubview:pictureView];
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(downBackView.mas_leading);
        make.top.mas_equalTo(downBackView.mas_top);
        make.bottom.mas_equalTo(downBackView.mas_bottom);
    }];
    self.pictureView = pictureView;
    
    UIButton *uploadPic = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadPic addTarget:self action:@selector(selectPicture:) forControlEvents:UIControlEventTouchUpInside];
    [uploadPic setImage:[UIImage imageNamed:@"camera_review"] forState:UIControlStateNormal];
    uploadPic.layer.masksToBounds = YES;
    uploadPic.layer.borderWidth = 1;
    uploadPic.layer.borderColor = ZFCOLOR(221, 221, 221, 1.0).CGColor;
    [downBackView addSubview:uploadPic];
    
    [uploadPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.pictureView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.downBackView.mas_top).offset(10);
        make.bottom.mas_equalTo(self.downBackView.mas_bottom).offset(-10);
        if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
            make.width.height.mas_equalTo(90);
        }else{
            make.width.height.mas_equalTo(115);
        }
    }];
    self.uploadPic = uploadPic;
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:ZFLocalizedString(@"WriteReview_Submit",nil) forState:UIControlStateNormal];
    submitButton.backgroundColor = ZFCOLOR_BLACK;
    [submitButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [reviewView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.downBackView.mas_bottom).offset(20);
        make.leading.trailing.mas_equalTo(reviewView);
        make.height.mas_equalTo(@56);
        //make.bottom.mas_equalTo(reviewView.mas_bottom);
        make.bottom.mas_equalTo(scrollerView.mas_bottom);
    }];
}

- (void)submitAction:(id)sender {
    if (_reviewTextView.text.length < 30) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"WriteReview_Textfiled_Min_Tip",nil)];
        return;
    }else if (_reviewTextView.text.length > 3000) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"WriteReview_Textfiled_Max_Tip",nil)];
        return;
    }

    if (_rateCount == 0) {
        [self.starRating setStar:[UIImage imageNamed:@"starBorder_review"] highlightedStar:[UIImage imageNamed:@"starheight_review"]];
        return;
    }

    

    NSDictionary *dict = @{
                           @"title": @"",
                           @"goods_id":self.goodsModel.goods_id,
                           @"content": self.reviewTextView.text,
                           @"rate_overall": @(self.starRating.rating),
                           @"order_id": self.orderid,
                           @"images" :[self uploadImages]
                           };
    @weakify(self)
    [self.viewModel requestNetwork:dict completion:^(id obj) {
      @strongify(self)
        if (obj)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                // 刷新订单详情页面
                if (_blockSuccess) {
                    _blockSuccess();  
                }
            });
            
        }
    } failure:^(id obj) {
        
    }];
}

- (WriteReviewViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WriteReviewViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

#pragma mark - Method
- (void)requestLoadData
{
    [self updateSubviewsWithCheckReviewModel:nil];
}

- (void)updateSubviewsWithCheckReviewModel:(OrderDetailGoodModel *)models {
    
    [self.goodImg yy_setImageWithURL:[NSURL URLWithString:self.goodsModel.goods_grid] processorKey:NSStringFromClass([self class]) placeholder:[UIImage imageNamed:@"loading_cat_list"]];
    
    self.goodName.text = self.goodsModel.goods_title;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.goodSKULabel.text = [NSString stringWithFormat:@"%@:%@",self.goodsModel.goods_sn,ZFLocalizedString(@"WriteReview_Sku",nil)];
        
        self.colorLabel.text = [NSString stringWithFormat:@"%@:%@",self.goodsModel.attr_color == nil ? @"" :self.goodsModel.attr_color,ZFLocalizedString(@"WriteReview_Color",nil)];
        
        self.sizeLabel.text = [NSString stringWithFormat:@"%@:%@",self.goodsModel.attr_size == nil ? @"" :self.goodsModel.attr_size,ZFLocalizedString(@"WriteReview_Size",nil)];
        
        self.goodsNumLabel.text = [NSString stringWithFormat:@"%@X",self.goodsModel.goods_number];
        
        self.subTotalLabel.text = [NSString stringWithFormat:@"%@%@ :%@",self.goodsModel.order_currency,self.goodsModel.goods_price,ZFLocalizedString(@"WriteReview_Total",nil)];
    } else {
        self.goodSKULabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"WriteReview_Sku",nil),self.goodsModel.goods_sn];
        
        self.colorLabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"WriteReview_Color",nil),self.goodsModel.attr_color == nil ? @"" :self.goodsModel.attr_color];
        
        self.sizeLabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"WriteReview_Size",nil),self.goodsModel.attr_size == nil ? @"" :self.goodsModel.attr_size];
        
        self.goodsNumLabel.text = [NSString stringWithFormat:@"X%@",self.goodsModel.goods_number];
        
        self.subTotalLabel.text = [NSString stringWithFormat:@"%@: %@%@",ZFLocalizedString(@"WriteReview_Total",nil),self.goodsModel.order_currency,self.goodsModel.goods_price];
    }
    
    
    
    CGSize textSize = [self.goodName.text  boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.goodName.font} context:nil].size;
    
    CGFloat goodNameWidth = SCREEN_WIDTH - 12 * 3 - 100;
    
    if (textSize.width > goodNameWidth) { //text的宽度少于Label的宽度就是为1行,不然为多行
        _padding = 10;
    }else{
        _padding = 15;
    }
    
    [self.goodSKULabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodName.mas_bottom).offset(_padding);
    }];
    
    [self.colorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodSKULabel.mas_bottom).offset(_padding);
    }];
    
    [self.sizeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorLabel.mas_bottom).offset(_padding);
    }];
    
}

#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView.text.length>2999) {
        if ([text isEqualToString:@""])
        {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.textCountLab.text = [NSString stringWithFormat:@"%ld/3000", (unsigned long)self.reviewTextView.text.length];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 判断是否开启相机
- (void)selectPicture:(UIButton *)sender {
    // 弹出照片选择器
    [self pushImagePickerController];
}


#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    TZImagePickerController *customImagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
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
    customImagePickerController.maxImagesCount = 3;
    [self presentViewController:customImagePickerController animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController  *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.imagesArray removeAllObjects];
    [self.pictureView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {}];
            [obj removeFromSuperview];
        }
    }];
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    //页面刷新
    [self.selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YYAnimatedImageView *imageView = [self buildCustomImageView:obj show:YES];
        [self.imagesArray addObject:imageView];
        [self.pictureView addSubview:imageView];
    }];
    [self layoutPhotos];
}

#pragma mark - 为选择的照片重新布局
- (void)layoutPhotos {
    if (self.imagesArray.count == 3) {
        self.uploadPic.hidden = YES;
    }else {
        self.uploadPic.hidden = NO;
    }
    if (self.imagesArray.count > 1) {
        [self.imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //这里是重新设置每一个imageView的tag值，为了方便删除数据
            if ([obj isKindOfClass:[YYAnimatedImageView class]]) {
                [obj setValue:@(idx) forKey:@"tag"];
            }
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        }];
        [self.imagesArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:8 tailSpacing:0];
        [self.imagesArray mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.pictureView.mas_centerY);
            make.top.mas_equalTo(self.pictureView.mas_top).offset(10);
            make.bottom.mas_equalTo(self.pictureView.mas_bottom).offset(-10);
            if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                make.width.height.mas_equalTo(90);
            }else{
                make.width.height.mas_equalTo(115);
            }
        }];
        [self.pictureView layoutIfNeeded];
    } else if (self.imagesArray.count == 1) {
        [[self.imagesArray firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(self.pictureView).offset(10);
            make.bottom.mas_equalTo(self.pictureView.mas_bottom).offset(-10);
            make.trailing.mas_equalTo(self.pictureView.mas_trailing);
            if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                make.width.height.mas_equalTo(90);
            }else{
                make.width.height.mas_equalTo(115);
            }
        }];
    }
}

#pragma mark -- 删除图片或者视频 右上角删除
- (YYAnimatedImageView *)buildCustomImageView:(UIImage *)image show:(BOOL)show {
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setImage:[UIImage imageNamed:@"delet"] forState:UIControlStateNormal];
    [imageView addSubview:delBtn];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_top);
        make.trailing.mas_equalTo(imageView.mas_trailing);
        make.width.height.mas_equalTo(16);
    }];
    if (show) {
        [delBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return imageView;
}

#pragma mark - Image compress
- (NSArray *)uploadImages {
    NSMutableArray *imgArr = [NSMutableArray array];
    
    if ([self.imagesArray count] > 0)
    {
        for (NSInteger i = 0; i < [self.imagesArray count]; i++)
        {
            UIImage *image = [[self.imagesArray objectAtIndex:i] valueForKey:@"image"];
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


#pragma mark - 删除图片
- (void)deleteImageView:(UIButton *)sender {
    YYAnimatedImageView *imageView = (YYAnimatedImageView *)[sender superview];
    NSUInteger index = [self.selectedPhotos indexOfObject:imageView.image];
    [self.selectedPhotos removeObjectAtIndex:index];
    [self.selectedAssets removeObjectAtIndex:index];
    [self.imagesArray removeObject:imageView];
    [imageView removeFromSuperview];
    [self layoutPhotos];
}


#pragma mark Delegate implementation of NIB instatiated DLStarRatingControl
-(void)newRating:(StarRatingControl *)control :(float)rating {
    ZFLog(@"%@",[NSString stringWithFormat:@"%0.1f star rating",rating]);
    _rateCount = rating;
}



@end

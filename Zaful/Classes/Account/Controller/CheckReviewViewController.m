//
//  CheckReviewViewController.m
//  Zaful
//
//  Created by DBP on 16/12/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CheckReviewViewController.h"
#import "StarRatingControl.h"
#import "CheckReviewViewModel.h"
#import "CheckReviewModel.h"
#import "YYPhotoBrowseView.h"
#import "ZFGoodsDetailViewController.h"

@interface CheckReviewViewController ()

@property (nonatomic,weak) UIScrollView *bottomView;
@property (nonatomic,weak) UIView *containerView;
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
@property (nonatomic,weak) StarRatingControl *starRating;//等级评分
@property (nonatomic,weak) UILabel *addTime;//添加时间
@property (nonatomic,weak) UILabel *userFeedback;//用户反馈
@property (nonatomic,weak) UIView *pictureView;//用户上传图片

@property (nonatomic,strong) NSMutableArray *pictureArray;

@property (nonatomic,strong) MASConstraint *pictureHight;//根据用户是否有上传图片更新约束高度
@property (nonatomic,strong) MASConstraint *pictureWidth;

@property (nonatomic, strong) CheckReviewViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation CheckReviewViewController
{
    CGFloat _padding;
}

- (NSMutableArray*)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (NSMutableArray*)pictureArray {
    if (!_pictureArray) {
        _pictureArray = [[NSMutableArray alloc] init];
    }
    return _pictureArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ZFLocalizedString(@"CheckMyReview_VC_Title",nil);
    [self initView];
    [self requestLoadData];
}

- (void)initView {
    __weak typeof(self.view) ws = self.view;
    
    UIScrollView *bottomView = [[UIScrollView alloc] initWithFrame:CGRectZero];;
    bottomView.showsVerticalScrollIndicator = NO;
    bottomView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    [ws addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    self.bottomView = bottomView;
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = ZFCOLOR_WHITE;
    [bottomView addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(10);
        make.height.mas_equalTo(180);
        make.width.mas_equalTo(bottomView);
    }];
    self.containerView = containerView;
    
    
    YYAnimatedImageView *goodImg = [YYAnimatedImageView new];
    goodImg.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:goodImg];
    [goodImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(10);
        make.top.offset(20);
        make.width.equalTo(@100);
        make.height.equalTo(@(150));
    }];
    self.goodImg = goodImg;
    
    UILabel *goodName = [[UILabel alloc] init];
    goodName.textColor = ZFCOLOR(0, 0, 0, 1.0);
    goodName.numberOfLines = 2;
    goodName.font = [UIFont systemFontOfSize:14.0];
    
    [containerView addSubview:goodName];
    [goodName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodImg.mas_trailing).offset(10);
        make.trailing.offset(-12);
        make.top.offset(20);
    }];
    self.goodName = goodName;
    
    
    UILabel *subTotalLabel = [[UILabel alloc] init];
    subTotalLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
    subTotalLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [containerView addSubview:subTotalLabel];
    [subTotalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.bottom.equalTo(self.goodImg.mas_bottom).offset(0);
    }];
    self.subTotalLabel = subTotalLabel;
    
    
    UILabel *goodSKULabel = [[UILabel alloc] init];
    goodSKULabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
    goodSKULabel.font = [UIFont systemFontOfSize:14.0];
    [containerView addSubview:goodSKULabel];
    [goodSKULabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.width.equalTo(self.goodName);
        make.top.equalTo(self.goodName.mas_bottom).offset(8);
    }];
    self.goodSKULabel = goodSKULabel;
    
    
    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
    colorLabel.font = [UIFont systemFontOfSize:14.0];
    [containerView addSubview:colorLabel];
    [colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.width.equalTo(self.goodName);
        make.top.equalTo(self.goodSKULabel.mas_bottom).offset(8);
    }];
    self.colorLabel = colorLabel;
    
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
    sizeLabel.font = [UIFont systemFontOfSize:14.0];
    [containerView addSubview:sizeLabel];
    [sizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodName);
        make.width.equalTo(self.goodName);
        make.top.equalTo(self.colorLabel.mas_bottom).offset(8);
    }];
    self.sizeLabel = sizeLabel;
    
    UILabel *goodsNumLabel = [[UILabel alloc] init];
    goodsNumLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
    goodsNumLabel.font = [UIFont systemFontOfSize:14.0];
    goodsNumLabel.textAlignment = NSTextAlignmentRight;
    
    [containerView addSubview:goodsNumLabel];
    [goodsNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.goodName);
        make.centerY.equalTo(self.subTotalLabel);
    }];
    self.goodsNumLabel = goodsNumLabel;
    
    
    UIView *reviewView = [UIView new];
    reviewView.backgroundColor = ZFCOLOR_WHITE;
    [bottomView addSubview:reviewView];
    
    [reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_bottom);
        make.width.mas_equalTo(bottomView);
        make.bottom.mas_equalTo(bottomView.mas_bottom);
        
    }];
    self.reviewView = reviewView;
    
    
    StarRatingControl *starRating = [[StarRatingControl alloc] initWithFrame:CGRectZero andDefaultStarImage:[UIImage imageNamed:@"starNormal"] highlightedStar:[UIImage imageNamed:@"starHigh"]];
    starRating.enabled = NO;
    if ([SystemConfigUtils isRightToLeftShow]) {
        starRating.transform = CGAffineTransformMakeRotation(M_PI);
    }
    starRating.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    starRating.rating = 4;
    [reviewView addSubview:starRating];
    
    [starRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reviewView.mas_top).offset(10);
        make.leading.offset(12);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(@100);
    }];
    self.starRating = starRating;
    
    
    //评论内容
    UILabel *userFeedback = [UILabel new];
    userFeedback.font = [UIFont fontWithName:FONT_HIGHT size:12];
    userFeedback.textColor = ZFCOLOR(102, 102, 102, 1.0);
    userFeedback.numberOfLines = 0;
    [reviewView addSubview:userFeedback];
    
    [userFeedback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(starRating.mas_bottom).offset(15);
        make.leading.mas_equalTo(starRating.mas_leading);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    self.userFeedback = userFeedback;
    
    UILabel *addTime  = [UILabel new];
    addTime.font = [UIFont systemFontOfSize:12];
    addTime.textColor = ZFCOLOR(170, 170, 170, 1.0);
    [reviewView addSubview:addTime];
    
    [addTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userFeedback.mas_bottom).offset(15);
        make.leading.mas_equalTo(userFeedback.mas_leading);
        make.height.mas_equalTo(20);
    }];
    self.addTime = addTime;
    
    UIView *pictureView = [UIView new];
    [reviewView addSubview:pictureView];
    
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addTime.mas_bottom).offset(14);
        make.leading.mas_equalTo(addTime.mas_leading);
        make.bottom.mas_equalTo(reviewView.mas_bottom).offset(-20);
        self.pictureHight = make.height.mas_equalTo(@0);
    }];
    self.pictureView = pictureView;
    
}

#pragma mark - Method
- (void)extracted:(NSDictionary *)dict weak_self:(CheckReviewViewController *const __weak)weak_self {
    [self.viewModel requestNetwork:dict completion:^(id obj) {
        @strongify(self)
        if ([obj[@"status"] boolValue])
        {
            CheckReviewModel *model = obj[@"model"];
            [self updateSubviewsWithCheckReviewModel:model];
        }
        
        
    } failure:^(id obj) {
        
    }];
}

- (void)requestLoadData
{
    NSDictionary *dict = @{
                           @"goods_id":self.goodsModel.goods_id,
                           @"order_id": self.orderid
                           
                           };
    @weakify(self)
    [self extracted:dict weak_self:weak_self];
}

- (void)updateSubviewsWithCheckReviewModel:(CheckReviewModel *)model {
    
    //商品详情
    [self.goodImg yy_setImageWithURL:[NSURL URLWithString:self.goodsModel.goods_grid] processorKey:NSStringFromClass([self class]) placeholder:[UIImage imageNamed:@"loading_cat_list"]];
    
    self.goodName.text = self.goodsModel.goods_title;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.goodSKULabel.text = [NSString stringWithFormat:@"%@:%@",self.goodsModel.goods_sn,ZFLocalizedString(@"CheckMyReview_Sku",nil)];
        
        self.colorLabel.text = [NSString stringWithFormat:@"%@:%@",self.goodsModel.attr_color == nil ? @"" :self.goodsModel.attr_color,ZFLocalizedString(@"CheckMyReview_Color",nil)];
        
        self.sizeLabel.text = [NSString stringWithFormat:@"%@:%@",self.goodsModel.attr_size == nil ? @"" :self.goodsModel.attr_size,ZFLocalizedString(@"CheckMyReview_Size",nil)];
        
        self.goodsNumLabel.text = [NSString stringWithFormat:@"%@X",self.goodsModel.goods_number];
        
        self.subTotalLabel.text = [NSString stringWithFormat:@"%@%@ :%@",self.goodsModel.order_currency,self.goodsModel.goods_price,ZFLocalizedString(@"CheckMyReview_Total",nil)];
    } else {
        self.goodSKULabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"CheckMyReview_Sku",nil),self.goodsModel.goods_sn];
        
        self.colorLabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"CheckMyReview_Color",nil),self.goodsModel.attr_color == nil ? @"" :self.goodsModel.attr_color];
        
        self.sizeLabel.text = [NSString stringWithFormat:@"%@:%@",ZFLocalizedString(@"CheckMyReview_Size",nil),self.goodsModel.attr_size == nil ? @"" :self.goodsModel.attr_size];
        
        self.goodsNumLabel.text = [NSString stringWithFormat:@"X%@",self.goodsModel.goods_number];
        
        self.subTotalLabel.text = [NSString stringWithFormat:@"%@: %@%@",ZFLocalizedString(@"CheckMyReview_Total",nil),self.goodsModel.order_currency,self.goodsModel.goods_price];
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
    
    //回复内容
    self.userFeedback.text = model.content;
    //评价星级
    self.starRating.rating = [model.rate_overall floatValue];
    
    //回复时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM.dd,yyyy  HH:mm:ss aa"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.add_time integerValue]]];
    NSMutableString* newStr= [[NSMutableString alloc]initWithString:currentDateStr];
    [newStr insertString:@"at"atIndex:12];
      self.addTime.text = newStr;
    
     [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleDetailTapAction:)]];
    
    if (![NSArrayUtils isEmptyArray:model.reviewPic]) {
        if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
             self.pictureHight.mas_equalTo(90);
        }else{
             self.pictureHight.mas_equalTo(115);
        }

        if (model.reviewPic.count == 1) {
            NSString *img = [[model.reviewPic firstObject] valueForKey:@"origin_pic"];
            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.tag = 0;
           
            [imageView yy_setImageWithURL:[NSURL URLWithString:img]
                             processorKey:NSStringFromClass([self class])
                              placeholder:nil
                                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 }
                                transform:^UIImage *(UIImage *image, NSURL *url) {
                                    
                                    return image;
                                }
                               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                   if (from == YYWebImageFromDiskCache) {
                                   }
                               }];

            imageView.userInteractionEnabled = YES;
            self.pictureView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)]];

            [self.pictureView addSubview:imageView];
            [self.pictureArray addObject:imageView];
            
    
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.pictureView.mas_top);
                make.bottom.mas_equalTo(self.pictureView.mas_bottom);
                make.leading.mas_equalTo(self.pictureView.mas_leading);
                make.trailing.mas_equalTo(self.pictureView.mas_trailing);
                if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                    make.width.height.mas_equalTo(90);
                }else{
                    make.width.height.mas_equalTo(115);
                }
            }];
            
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView = imageView;
            NSURL *url = [NSURL URLWithString:img];
            item.largeImageURL = url;
            [self.items addObject:item];
            
        }else {
            [model.reviewPic enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
                imageView.layer.borderWidth = 0.5;
                imageView.layer.borderColor = ZFCOLOR(241, 241, 241, 1.0).CGColor;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;

                imageView.tag = idx;
                
                NSString *img = [[model.reviewPic objectAtIndex:idx] valueForKey:@"origin_pic"];
                [imageView yy_setImageWithURL:[NSURL URLWithString:img]
                                 processorKey:NSStringFromClass([self class])
                                  placeholder:nil
                                      options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     }
                                    transform:^UIImage *(UIImage *image, NSURL *url) {
                                        return image;
                                    }
                                   completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                       if (from == YYWebImageFromDiskCache) {
                                       }
                                   }];

                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)]];
                [self.pictureView addSubview:imageView];
                [self.pictureArray addObject:imageView];

                YYPhotoGroupItem *item = [YYPhotoGroupItem new];
                item.thumbView = imageView;
                NSURL *url = [NSURL URLWithString:img];
                item.largeImageURL = url;
                [self.items addObject:item];
            }];
            [self.pictureArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
            [self.pictureArray mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.pictureView.mas_top);
                make.bottom.mas_equalTo(self.pictureView.mas_bottom);
                if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                    make.width.height.mas_equalTo(90);
                }else{
                    make.width.height.mas_equalTo(115);
                }
            }];
        }
    }else {
        self.pictureHight.mas_equalTo(@0);
    }
}

- (void)singleDetailTapAction:(UITapGestureRecognizer *)gesture {
    
    ZFGoodsDetailViewController *goodDetailVC = [[ZFGoodsDetailViewController alloc] init];
    
    goodDetailVC.goodsId = self.goodsModel.goods_id;
    
    [self.navigationController pushViewController:goodDetailVC animated:YES];
}
- (void)singleTapAction:(UITapGestureRecognizer *)gesture {
    //具体的实现
    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc] initWithGroupItems:self.items];
    [groupView presentFromImageView:self.pictureArray[gesture.view.tag] toContainer:self.view animated:YES completion:nil];
}

- (CheckReviewViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CheckReviewViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}


@end

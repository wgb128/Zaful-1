//
//  DropDownMenu.m
//  ListPageViewController
//
//  Created by TsangFa on 2/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryDropDownMenu.h"

@interface CategoryDropDownMenu ()
@property (nonatomic, assign) NSInteger         numOfMenu;
@property (nonatomic, strong) NSArray           *indicatorArray;
@property (nonatomic, strong) CALayer           *topLine;
@property (nonatomic, strong) CALayer           *bottomLine;
@property (nonatomic, strong) CAGradientLayer   *spaceLine;
@property (nonatomic, assign) NSInteger         currentTapIndex;
@property (nonatomic, assign) BOOL              isSelect;
@end

@implementation CategoryDropDownMenu
#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        [self configureSubViews];
        [self autoLayoutSubViews];
        self.currentTapIndex = -1; // 默认值
        self.isSelect = NO;
    }
    return self;
}

#pragma mark - Initialize
- (void)configureSubViews {
    self.backgroundColor = [UIColor whiteColor];
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
    [self addGestureRecognizer:tapGesture];
    [self.layer addSublayer:self.topLine];
    [self.layer addSublayer:self.bottomLine];
}

- (void)autoLayoutSubViews {
    self.topLine.frame = CGRectMake(0, 0 ,KScreenWidth, KLineHeight);
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - KLineHeight , KScreenWidth, KLineHeight);
}

#pragma mark - Gesture Handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    if (_isDropAnimation) {
        return ;
    }
    _isDropAnimation = YES;
    CGPoint touchPoint = [paramSender locationInView:self];
    // 获取下标
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / self.numOfMenu);
    
    for (int i = 0; i < self.indicatorArray.count; i++) {
        if (i != tapIndex) {
            [self animateIndicator:self.indicatorArray[i] Forward:NO complete:^{}];
        }
    }

    self.isSelect = (tapIndex == self.currentTapIndex && self.isSelect) ? NO : YES;
    
    [self animateIndicator:self.indicatorArray[tapIndex] Forward:self.isSelect complete:^{
        self.currentTapIndex = tapIndex;
        if (self.chooseCompletionHandler) {
            self.chooseCompletionHandler(tapIndex,self.isSelect);
        }
    }];
    

}

- (void)animateIndicatorWithIndex:(NSInteger)index {
    [self animateIndicator:self.indicatorArray[index] Forward:NO complete:^{}];
    self.isSelect = (index == self.currentTapIndex && self.isSelect) ? NO : YES;
    
    [self animateIndicator:self.indicatorArray[index] Forward:self.isSelect complete:^{
        self.currentTapIndex = index;
        if (self.chooseCompletionHandler) {
            self.chooseCompletionHandler(index,self.isSelect);
        }
    }];
}

#pragma mark - Setter
- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    self.numOfMenu = titles.count;
    
    NSInteger numOfMenu = self.numOfMenu > 0 ? self.numOfMenu : 1;
    CGFloat textLayerInterval = self.frame.size.width / ( numOfMenu * 2 );
    CGFloat bgLayerInterval = self.frame.size.width / numOfMenu;
    
    NSMutableArray *tempIndicatorArray = [NSMutableArray arrayWithCapacity:self.numOfMenu];
    for (int i = 0; i < numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i + 0.5) * bgLayerInterval, self.frame.size.height / 2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor] andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        //title
        NSString *titleString = [self.titles objectAtIndex:i];
        CGPoint titlePosition = CGPointMake(textLayerInterval , self.frame.size.height / 2);
        CATextLayer *titleLayer = [self createTextLayerWithNSString:titleString withColor:[UIColor blackColor] andPosition:titlePosition];
        [bgLayer addSublayer:titleLayer];
        //indicator
        CAShapeLayer *indicatorLayer = [self createIndicatorWithColor:[UIColor grayColor] andPosition:CGPointMake(titlePosition.x + titleLayer.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
        [bgLayer addSublayer:indicatorLayer];
        [tempIndicatorArray addObject:indicatorLayer];
        // spaceLine
        if (i < self.numOfMenu - 1) {
            CGPoint spaceLinePosition = CGPointMake(bgLayerInterval, self.frame.size.height / 2);
            CAGradientLayer *spaceLineLayer = [self creatSpaceLineWithPosition:spaceLinePosition];
            [bgLayer addSublayer: spaceLineLayer];
        }
    }
    
    self.indicatorArray = [tempIndicatorArray copy];
}

- (void)setIsDropAnimation:(BOOL)isDropAnimation {
    _isDropAnimation = isDropAnimation;
}

#pragma mark - Prviate Methods
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {

    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / self.numOfMenu) - 25) ? size.width : self.frame.size.width / self.numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(4, 4)];
    [path addLineToPoint:CGPointMake(8, 0)];

    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

- (CAGradientLayer *)creatSpaceLineWithPosition:(CGPoint)point {
    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.5];
    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
    NSArray *locations = @[@0.25, @0.5, @0.75];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = colors;
    layer.locations = locations;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.bounds = CGRectMake(0 , 0, KScale, self.frame.size.height - 20);
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string {
    CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - Public Methods
-(void)restoreIndicator:(NSInteger)index{
    [self animateIndicator:self.indicatorArray[index] Forward:NO complete:^{}];
    self.currentTapIndex = -1;  // 重置
}

#pragma mark - Animation Methods
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}

#pragma mark - Getter
- (CALayer *)topLine {
    if (!_topLine) {
        _topLine = [CALayer layer];
        _topLine.backgroundColor = ZFCOLOR(176, 176, 176, 1).CGColor;
    }
    return _topLine;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = ZFCOLOR(176, 176, 176, 1).CGColor;
    }
    return _bottomLine;
}

- (NSArray *)indicatorArray {
    if (!_indicatorArray) {
        _indicatorArray = [NSArray array];
    }
    return _indicatorArray;
}

@end

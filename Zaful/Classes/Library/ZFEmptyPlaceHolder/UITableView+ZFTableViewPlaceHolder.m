
//
//  UITableView+ZFTableViewPlaceHolder.m
//  Zaful
//
//  Created by liuxi on 2017/8/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "UITableView+ZFTableViewPlaceHolder.h"
#import <objc/runtime.h>

@implementation UITableView (ZFTableViewPlaceHolder)
- (void)zf_configureWithPlaceHolderBlock:(ZFTablePlaceHolderBlock)block normalBlock:(ZFTablePlaceHolderNormalBlock)normal{
    self.zf_placeHolderBlock = [block copy];
    if(self.zf_placeHolderBlock){
        [self zfPlaceHolder_swizzling];
        self.zfPlaceHolder_configure = YES;
        self.zf_placeHolderNormalBlock = [normal copy];
        return;
    }
    self.zfPlaceHolder_configure = NO;
}

- (void)zfPlaceHolder_swizzling {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(reloadData);
        SEL swizzledSelector = @selector(zf_reloadData);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)zf_reloadData {
    [self zf_reloadData];
    
    if(!self.zfPlaceHolder_isConfigured) return;
    BOOL isEmpty = YES;
    
    id<UITableViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self];
    }
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src tableView:self numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;
        }
    }
    if(isEmpty){
        if(self.zf_placeHolderView){
            [self.zf_placeHolderView removeFromSuperview];
            self.zf_placeHolderView = nil;
            
        }

        //show the placeHolder view
        self.zf_placeHolderView = self.zf_placeHolderBlock(self);
        if(!self.zf_placeHolderView) @throw [NSException exceptionWithName:NSGenericException
                                                                    reason:[NSString stringWithFormat:@"must return a view at the time of calling the zf_configureWithPlaceHolderBlock:: in the first block."]
                                                                  userInfo:nil];
        self.zf_placeHolderView.frame = self.bounds;
        [self addSubview:self.zf_placeHolderView];
    }else{
        //remove the placeHolder from super view
        [self.zf_placeHolderView removeFromSuperview];
        self.zf_placeHolderView = nil;
        if(self.zf_placeHolderNormalBlock) self.zf_placeHolderNormalBlock(self);
    }
}

#pragma mark - category property getter and setter method
- (BOOL)zfPlaceHolder_isConfigured {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZfPlaceHolder_configure:(BOOL)isConfigured {
    NSNumber *boolValue = [NSNumber numberWithBool:isConfigured];
    objc_setAssociatedObject(self, @selector(zfPlaceHolder_isConfigured), boolValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZFTablePlaceHolderBlock)zf_placeHolderBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZf_placeHolderBlock:(ZFTablePlaceHolderBlock)block {
    objc_setAssociatedObject(self, @selector(zf_placeHolderBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ZFTablePlaceHolderNormalBlock)zf_placeHolderNormalBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZf_placeHolderNormalBlock:(ZFTablePlaceHolderNormalBlock)block {
    objc_setAssociatedObject(self, @selector(zf_placeHolderNormalBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)zf_placeHolderView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZf_placeHolderView:(UIView *)view {
    objc_setAssociatedObject(self, @selector(zf_placeHolderView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

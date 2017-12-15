//
//  ZFHomePageMenuViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/10.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomePageMenuViewModel.h"
#import "ZFHomePageMenuModel.h"

@interface ZFHomePageMenuViewModel ()

@property (nonatomic, strong) ZFHomePageMenuModel *model;

@end

@implementation ZFHomePageMenuViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        self.model = [[ZFHomePageMenuModel alloc] init];
    }
    return self;
}

- (void)requestHomePageMenuWithParam:(id)parmaters completeHandler:(void (^)(void))completeHandler {
    
    [self.model requestHomePageMenuWithParam:nil completeHandler:^(NSString *message, BOOL isSuccess) {
        
        self.message   = message;
        self.isSuccess = isSuccess;
        completeHandler();
    }];
}

- (NSArray *)tabMenuModels {
    _tabMenuModels = [ZFHomePageMenuModel selectAllModels];
    if (_tabMenuModels.count <= 0) {
        _tabMenuModels = [self.model getTabMenuModels];
    }
    return _tabMenuModels;
}

- (NSArray <NSString *> *)values {
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:self.tabMenuModels.count];
    for (ZFHomePageMenuModel *model in self.tabMenuModels) {
        [values addObject:[NSString stringWithFormat:@"%ld", (long)model.tabType]];
    }
    return values;
}

- (NSArray <NSString *> *)keys {
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:self.tabMenuModels.count];
    for (NSInteger i = 0; i < self.tabMenuModels.count; i++) {
        [keys addObject:@"tabType"];
    }
    return keys;
}

- (NSArray *)tabMenuTitles {
    NSMutableArray *tabMenuTitles = [[NSMutableArray alloc] initWithCapacity:self.tabMenuModels.count];
    for (ZFHomePageMenuModel *model in self.tabMenuModels) {
        [tabMenuTitles addObject:model.tabTitle];
    }
    return tabMenuTitles;
}

@end

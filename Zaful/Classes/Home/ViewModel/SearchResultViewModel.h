//
//  SearchResultViewModel.h
//  Dezzal
//
//  Created by Y001 on 16/8/10.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "BaseViewModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CHTCollectionViewWaterfallLayout.h"

typedef void(^SearchResultReloadDataCompletionHandler)(void);

@interface SearchResultViewModel : BaseViewModel<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic, strong) NSString *searchTitle;

@property (nonatomic, copy) SearchResultReloadDataCompletionHandler searchResultReloadDataCompletionHandler;
@end

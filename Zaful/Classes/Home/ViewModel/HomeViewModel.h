//
//  HomeViewModel.h
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface HomeViewModel : BaseViewModel<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView                 * collectionView;

@property (nonatomic, weak) UIViewController * viewController;

@end

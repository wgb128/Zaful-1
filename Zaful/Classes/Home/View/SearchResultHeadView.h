//
//  SearchResultHeadView.h
//  Dezzal
//
//  Created by Y001 on 16/8/10.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultHeadView : UICollectionReusableView

/**点击跳转到排序方式的选择*/
@property (nonatomic, copy)   void(^sortClick)();

+ (SearchResultHeadView *)SearchResultHeadWithCollectionView:(UICollectionView *)collectionView Kind:(NSString *)kind IndexPath:(NSIndexPath *)indexPath ;
@end

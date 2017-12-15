//
//  UICollectionView+ZFCollectionViewPlaceHolder.h
//  Zaful
//
//  Created by liuxi on 2017/8/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#if NS_BLOCKS_AVAILABLE
typedef  UIView * _Nonnull (^ZFPlaceHolderBlock)(UICollectionView * _Nonnull sender);
typedef void (^ZFPlaceHolderNormalBlock)(UICollectionView * _Nonnull sender);
#endif

#ifndef ZF_STRONG
#if __has_feature(objc_arc)
#define ZF_STRONG strong
#else
#define ZF_STRONG retain
#endif
#endif
@interface UICollectionView (ZFCollectionViewPlaceHolder)
NS_ASSUME_NONNULL_BEGIN
/**
 *  this is the tableview's place holder view, when the tableView's data is empty, call addSubView: with the jr_placeHolderView on tableView.
 */
@property (nonatomic, ZF_STRONG) UIView * _Nullable zf_placeHolderView;

/**
 *  Configure the category method, Call the first block when data is empty. Call the second block when data is empty.
 *
 *  @param block  After call the block need to return a view as a subView on the tableView, in the block, you can call a coherent method as configuring the tableView, such as the prohibition scrolling and display an error message, and finally must return a view, as the tableView's placeHolder view.
 *  @param normal Block called when tableView's data is normal, the main purpose is to restore tableView style, such as previously set up scrolling is disabled, this time need to re-set.
 */
- (void)zf_configureWithPlaceHolderBlock:(ZFPlaceHolderBlock)block normalBlock:(_Nullable ZFPlaceHolderNormalBlock)normal;

@end
NS_ASSUME_NONNULL_END

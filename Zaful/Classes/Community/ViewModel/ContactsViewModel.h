//
//  ContactsViewModel.h
//  Zaful
//
//  Created by TsangFa on 17/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

typedef void(^CountBlock)(NSArray *phoneArray);

@interface ContactsViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,weak) UIViewController *controller;
@property (nonatomic,copy) CountBlock countBlock;

- (void)loadContactsDataCompletion:(void (^)(id obj))completion;

@end

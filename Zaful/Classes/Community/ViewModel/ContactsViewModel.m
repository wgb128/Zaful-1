//
//  ContactsViewModel.m
//  Zaful
//
//  Created by TsangFa on 17/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ContactsViewModel.h"
#import "PPGetAddressBook.h"
#import "ContactsCell.h"

@interface ContactsViewModel ()<UIAlertViewDelegate>

@property (nonatomic,strong) NSDictionary *contactPeopleDict;
@property (nonatomic,strong) NSArray *keys;
@property (nonatomic,strong) NSMutableArray *selectArray;
@end

@implementation ContactsViewModel

- (void)loadContactsDataCompletion:(void (^)(id obj))completion  {
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        //[indicator stopAnimating];
        
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = nameKeys;
        if (completion) {
            completion(self.keys);
        }
    } authorizationFailure:^{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertView"
                                                        message:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure_Message",nil)                                                       delegate:nil
                                              cancelButtonTitle:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure__OK",nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.controller.navigationController popViewControllerAnimated:YES];
    }else {
        NSURL *urlSetting = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if (urlSetting) {
            if ([[UIApplication sharedApplication] canOpenURL:urlSetting]) {
                
                [[UIApplication sharedApplication] openURL:urlSetting];
            }
        }
    }
    
}


#pragma mark - TableViewDatasouce/TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _keys[section];
    return [_contactPeopleDict[key] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keys[section];
}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _keys[indexPath.section];
    PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
    ContactsCell *cell = [ContactsCell contactsCellWithTableView:tableView andIndexPath:indexPath];
    cell.model = people;
    @weakify(self)
    cell.contactsSelectBlock = ^(PPPersonModel *model){
        @strongify(self)
        if (model.isSelect) {
            [self.selectArray addObject:model];
        }else{
            [self.selectArray removeObject:model];
        }

        if (self.countBlock) {
            self.countBlock([self.selectArray copy]);
        }
    };
    
    return cell;
}


#pragma mark - Lazyload
-(NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end

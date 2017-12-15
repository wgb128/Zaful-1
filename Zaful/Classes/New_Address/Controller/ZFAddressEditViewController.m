//
//  ZFAddressEditViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressCountrySelectViewController.h"
#import "ZFAddressProvinceSelectViewController.h"
#import "ZFAddressCitySelectViewController.h"
#import "AlertWebView.h"
#import "DLPickerView.h"
#import "FFToast.h"
#import "FilterManager.h"
#import "ZFAddressEditNameTableViewCell.h"
#import "ZFAddressEditEmailTableViewCell.h"
#import "ZFAddressEditAddressTableViewCell.h"
#import "ZFAddressEditCountryTableViewCell.h"
#import "ZFAddressEditStateTableViewCell.h"
#import "ZFAddressEditCityTableViewCell.h"
#import "ZFAddressEditZipCodeTableViewCell.h"
#import "ZFAddressEditNationalIDTableViewCell.h"
#import "ZFAddressEditSetDefaultTableViewCell.h"
#import "ZFAddressEditPhoneNumberTableViewCell.h"
#import "ZFAddressEditWhatsAppTableViewCell.h"
#import "ZFAddressEditAlternatePhoneNumberCell.h"
#import "ZFAddressEditLandMarksTableViewCell.h"
#import "ZFAddressInfoModel.h"
#import "ZFAddressCityModel.h"
#import "ZFAddressCountryModel.h"
#import "ZFAddressEditTypeModel.h"
#import "ZFAddressStateModel.h"
#import "ZFAddressModifyViewModel.h"


static NSString *const kZFAddressEditNameTableViewCellIdentifier = @"kZFAddressEditNameTableViewCellIdentifier";
static NSString *const kZFAddressEditEmailTableViewCellIdentifier = @"kZFAddressEditEmailTableViewCellIdentifier";
static NSString *const kZFAddressEditAddressTableViewCellIdentifier = @"kZFAddressEditAddressTableViewCellIdentifier";
static NSString *const kZFAddressEditCountryTableViewCellIdentifier = @"kZFAddressEditCountryTableViewCellIdentifier";
static NSString *const kZFAddressEditStateTableViewCellIdentifier = @"kZFAddressEditStateTableViewCellIdentifier";
static NSString *const kZFAddressEditCityTableViewCellIdentifier = @"kZFAddressEditCityTableViewCellIdentifier";
static NSString *const kZFAddressEditZipCodeTableViewCellIdentifier = @"kZFAddressEditZipCodeTableViewCellIdentifier";
static NSString *const kZFAddressEditNationalIDTableViewCellIdentifier = @"kZFAddressEditNationalIDTableViewCellIdentifier";
static NSString *const kZFAddressEditSetDefaultTableViewCellIdentifier = @"kZFAddressEditSetDefaultTableViewCellIdentifier";
static NSString *const kZFAddressEditPhoneNumberTableViewCellIdentifier = @"kZFAddressEditPhoneNumberTableViewCellIdentifier";
static NSString *const kZFAddressEditWhatsAppTableViewCellIdentifier = @"kZFAddressEditWhatsAppTableViewCellIdentifier";
static NSString *const kZFAddressEditAlternatePhoneNumberCellIdentifier = @"kZFAddressEditAlternatePhoneNumberCellIdentifier";
static NSString *const kZFAddressEditLandMarksTableViewCellIdentifier = @"kZFAddressEditLandMarksTableViewCellIdentifier";

@interface ZFAddressEditViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource> {
    __block BOOL            _hasProvince;
    __block BOOL            _hasCity;
}
@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) UIButton                  *continueButton;
@property (nonatomic, strong) DLPickerView              *pickerView;

@property (nonatomic, strong) NSMutableArray<ZFAddressEditTypeModel *>            *dataArray;
@property (nonatomic, strong) ZFAddressInfoModel        *editModel;
@property (nonatomic, strong) ZFAddressModifyViewModel  *viewModel;
@end

@implementation ZFAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zfInitView];
    [self zfAutoLayoutView];
    [self configAddressEditBookInfo];
}

#pragma mark - action methods
- (void)continueButtonAction:(UIButton *)sender {
    
    //先检查一遍，所有的输入是否已经合格。
    if (![self isCheckEnterInfoSuccess]) {
        for (ZFAddressEditTypeModel *obj in self.dataArray) {
            obj.isCheckEnter = YES;
        }
        [self.tableView reloadData];
        return ;
    }
    NSDictionary *dict = @{
                           @"address_id" : self.editModel.address_id == nil ? @"" : self.editModel.address_id,
                           @"firstname"  : self.editModel.firstname ?: @"",
                           @"lastname"  : self.editModel.lastname ?: @"",
                           @"email" : self.editModel.email ?: @"",
                           @"tel" : self.editModel.tel ?: @"",
                           @"id_card" :[NSStringUtils isEmptyString:self.editModel.id_card withReplaceString:@""],
                           @"country"  : self.editModel.country_id ?: @"",
                           @"province" : self.editModel.province ?: @"",
                           @"city"  : self.editModel.city ?: @"",
                           @"addressline1" : self.editModel.addressline1 ?: @"",
                           @"addressline2" : self.editModel.addressline2 ?: @"",
                           @"zipcode" : self.editModel.zipcode ?: @"",
                           @"supplier_number" : [NSStringUtils isEmptyString:self.editModel.supplier_number withReplaceString:@""],
                           @"code" : self.editModel.code ?: @"",
                           @"landmark" : self.editModel.landmark ?: @"",
                           @"telspare" : self.editModel.telspare ?: @"",
                           @"whatsapp" : self.editModel.whatsapp ?: @"",
                           @"supplier_number_spare" : self.editModel.supplier_number_spare ?: @""
                           };
    [self.viewModel requestNetwork:dict completion:^(id obj) {
        if (self.addressEditSuccessCompletionHandler) {
            
            self.addressEditSuccessCompletionHandler();
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(id obj) {}];
    
}

#pragma mark - private methods 
- (BOOL)isCheckEnterInfoSuccess {
    __block BOOL isOk = YES;
    //检查一遍Edit Model， 如果存在问题，直接打开icContinueCheck开关 刷新数据源提示用户输入。
    
    [self.dataArray enumerateObjectsUsingBlock:^(ZFAddressEditTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.editType) {
            case ZFAddressEditTypeFirstName: {
                if(self.editModel.firstname.length == 0 || self.editModel.firstname.length < 2){
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeLastName: {
                if(self.editModel.lastname.length <= 0 || self.editModel.lastname.length < 2){
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeEmail: {
                NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                if (![emailTest evaluateWithObject:self.editModel.email]) {
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeAddressFirst: {
                if(self.editModel.addressline1.length <= 0 || self.editModel.addressline1.length < 5){
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeAddressSecond: {
                
            }
                break;
            case ZFAddressEditTypeCountry: {
                if(self.editModel.country_str.length <= 0 || self.editModel.country_str.length < 2){
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeState: {
                if(self.editModel.province.length <= 0 || self.editModel.province.length < 2){
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeCity: {
                if(self.editModel.city.length <= 0 || self.editModel.city.length < 3
                   || [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{3,}$"] evaluateWithObject:self.editModel.city]){
                    isOk = NO;
                    obj.rowHeight = 75;
                }

            }
                break;
            case ZFAddressEditTypeZipCode: {
                if(self.editModel.zipcode.length <= 0 || self.editModel.zipcode.length < 3) {
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeLandmark: {
                
            }
                break;
            case ZFAddressEditTypePhoneNumber: {
                if (![NSStringUtils isEmptyString:self.editModel.supplier_number_list] && self.editModel.supplier_number.length <= 0) {
                    isOk = NO;
                    obj.rowHeight = 75;
                }
                
                if(self.editModel.tel.length <= 0){
                    isOk = NO;
                    obj.rowHeight = 75;
                }else if (self.editModel.configured_number == 1 && (self.editModel.tel.length != [self.editModel.number integerValue]) ) {  // 有限制号码长度     只要当前输入长度不等于number就提示
                    isOk = NO;
                    obj.rowHeight = 75;
                }else if (self.editModel.configured_number == 0 && self.editModel.tel.length > [self.editModel.number integerValue]) {       // 没有限制号码长度   电话号码长度最大不能超过 13位
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeAlternatePhoneNumber: {
                
            }
                break;
            case ZFAddressEditTypeNationalId: {
                if ([FilterManager requireCardNumWithAddressId:self.editModel.country_id] && self.editModel.id_card.length != 10) {
                    isOk = NO;
                    obj.rowHeight = 75;
                }
            }
                break;
            case ZFAddressEditTypeWhatsApp: {
                
            }
                break;
            case ZFAddressEditTypeSetDefault: {
                
                break;
            }
        }
    }];

    return isOk;
}

- (void)selectAddressCountryInfo {
    ZFAddressCountrySelectViewController *countryVC = [[ZFAddressCountrySelectViewController alloc] init];
    @weakify(self);
    countryVC.addressCountrySelectCompletionHandler = ^(ZFAddressCountryModel *countryModel) {
        @strongify(self);
        if ([self.editModel.country_id isEqualToString:countryModel.region_id]) {
            return ;
        }
        self.editModel.country_id = countryModel.region_id;
        self.editModel.country_str = countryModel.region_name;

        //判断当前是否为沙特国家，有的话需要更新NationalIDNumber 及电话号码类型以及清空省份城市选择。
        self.editModel.is_cod = countryModel.is_cod;
        self.editModel.province = @"";
        self.editModel.province_id = @"";
        self.editModel.city = @"";
        self.editModel.code = countryModel.code;
        self.editModel.supplier_number_list = countryModel.supplier_number_list;
        self.editModel.supplier_number = @"";
        self.editModel.tel = @"";
        self.editModel.zipcode = @"";
        self.editModel.number = countryModel.number;
        self.editModel.configured_number = countryModel.configured_number;
        self.editModel.id_card = @"";
        self->_hasProvince = countryModel.is_state;
        self->_hasCity = NO;
        [self configAddressEditBookInfo];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:countryVC animated:YES];
}

- (void)selectAddressStateInfoWithCountryId:(NSString *)countryId {
    if ([NSStringUtils isEmptyString:countryId] || !_hasProvince) {
        //如果没有选择国家，更新EditType数据源  让用户选择国家。
        return ;
    }
    ZFAddressProvinceSelectViewController *provinceVC = [[ZFAddressProvinceSelectViewController alloc] init];
    provinceVC.regionId = countryId;
    
    provinceVC.addressProvinceSelectCompletionHandler = ^(ZFAddressStateModel *model) {
        if ([self.editModel.province_id isEqualToString:model.provinceId]) {
            return ;
        }
        self.editModel.province_id = model.provinceId;
        self.editModel.province = model.provinceName;
        self->_hasCity = model.is_city;
        [self configAddressEditBookInfo];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:provinceVC animated:YES];
}

- (void)selectAddressCityInfoWithStateId:(NSString *)stateId andCountryId:(NSString *)countryId{
    if (!_hasCity) {
        //如果没有选择国家，更新EditType数据源  让用户选择国家。
        return ;
    }
    ZFAddressCitySelectViewController *cityVC = [[ZFAddressCitySelectViewController alloc] init];
    cityVC.provinceId = stateId;
    cityVC.countryId = countryId;
    cityVC.addressCitySelectCompletionHandler = ^(ZFAddressCityModel *model) {
        self.editModel.city = model.cityName;
        [self configAddressEditBookInfo];
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)selectPhoneSupplierNumberWithType:(NSInteger)type {
    [self.view resignFirstResponder];
    @weakify(self)
    self.pickerView = [[DLPickerView alloc] initWithDataSource:[self.editModel.supplier_number_list componentsSeparatedByString:@","]
                                              withSelectedItem:nil
                                             withSelectedBlock:^(id selectedItem) {
                                                 @strongify(self);
                                                 if (type == 0) {
                                                     self.editModel.supplier_number = selectedItem;
                                                     if (self.editModel.tel.length == [self.editModel.number integerValue]) {
                                                         self.editModel.whatsapp = [NSString stringWithFormat:@"%@%@", self.editModel.supplier_number, self.editModel.tel];
                                                     }
                                                 } else {
                                                     self.editModel.supplier_number_spare = selectedItem;
                                                 }
                                                 [self.tableView reloadData];
                                             }
                       ];
    self.pickerView.shouldDismissWhenClickShadow = YES;
    [self.pickerView show];

}

- (void)configAddressEditBookInfo {
    [self.dataArray removeAllObjects];
    
    ZFAddressEditTypeModel *firstNameModel = [[ZFAddressEditTypeModel alloc] init];
    firstNameModel.editType = ZFAddressEditTypeFirstName;
    firstNameModel.rowHeight = 50;
    [self.dataArray addObject:firstNameModel];
    
    ZFAddressEditTypeModel *lastNameModel = [[ZFAddressEditTypeModel alloc] init];
    lastNameModel.editType = ZFAddressEditTypeLastName;
    lastNameModel.rowHeight = 50;
    [self.dataArray addObject:lastNameModel];
    
    ZFAddressEditTypeModel *emailModel = [[ZFAddressEditTypeModel alloc] init];
    emailModel.editType = ZFAddressEditTypeEmail;
    emailModel.rowHeight = 50;
    [self.dataArray addObject:emailModel];
    
    ZFAddressEditTypeModel *firstAddressModel = [[ZFAddressEditTypeModel alloc] init];
    firstAddressModel.editType = ZFAddressEditTypeAddressFirst;
    firstAddressModel.rowHeight = 50;
    [self.dataArray addObject:firstAddressModel];
    
    ZFAddressEditTypeModel *secondAddressModel = [[ZFAddressEditTypeModel alloc] init];
    secondAddressModel.editType = ZFAddressEditTypeAddressSecond;
    secondAddressModel.rowHeight = 50;
    [self.dataArray addObject:secondAddressModel];
    
    if (self.editModel.is_cod) {
        ZFAddressEditTypeModel *landmarkModel = [[ZFAddressEditTypeModel alloc] init];
        landmarkModel.editType = ZFAddressEditTypeLandmark;
        landmarkModel.rowHeight = 50;
        [self.dataArray addObject:landmarkModel];
    }
    
    ZFAddressEditTypeModel *countryModel = [[ZFAddressEditTypeModel alloc] init];
    countryModel.editType = ZFAddressEditTypeCountry;
    countryModel.rowHeight = 50;
    [self.dataArray addObject:countryModel];
    
    ZFAddressEditTypeModel *stateModel = [[ZFAddressEditTypeModel alloc] init];
    stateModel.editType = ZFAddressEditTypeState;
    stateModel.rowHeight = 50;
    [self.dataArray addObject:stateModel];
    
    ZFAddressEditTypeModel *cityModel = [[ZFAddressEditTypeModel alloc] init];
    cityModel.editType = ZFAddressEditTypeCity;
    cityModel.rowHeight = 50;
    [self.dataArray addObject:cityModel];
    
    if ([FilterManager requireCardNumWithAddressId:self.editModel.country_id]) {
        ZFAddressEditTypeModel *nationalModel = [[ZFAddressEditTypeModel alloc] init];
        nationalModel.editType = ZFAddressEditTypeNationalId;
        nationalModel.rowHeight = 50;
        [self.dataArray addObject:nationalModel];
    }
    
    ZFAddressEditTypeModel *zipCodeModel = [[ZFAddressEditTypeModel alloc] init];
    zipCodeModel.editType = ZFAddressEditTypeZipCode;
    zipCodeModel.rowHeight = 50;
    [self.dataArray addObject:zipCodeModel];
    
    ZFAddressEditTypeModel *phoneNumberModel = [[ZFAddressEditTypeModel alloc] init];
    phoneNumberModel.editType = ZFAddressEditTypePhoneNumber;
    phoneNumberModel.rowHeight = 50;
    [self.dataArray addObject:phoneNumberModel];
    if (self.editModel.is_cod) {
        ZFAddressEditTypeModel *phoneNumberAlternateModel = [[ZFAddressEditTypeModel alloc] init];
        phoneNumberAlternateModel.editType = ZFAddressEditTypeAlternatePhoneNumber;
        phoneNumberAlternateModel.rowHeight = 50;
        [self.dataArray addObject:phoneNumberAlternateModel];
        
        ZFAddressEditTypeModel *whatsAppModel = [[ZFAddressEditTypeModel alloc] init];
        whatsAppModel.editType = ZFAddressEditTypeWhatsApp;
        whatsAppModel.rowHeight = 80;
        [self.dataArray addObject:whatsAppModel];
    }
    
    ZFAddressEditTypeModel *setDefaultModel = [[ZFAddressEditTypeModel alloc] init];
    setDefaultModel.editType = ZFAddressEditTypeSetDefault;
    setDefaultModel.rowHeight = 50;
    [self.dataArray addObject:setDefaultModel];
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFAddressEditTypeModel *model = self.dataArray[indexPath.row];
    
    switch (model.editType) {
        case ZFAddressEditTypeFirstName: {
            ZFAddressEditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditNameTableViewCellIdentifier forIndexPath:indexPath];
            cell.addressNameType = ZFAddressNameTypeFirstName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.editModel;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditNameCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *name) {
                @strongify(self);
                self.editModel.firstname = name;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditNameCancelOverLengthCompletionHandler = ^(NSString *name) {
                @strongify(self);
                self.editModel.firstname = name;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
        case ZFAddressEditTypeLastName: {
            ZFAddressEditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditNameTableViewCellIdentifier forIndexPath:indexPath];
            cell.addressNameType = ZFAddressNameTypeLastName;
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditNameCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *name) {
                @strongify(self);
                self.editModel.lastname = name;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditNameCancelOverLengthCompletionHandler = ^(NSString *name) {
                @strongify(self);
                self.editModel.lastname = name;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
        case ZFAddressEditTypeEmail: {
            ZFAddressEditEmailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditEmailTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditEmailCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *email) {
                @strongify(self);
                self.editModel.email = email;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditEmailCancelOverLengthCompletionHandler = ^(NSString *email) {
                @strongify(self);
                self.editModel.email = email;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };

            return cell;
        }
            break;
        case ZFAddressEditTypeAddressFirst: {
            ZFAddressEditAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditAddressTableViewCellIdentifier forIndexPath:indexPath];
            cell.editAddressType = ZFAddressEditAddressTypeFirstAddress;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.editModel;
            
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditAddressCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *address) {
                @strongify(self);
                self.editModel.addressline1 = address;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditAddressCancelOverLengthCompletionHandler = ^(NSString *address) {
                @strongify(self);
                self.editModel.addressline1 = address;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
        case ZFAddressEditTypeAddressSecond: {
            ZFAddressEditAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditAddressTableViewCellIdentifier forIndexPath:indexPath];
            cell.editAddressType = ZFAddressEditAddressTypeSecondAddress;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.editModel;
            
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditAddressCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *address) {
                @strongify(self);
                self.editModel.addressline2 = address;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditAddressCancelOverLengthCompletionHandler = ^(NSString *address) {
                @strongify(self);
                self.editModel.addressline2 = address;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
            
        case ZFAddressEditTypeLandmark: {
            ZFAddressEditLandMarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditLandMarksTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.isContinueCheck = model.isCheckEnter;          
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditLandmarkCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *landmark) {
                @strongify(self);
                self.editModel.landmark = landmark;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditLandmarkCancelOverLengthCompletionHandler = ^(NSString *landmark) {
                @strongify(self);
                self.editModel.landmark = landmark;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
        case ZFAddressEditTypeCountry: {
            ZFAddressEditCountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditCountryTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isContinueCheck = model.isCheckEnter;
            return cell;
        }
            break;
        case ZFAddressEditTypeState: {
            ZFAddressEditStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditStateTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.hasProvince = self->_hasProvince;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditStateCompletionHandler = ^(NSString *province) {
                @strongify(self);
                self.editModel.province = province;
            };
            
            cell.addressEditStateCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *province) {
                @strongify(self);
                self.editModel.province = province;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditStateCancelOverLengthCompletionHandler = ^(NSString *province) {
                @strongify(self);
                self.editModel.province = province;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
        case ZFAddressEditTypeCity: {
            ZFAddressEditCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditCityTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.hasCity = self->_hasCity;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditCityCompletionHandler = ^(NSString *city) {
                @strongify(self);
                self.editModel.city = city;
            };
            
            cell.addressEditCityCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *city) {
                @strongify(self);
                self.editModel.city = city;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditCityCancelOverLengthCompletionHandler = ^(NSString *city) {
                @strongify(self);
                self.editModel.city = city;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return cell;
        }
            break;
        case ZFAddressEditTypeZipCode: {
            ZFAddressEditZipCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditZipCodeTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            @weakify(self);
            cell.addressEditZipCodeCheckErrorCompletionHandler  = ^(BOOL isOverLength, NSString *zipCode) {
                @strongify(self);
                self.editModel.zipcode = zipCode;
                if (isOverLength) {
                    model.rowHeight = 75;
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.rowHeight = 50;
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditZipCodeCancelOverLengthCompletionHandler = ^(NSString *zipCode) {
                @strongify(self);
                self.editModel.zipcode = zipCode;
                model.rowHeight = 50;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
        case ZFAddressEditTypePhoneNumber: {
            ZFAddressEditPhoneNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditPhoneNumberTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isErrorEnter = model.isOverLength;
            @weakify(self);
            cell.addressCountryCodeSelectCompletionHandler = ^{
                @strongify(self);
                [self selectPhoneSupplierNumberWithType:0];
            };
            
            cell.addressEditPhoneNumberCheckErrorCompletionHandler = ^(BOOL error, NSString *tel, NSString *resultTel) {
                @strongify(self);
                self.editModel.tel = tel;
                self.editModel.whatsapp = resultTel;
                model.rowHeight = error ? 75 : 50;
                model.isOverLength = error;
                self.dataArray[indexPath.row] = model;
                NSInteger whatappRow = indexPath.row + 2;
                NSMutableArray *indexPaths = [NSMutableArray new];
                if (whatappRow < self.dataArray.count) {
                    NSIndexPath *whatAppIndexPath = [NSIndexPath indexPathForRow:whatappRow inSection:indexPath.section];
                    [indexPaths addObjectsFromArray:@[whatAppIndexPath, indexPath]];
                } else {
                    [indexPaths addObjectsFromArray:@[indexPath]];
                }
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            };
        
            cell.addressEditSelctCountryFirstTipsCompletionHandler = ^{
                //提示用户先选择国家
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:ZFLocalizedString(@"ModifyAddressViewController_phone_message", nil) iconImage:[UIImage imageNamed:@"fftoast_warning_highlight"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
                [toast show:^{
                    [toast dismissCentreToast];
                }];

            };
            return cell;
        }
            break;
        case ZFAddressEditTypeAlternatePhoneNumber: {
            ZFAddressEditAlternatePhoneNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditAlternatePhoneNumberCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.isContinueCheck = model.isCheckEnter;
            cell.isErrorEnter = model.isOverLength;
            @weakify(self);
            cell.addressCountryCodeSelectCompletionHandler = ^{
                @strongify(self);
                [self selectPhoneSupplierNumberWithType:1];
            };
            
            cell.addressEditPhoneNumberCheckErrorCompletionHandler = ^(BOOL error, NSString *tel) {
                @strongify(self);
                self.editModel.telspare = tel;
                model.rowHeight = error ? 75 : 50;
                model.isOverLength = error;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            cell.addressEditSelctCountryFirstTipsCompletionHandler = ^{
                //提示用户先选择国家
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:ZFLocalizedString(@"ModifyAddressViewController_phone_message", nil) iconImage:[UIImage imageNamed:@"fftoast_warning_highlight"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
                [toast show:^{
                    [toast dismissCentreToast];
                }];
                
            };
            return cell;
        }
            break;
        case ZFAddressEditTypeNationalId: {
            ZFAddressEditNationalIDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditNationalIDTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.isContinueCheck = model.isCheckEnter;
            cell.isErrorEnter = model.isOverLength;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.addressEditNationalTipsShowCompletionHandler = ^{
                AlertWebView *alertWeb = [[AlertWebView alloc] initWithUrlStr:[NSString stringWithFormat:CardIntroURL, [ZFLocalizationString shareLocalizable].nomarLocalizable]];
                [alertWeb show];
            };
            @weakify(self);
            cell.addressEditNationalCheckErrorCompletionHandler = ^(BOOL isErrorEnter, NSString *nationalId) {
                @strongify(self);
                self.editModel.id_card = nationalId;
                model.rowHeight = isErrorEnter ? 75 : 50;
                model.isOverLength = isErrorEnter;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
            
        case ZFAddressEditTypeWhatsApp: {
            ZFAddressEditWhatsAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditWhatsAppTableViewCellIdentifier];
            cell.model = self.editModel;
//            cell.isContinueCheck = model.isCheckEnter;
            cell.isOverLength = model.isOverLength;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            @weakify(self);
            cell.addressEditWhatsappCheckErrorCompletionHandler = ^(BOOL isOverLength, NSString *whatsapp) {
                @strongify(self);
                self.editModel.whatsapp = whatsapp;
                if (isOverLength) {
                    model.isOverLength = YES;
                    self.dataArray[indexPath.row] = model;
                } else {
                    model.isOverLength = NO;
                    self.dataArray[indexPath.row] = model;
                }
                
                if (isOverLength) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            
            cell.addressEditWhatsappCancelOverLengthCompletionHandler = ^(NSString *whatsapp) {
                @strongify(self);
                self.editModel.whatsapp = whatsapp;
                model.isOverLength = NO;
                self.dataArray[indexPath.row] = model;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
        case ZFAddressEditTypeSetDefault: {
            ZFAddressEditSetDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressEditSetDefaultTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.editModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            @weakify(self);
            cell.addressEditSetDefaultCompeltionHandler = ^(BOOL isDefault) {
                @strongify(self);
                self.editModel.is_default = isDefault;
            };
            return cell;
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.row].rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFAddressEditTypeModel *model = self.dataArray[indexPath.row];
    if (model.editType == ZFAddressEditTypeCountry) {
        [self selectAddressCountryInfo];
    } else if (model.editType == ZFAddressEditTypeState) {
        //先判断是否有选国家，国家下是否有省份
        if (self.editModel.country_id) {
            [self selectAddressStateInfoWithCountryId:self.editModel.country_id];
        }
    } else if (model.editType == ZFAddressEditTypeCity) {
        if (self.editModel.country_id && self.editModel.province_id) {
            [self selectAddressCityInfoWithStateId:self.editModel.province_id andCountryId:self.editModel.country_id];
        }
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"Modify_Address_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.continueButton];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(12, 0, 60, 0));
    }];
    
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - setter 
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.editModel = [model mutableCopy];
    self->_hasCity = self.editModel.ownCity;
    self->_hasProvince = self.editModel.ownState;
    [self configAddressEditBookInfo];
    [self.tableView reloadData];
}

#pragma mark - getter
- (ZFAddressInfoModel *)editModel {
    if (!_editModel) {
        _editModel = [[ZFAddressInfoModel alloc] init];
    }
    return _editModel;
}

- (ZFAddressModifyViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFAddressModifyViewModel alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray<ZFAddressEditTypeModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
        [_tableView registerClass:[ZFAddressEditNameTableViewCell class] forCellReuseIdentifier:kZFAddressEditNameTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditEmailTableViewCell class] forCellReuseIdentifier:kZFAddressEditEmailTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditAddressTableViewCell class] forCellReuseIdentifier:kZFAddressEditAddressTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditCountryTableViewCell class] forCellReuseIdentifier:kZFAddressEditCountryTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditStateTableViewCell class] forCellReuseIdentifier:kZFAddressEditStateTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditCityTableViewCell class] forCellReuseIdentifier:kZFAddressEditCityTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditZipCodeTableViewCell class] forCellReuseIdentifier:kZFAddressEditZipCodeTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditNationalIDTableViewCell class] forCellReuseIdentifier:kZFAddressEditNationalIDTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditSetDefaultTableViewCell class] forCellReuseIdentifier:kZFAddressEditSetDefaultTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditPhoneNumberTableViewCell class] forCellReuseIdentifier:kZFAddressEditPhoneNumberTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditLandMarksTableViewCell class] forCellReuseIdentifier:kZFAddressEditLandMarksTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditWhatsAppTableViewCell class] forCellReuseIdentifier:kZFAddressEditWhatsAppTableViewCellIdentifier];
        [_tableView registerClass:[ZFAddressEditAlternatePhoneNumberCell class] forCellReuseIdentifier:kZFAddressEditAlternatePhoneNumberCellIdentifier];
    }
    return _tableView;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueButton.backgroundColor = ZFCOLOR_BLACK;
        [_continueButton setTitle:ZFLocalizedString(@"ModifyAddress_Continue",nil) forState:UIControlStateNormal];
        [_continueButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueButton;
}

@end

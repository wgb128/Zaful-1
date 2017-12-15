//
//  ZFAddressEditTypeModel.h
//  Zaful
//
//  Created by liuxi on 2017/9/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZFAddressEditType) {
    ZFAddressEditTypeFirstName = 0,
    ZFAddressEditTypeLastName,
    ZFAddressEditTypeEmail,
    ZFAddressEditTypeAddressFirst,
    ZFAddressEditTypeAddressSecond,
    ZFAddressEditTypeCountry,
    ZFAddressEditTypeState,
    ZFAddressEditTypeCity,
    ZFAddressEditTypeZipCode,
    ZFAddressEditTypeLandmark,
    ZFAddressEditTypePhoneNumber,
    ZFAddressEditTypeAlternatePhoneNumber,
    ZFAddressEditTypeNationalId,
    ZFAddressEditTypeWhatsApp,
    ZFAddressEditTypeSetDefault,
    
};

@interface ZFAddressEditTypeModel : NSObject
@property (nonatomic, assign) ZFAddressEditType     editType;
@property (nonatomic, assign) CGFloat               rowHeight;
@property (nonatomic, assign) BOOL                  isCheckEnter;
@property (nonatomic, assign) BOOL                  isOverLength;

@end

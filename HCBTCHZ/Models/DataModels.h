//
//  DataModels.h
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//


#import <MJExtension.h>


@interface BaseModel : NSObject
@end

@interface CommonModel : NSObject
@property (copy, nonatomic) NSString *Status;
@property (copy, nonatomic) NSString *Message;
@property (strong, nonatomic) id Value;
@end

@interface UserModel : BaseModel
@property (copy, nonatomic) NSString *UserId;
@property (copy, nonatomic) NSString *UserName;
@property (copy, nonatomic) NSString *UserPhotoUrl;
@property (copy, nonatomic) NSString *ContactPhone;
@property (copy, nonatomic) NSString *AccountBalance;
@property (copy, nonatomic) NSString *AuthorType;
@property (copy, nonatomic) NSString *BankAccountLicense;
@property (copy, nonatomic) NSString *BusinessLicense;
@property (copy, nonatomic) NSString *BusinessRegistrationLicense;
@property (copy, nonatomic) NSString *CompanyAddress;
@property (copy, nonatomic) NSString *CompanyName;
@property (copy, nonatomic) NSString *CreateDateTime;
@property (copy, nonatomic) NSString *Deleted;
@property (copy, nonatomic) NSString *LastPassword;
@property (copy, nonatomic) NSString *LoginPassword;
@property (copy, nonatomic) NSString *OpenId;
@property (copy, nonatomic) NSString *PackageId;
@property (copy, nonatomic) NSString *Phone;
@property (copy, nonatomic) NSString *TaxpayerQualification;
@property (copy, nonatomic) NSString *UpdateDateTime;
@end

@interface AddressModel : BaseModel
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *AddressName;
@property (copy, nonatomic) NSString *addressDetailName;
@property (assign, nonatomic) double Latitude;             // 纬度
@property (assign, nonatomic) double Longitude;            // 经度
@property (copy, nonatomic) NSString *Consignee;
@property (copy, nonatomic) NSString *ContactPhone;
@end

@interface OrderAddressModel : AddressModel
@property (assign, nonatomic) BOOL bHoldMonny;
@property (copy, nonatomic) NSString *ExtraMonny;
@property (assign, nonatomic) BOOL bRecicleOrder;
@property (assign, nonatomic) BOOL bNeedMover;
@property (copy, nonatomic) NSString *aboutInfo;
@end

@interface OrderCreateModel : BaseModel
@property (assign, nonatomic) NSInteger orderType;           // 订单类型（0-整车；1-零担）
@property (retain, nonatomic) AddressModel *addressSrc;      // 发货地址
@property (copy, nonatomic) NSMutableArray<OrderAddressModel *> *addressDesArray; // 收货地址数组
@property (copy, nonatomic) NSString *goodsType;             // 货物类型
@property (copy, nonatomic) NSString *goodsVolume;           // 货物体积
@property (copy, nonatomic) NSString *goodsWeight;           // 货物重量
@property (copy, nonatomic) NSString *truckType;             // 车辆类型(只针对整车)
@property (assign, nonatomic) NSInteger feeType;             // 费用类型
@property (assign, nonatomic) CGFloat   offerPrice;          // 货主报价
@property (assign, nonatomic) NSInteger payWay;              // 支付方式
@property (assign, nonatomic) NSInteger toDriverType;        // 订单指派
@property (copy, nonatomic) NSMutableArray *orerToDrivers;   // 允许那些司机接单
@property (copy, nonatomic) NSString *orderRemarks;          // 备注
@end

@interface DriverModel : BaseModel
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *IDCardNumber;
@property (copy, nonatomic) NSString *DriverName;             // 司机名字
@property (copy, nonatomic) NSString *PhoneNumber;
@property (copy, nonatomic) NSString *DriverPhotoURL;
@property (copy, nonatomic) NSString *DriverUserName;         // 司机电话号码
@property (copy, nonatomic) NSString *PlateNumber;            // 车牌号码
@property (copy, nonatomic) NSString *VehicleTypeId;          // 车辆类型ID
@property (copy, nonatomic) NSString *VehicleTypeName;        // 车辆类型名字
@property (copy, nonatomic) NSString *ValidStatus;            // 验证状态
@property (copy, nonatomic) NSString *ValidStatusString;      // 验证结果
@property (copy, nonatomic) NSString *AlipayToken;
@property (copy, nonatomic) NSString *CityId;
@property (copy, nonatomic) NSString *CityName;
@property (copy, nonatomic) NSString *CreateDateTime;
@property (copy, nonatomic) NSString *CreditSte;
@property (copy, nonatomic) NSString *Deleted;
@property (copy, nonatomic) NSString *DeviceNumber;
@property (copy, nonatomic) NSString *IMEI;
@property (copy, nonatomic) NSString *IsTurnOff;
@property (copy, nonatomic) NSString *Length;
@property (copy, nonatomic) NSString *LicenceBackUrl;
@property (copy, nonatomic) NSString *LicenceUrl;
@property (copy, nonatomic) NSString *OverLoad;
@property (copy, nonatomic) NSString *RemainingAmount;
@property (copy, nonatomic) NSString *UpdateDateTime;
@property (copy, nonatomic) NSString *VehiclePictureURL;
@property (copy, nonatomic) NSString *VinBackURL;
@property (copy, nonatomic) NSString *VinURL;
@end

@interface OrderDriverModel : DriverModel
@property (assign, nonatomic) BOOL bSelectStatus;
@end


@interface GoodsTypeModel : BaseModel
@property (copy, nonatomic) NSString *Type;
@end
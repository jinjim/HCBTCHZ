//
//  AdressListTableCell.h
//  HCBTCHZ
//
//  Created by itte on 16/3/4.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdressListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbAddrName;
@property (weak, nonatomic) IBOutlet UILabel *lbAddrSubName;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbPhoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelectStatus;

@end

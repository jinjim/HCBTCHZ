//
//  DriverTableCell.h
//  HCBTCHZ
//
//  Created by itte on 16/3/17.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbCarNum;
@property (weak, nonatomic) IBOutlet UILabel *lbCarType;
@property (weak, nonatomic) IBOutlet UILabel *lbDriverName;
@property (weak, nonatomic) IBOutlet UILabel *lbDriverPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end

//
//  BillTableCell.h
//  HCBTCHZ
//
//  Created by itte on 16/3/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbNum;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderID;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@end

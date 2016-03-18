//
//  MyOrderTableCell.h
//  HCBTCHZ
//
//  Created by itte on 16/3/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbDateTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgMore;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbSrcAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbDestAdress;
@end

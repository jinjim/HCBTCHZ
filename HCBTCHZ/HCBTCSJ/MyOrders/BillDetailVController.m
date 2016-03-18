//
//  BillDetailVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "BillDetailVController.h"

@interface BillDetailVController ()

@property (weak, nonatomic) IBOutlet UILabel *lbMarks;
@end

@implementation BillDetailVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];

    
}



@end

//
//  OrderMenuView.h
//  HCBTCHZ
//
//  Created by itte on 16/3/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMenuView : UIView
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIView *callCarView;
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UIView *transportView;
@property (weak, nonatomic) IBOutlet UIView *waitingConfirmView;

@property (weak, nonatomic) IBOutlet UILabel *lbAll;
@property (weak, nonatomic) IBOutlet UILabel *lbCallCar;
@property (weak, nonatomic) IBOutlet UILabel *lbWaiting;
@property (weak, nonatomic) IBOutlet UILabel *lbTransport;
@property (weak, nonatomic) IBOutlet UILabel *lbWaitingConfirm;
@end

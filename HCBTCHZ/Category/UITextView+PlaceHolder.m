//
//  UITextView+PlaceHolder.m
//  funmain
//
//  Created by itte on 14/3/7.
//  Copyright © 2016年 funmain. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

#define KLeft_Margin 5
#define KTop_Margin 8

@implementation UITextView (PlaceHolder)

// get方法
-(NSString *)placeholder
{
    return self.label.text;
}

// set方法
-(void)setPlaceholder:(NSString *)placeholder
{
    //赋值修改高度
    self.label.text = placeholder;
    [self changeLabelFrame];
    
    // 监听文本改变，如果没有设置placeholder就不会监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

//文本修改
- (void)textDidChange:(NSNotification *)notify
{
    self.label.hidden = self.text.length;
}


-(UILabel *)label
{
    UILabel *label = objc_getAssociatedObject(self, @"label");
    if (label == nil)
    {
        //没有就创建,并设置属性
        label = [[UILabel alloc] init];
        label.font = self.font;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        
        [self addSubview:label];
        
        // 关联到UITextView
        objc_setAssociatedObject(self, @"label", label, OBJC_ASSOCIATION_RETAIN);
    }
    
    return label;
}

// 计算Frame并设置
-(void)changeLabelFrame
{
    //文字可显示区域
    CGSize size = CGSizeMake(self.bounds.size.width - 2*KLeft_Margin, CGFLOAT_MAX);
    //计算文字所占区域
    CGSize labelSize = [self.placeholder boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.label.font} context:nil].size;
    self.label.frame = CGRectMake(KLeft_Margin, KTop_Margin, labelSize.width, labelSize.height);
}

@end

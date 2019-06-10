//
//  StarView.m
//  StarDemo_2016.1.29
//
//  Created by 张重 on 16/1/29.
//  Copyright © 2016年 张重. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.max_star = 100;
        self.show_star = 80;
        self.canSelected = NO;
        //背景色
        self.backgroundColor = [UIColor clearColor];
        //字体大小
        self.font_size = 30;
        //颜色
        self.full_color = [UIColor redColor];
        self.empty_color = [UIColor grayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString *stars=@"★★★★★";
    //设置frame
    rect = self.bounds;
    
    UIFont *font = [UIFont systemFontOfSize:self.font_size];
    
    
    NSDictionary *dict =  @{NSFontAttributeName: font};
    
    CGSize starSize = [stars sizeWithAttributes:dict];
    
    rect.size = starSize;

    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName: self.empty_color}];
    
    
    
    
    CGRect clip=rect;
    
    clip.size.width = clip.size.width * self.show_star / self.max_star;
    
    CGContextClipToRect(context,clip);
    
    [stars drawInRect:rect withAttributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName: self.full_color}];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.canSelected) {//可以选择
        NSString *sting = @"★★★★★";
        CGPoint pt = [[touches anyObject] locationInView:self];
        UIFont *font = [UIFont systemFontOfSize:self.font_size];
        CGSize starSize = [sting sizeWithAttributes:@{NSFontAttributeName: font}];
        if (pt.x > starSize.width + 5) {
            return;
        }
        self.show_star = (NSInteger)(100.0f * pt.x / starSize.width);
        //重新绘制
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.canSelected) {//可以选择
        NSString *sting = @"★★★★★";
        CGPoint pt = [[touches anyObject] locationInView:self];
        UIFont *font = [UIFont systemFontOfSize:self.font_size];
        CGSize starSize = [sting sizeWithAttributes:@{NSFontAttributeName: font}];
        NSLog(@"%f",starSize.width);
        if (pt.x > starSize.width + 5) {
            return;
        }
        self.show_star = (NSInteger)(100.0f * pt.x / starSize.width);
        //重新绘制
        [self setNeedsDisplay];
    }
}

@end

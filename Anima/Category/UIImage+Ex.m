//
//  UIImage+Ex.m
//  Anima
//
//  Created by Davis on 2020/12/22.
//  Copyright © 2020 LJ. All rights reserved.
//

#import "UIImage+Ex.h"

@implementation UIImage (Ex )
+ (UIImage *)imageWithColor:(UIColor *)clr {
    return [self imageWithColor:clr size:CGSizeZero];
}

+ (UIImage *)imageWithColor:(UIColor *)clr size:(CGSize)sz {
    CGRect rct ;
    if (CGSizeEqualToSize(sz, CGSizeZero)) {
        rct = CGRectMake(0.0, 0.0, 1.0, 1.0);
    }else {
        rct = CGRectMake(0.0, 0.0, sz.width, sz.height);
    }
      UIGraphicsBeginImageContext(rct.size);
      CGContextRef ctf = UIGraphicsGetCurrentContext();
      CGContextSetFillColorWithColor(ctf, clr.CGColor);
      CGContextFillRect(ctf, rct);
      UIImage *img =  UIGraphicsGetImageFromCurrentImageContext();
      
      UIGraphicsEndImageContext();
      return img;
}

@end

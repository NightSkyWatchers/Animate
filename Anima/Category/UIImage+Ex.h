//
//  UIImage+Ex.h
//  Anima
//
//  Created by Davis on 2020/12/22.
//  Copyright © 2020 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Ex )

+ (UIImage *)imageWithColor:(UIColor *)clr ;

+ (UIImage *)imageWithColor:(UIColor *)clr size:(CGSize)sz;

@end

NS_ASSUME_NONNULL_END

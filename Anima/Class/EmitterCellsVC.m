//
//  EmitterCellsVC.m
//  Anima
//
//  Created by Davis on 2020/12/22.
//  Copyright © 2020 LJ. All rights reserved.
//

#import "EmitterCellsVC.h"

@interface EmitterCellsVC ()

@end

@implementation EmitterCellsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CAEmitterCell *cell = [CAEmitterCell new];
//    cell.name = @"cell";
//    cell.contents = (__bridge id)[UIImage imageNamed:@"1"].CGImage;
////    cell.lifetime = 10;
//    cell.velocity = 100;
//
//
//    CAEmitterLayer *layer = [CAEmitterLayer layer];
//    layer.position = CGPointMake(viewW/2.0, viewH/2.0);
//    layer.emitterShape = kCAEmitterLayerPoint;
//    layer.emitterMode = kCAEmitterLayerPoints;
//    layer.birthRate = 10;
//    layer.lifetime = 5.0;
//    [self.view.layer addSublayer:layer];
//
//    layer.emitterCells = @[cell];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        layer.birthRate = 0;//停止发射
//    });
    
    CAEmitterCell *cell1 = [self createCell:@"19"];
//    CAEmitterCell *cell2 = [self createCell:@"2"];
//    CAEmitterCell *cell3 = [self createCell:@"3"];

    CAEmitterLayer *emitter = [CAEmitterLayer layer];
//    emitter.frame = CGRectMake(viewW/2.0, viewH/2.0, 10, 10);
    emitter.lifetime = 4;
    switch (arc4random_uniform(4)) {
        case 0:
            emitter.emitterShape = kCAEmitterLayerPoint;
            
            break;
        case 1:
            emitter.emitterShape = kCAEmitterLayerLine;
            
            break;
        case 2:
            emitter.emitterShape = kCAEmitterLayerRectangle;
            
            break;
        case 3:
            emitter.emitterShape = kCAEmitterLayerCircle;
            
            break;
        default:
            break;
    }
    emitter.emitterMode = kCAEmitterLayerOutline;
    
//    emitter.preservesDepth = YES;
//    emitter.emitterDepth = 10;
    emitter.emitterPosition = CGPointMake(viewW/2.0, viewH/2.0);
//    emitter.emitterZPosition = -100;
    emitter.emitterSize = CGSizeMake(100, 100);
    [self.view.layer addSublayer:emitter];
    
    emitter.emitterCells = @[cell1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        emitter.birthRate = 0;//停止发射
    });
}

- (CAEmitterCell *)createCell:(NSString *)imgStr {
       
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:imgStr].CGImage;
    //产生粒子的个数
    cell.birthRate = 10;
    //粒子的生命周期
    cell.lifetime = 2;
//    cell.lifetimeRange = 1;
    //粒子透明度变化
    //       cell.alphaSpeed = -0.4;
    //粒子速度
    cell.velocity = 1;
//    cell.velocityRange = 1;
    //粒子发射方向
//    cell.emissionRange = 0;
    //旋转
//    cell.spin = 1.0;
//    cell.spinRange = 2;
           
    return cell;
}
@end

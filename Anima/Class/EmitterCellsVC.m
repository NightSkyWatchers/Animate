//
//  EmitterCellsVC.m
//  Anima
//
//  Created by Davis on 2020/12/22.
//  Copyright © 2020 LJ. All rights reserved.
//

#import "EmitterCellsVC.h"

@interface EmitterCellsVC ()
@property (nonatomic, strong) NSArray *titlesArr;
@end

@implementation EmitterCellsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titlesArr = @[@"天女散花",@"烟花",@"测试"];
    [self.titlesArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self returnButtonWithTitle:obj idx:idx];
    }];
     

}

- (UIButton *)returnButtonWithTitle:(NSString *)txt idx:(NSInteger )idx {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:txt forState:UIControlStateNormal];
    btn.tag = 1000+idx;
    CGFloat btnW = viewW/self.titlesArr.count;
    
    btn.frame =  CGRectMake(btnW*idx, viewH-80, viewW/2.0, 80);
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor brownColor]];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];

    return btn;
}


- (void)buttonClick:(UIButton*)sender {
    switch (sender.tag - 1000) {
        case 0:
            [self emiteCells];
            break;
        case 1:
            [self fireworks];
            break;

        case 2:
            [self test];
            break;
        default:
            break;
    }
}

- (void)fireworks {
    CAEmitterCell *cell = [CAEmitterCell new];
    cell.name = @"fireworks";
    
    cell.contents = (__bridge id)[UIImage imageNamed:@"2"].CGImage;
    cell.lifetime = 5;
    cell.birthRate = 2;
    cell.yAcceleration = - 100;
    cell.velocity = 20;
//    cell.spin = 1;
    // 方向,y轴负方向,2倍emissionRange的扇形范围内
    cell.emissionLongitude = -M_PI_2;
    cell.emissionRange = M_PI_4/4;
    
//    cell.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
//    cell.redRange = 0.1; // 0.1--0.5;
//    cell.blueRange = 0.8;// 0.5--0.8
//    cell.greenRange = 0.3;//0.3--0.5
//    cell.alphaRange = 0.8;// 0.8 -- 1
//
//    cell.redSpeed = 0.1;
//    cell.greenRange = 0.1;
//    cell.blueSpeed = 0.1;
    
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.position = CGPointMake(viewW/2.0, viewH-150);
    layer.emitterSize = CGSizeMake(4, 40);
    layer.emitterShape = kCAEmitterLayerRectangle;
    layer.emitterMode = kCAEmitterLayerSurface;
    
    [self.view.layer addSublayer:layer];
      
      layer.emitterCells = @[cell];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          layer.birthRate = 0;//停止发射
      });
}
- (void)test {
    CAEmitterCell *cell1 = [self createCell:@"19"];

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
    NSLog(@"shape---%@",emitter.emitterShape);
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
    cell.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
    cell.redRange = 0.1; // 0.1--0.5;
    cell.blueRange = 0.8;// 0.5--0.8
    cell.greenRange = 0.3;//0.3--0.5
    cell.alphaRange = 0.8;// 0.8 -- 1
    
    cell.redSpeed = 0.1;
    cell.greenRange = 0.1;
    cell.blueSpeed = 0.1;
    //粒子透明度变化
    cell.alphaSpeed = -0.4;


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


- (void)emiteCells {
    CAEmitterCell *cell = [CAEmitterCell new];
    cell.name = @"cell";
    cell.contents = (__bridge id)[UIImage imageNamed:@"1"].CGImage;
        cell.lifetime = 10;
    cell.birthRate = 10;
    
    cell.velocity = 100;
    cell.spin = 1;
    cell.emissionRange = M_PI * 2;
    cell.emissionLongitude = -M_PI_2;
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.position = CGPointMake(viewW/2.0, viewH/2.0);
    layer.emitterShape = kCAEmitterLayerPoint;
    layer.emitterMode = kCAEmitterLayerPoints;
    
    [self.view.layer addSublayer:layer];
    
    layer.emitterCells = @[cell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.birthRate = 0;//停止发射
    });
}
@end

//
//  ViewController.m
//  Anima
//
//  Created by Davis on 2020/12/19.
//  Copyright © 2020 LJ. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>


#define viewH             [UIScreen mainScreen].bounds.size.height
#define viewW             [UIScreen mainScreen].bounds.size.width



@interface ViewController ()<UICollisionBehaviorDelegate>
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, strong) UIDynamicAnimator *animtor;

@property (nonatomic, strong) UIGravityBehavior *gryBehvior;
@property (nonatomic, strong) UICollisionBehavior *clnBehavior;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initSubViews];
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

- (void)initSubViews{
    
    for (int i = 0; i<17; i++) {
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(viewW/2.0-25, viewH/2.0-25, 50, 50)];
        
        view.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [self.view addSubview:view];
        [self.gryBehvior addItem:view];
        [self.clnBehavior addItem:view];
    }
    
    // 开始监听
      [self.manager startDeviceMotionUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
          // 设置重力方向
          self.gryBehvior.gravityDirection = CGVectorMake(motion.gravity.x, -motion.gravity.y);
      }];

}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {
    
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:@"cardvoice.mp3" ofType:nil];
    NSLog(@"%@",audioFile);
    
    
   //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */ 
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:audioFile]), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
//    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
//    AudioServicesPlaySystemSound(soundID);//播放音效
//            AudioServicesPlayAlertSound(soundID);//播放音效并震动
//    振动：
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
//    SystemSoundID soundID1 = 1007;
//    AudioServicesPlaySystemSound(4095);


//    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
//        AudioServicesDisposeSystemSoundID(soundID);
//    });
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 {
    
}

// The identifier of a boundary created with translatesReferenceBoundsIntoBoundary or setTranslatesReferenceBoundsIntoBoundaryWithInsets is nil
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
    
    if (identifier != nil && p.y < self.view.bounds.size.height ) {
        
        //    振动：
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier {
    
}


- (UIDynamicAnimator *)animtor {
    if (!_animtor) {
        _animtor = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animtor;
}

- (UIGravityBehavior *)gryBehvior {
    if (!_gryBehvior) {
        _gryBehvior = [[UIGravityBehavior alloc] initWithItems:@[]];
        /*****设置重力加速度 与方向
                dx = 0 dy > 0  重力正下
                dx = 0 dy < 0  重力正上
                dx < 0 dy = 0  重力往左
                dx > 0 dy = 0  重力往右
                1为一倍重力加速度
        _gravity.gravityDirection = CGVectorMake(dx, dy);
        *****/

        _gryBehvior.gravityDirection = CGVectorMake(0.0, 1.0);

        // 设置重力的方向（角度）x 轴正方向为0点，顺时针为正，逆时针为负
//        _gryBehvior.angle = (M_PI_4);
        // 设置重力的加速度,重力的加速度越大，碰撞就越厉害
//        _gryBehvior.magnitude = 100;

        [self.animtor addBehavior:_gryBehvior];

    }
    return _gryBehvior;
}

- (UICollisionBehavior *)clnBehavior {
    if (!_clnBehavior) {
        _clnBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
//        _clnBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
        _clnBehavior.translatesReferenceBoundsIntoBoundary = YES;
        _clnBehavior.collisionDelegate = self;

        [_clnBehavior addBoundaryWithIdentifier:@"boudaryID" forPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, viewW, viewH)]];
        [self.animtor addBehavior:_clnBehavior];

    }
    return _clnBehavior;
}

- (CMMotionManager *)manager {
    if (!_manager) {
        _manager = [[CMMotionManager alloc] init];
        _manager.deviceMotionUpdateInterval = 0.01;
    }
    return _manager;
}
@end

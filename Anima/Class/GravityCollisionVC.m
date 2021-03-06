//
//  GravityCollisionVC.m
//  Anima
//
//  Created by Davis on 2020/12/22.
//  Copyright © 2020 LJ. All rights reserved.
//

#import "GravityCollisionVC.h"

// 重力感应
#import <CoreMotion/CoreMotion.h>
// 播放音效，震动需要的工具类
#import <AudioToolbox/AudioToolbox.h>

@interface GravityCollisionVC ()<UICollisionBehaviorDelegate>
// 设备重力监听管理者
@property (nonatomic, strong) CMMotionManager *manager;
// 物理仿真器
@property (nonatomic, strong) UIDynamicAnimator *animtor;
// 重力行为
@property (nonatomic, strong) UIGravityBehavior *gryBehvior;
// 碰撞行为
@property (nonatomic, strong) UICollisionBehavior *clnBehavior;

@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@end

@implementation GravityCollisionVC {
    NSTimer *_timer;
    SystemSoundID _soundID ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"cardvoice.mp3" ofType:nil];
    NSLog(@"%@",audioFile);
//    self.navigationController.navigationBarHidden = YES;
    //1.获得系统声音ID
    _soundID = 0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:audioFile]), &_soundID);

    [self initSubViews];
//    [self initGrayvityTimer];

    // 开始监听设备重力感应
    [self.manager startDeviceMotionUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        // 设置重力方向
        self.gryBehvior.gravityDirection = CGVectorMake(motion.gravity.x, -motion.gravity.y);
    }];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.manager stopDeviceMotionUpdates];
    [_timer invalidate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.gryBehvior.gravityDirection = CGVectorMake(1.0-arc4random_uniform(20)/10.0, 1.0-arc4random_uniform(20)/10.0);
}

- (void)initGrayvityTimer {
    _timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.gryBehvior.gravityDirection = CGVectorMake(1.0-arc4random_uniform(20)/10.0, 1.0-arc4random_uniform(20)/10.0);
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    
}

- (void)initSubViews{
    
    for (int i = 0; i<17; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(viewW/2.0-25, 15, 50, 50)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [self.view addSubview:img];

        // 添加仿真元素
        [self.clnBehavior addItem:img];
        [self.itemBehavior addItem:img];
        [self.gryBehvior addItem:img];
    }
    
   
}


#pragma mark --- delegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {

}


- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 {
    
}

// The identifier of a boundary created with translatesReferenceBoundsIntoBoundary or setTranslatesReferenceBoundsIntoBoundaryWithInsets is nil
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
    
    if (identifier != nil && p.y < self.view.bounds.size.height ) {
        
        // MARK: ---1.  振动：
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // MARK: ---2.播放音频,其中这个soundID号可以从苹果官方网站找到：http://iphonedevwiki.net/index.php/AudioServices
        //        AudioServicesPlaySystemSound(1007);//播放音效
        //        AudioServicesPlayAlertSound(1007);//播放音效并震动
        
        // MARK: ---3.制作的音效
        
        //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
//        AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, soundCompleteCallback, NULL);
//        //2.播放音频
//        AudioServicesPlaySystemSound(_soundID);

        
        // MARK: ---3方法的替代方法
//        AudioServicesPlaySystemSoundWithCompletion(_soundID, ^{
//            AudioServicesDisposeSystemSoundID(self->_soundID);
//        });

    }
    
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier {
    
}

void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
    AudioServicesDisposeSystemSoundID(soundID);
}


#pragma mark --- lazy
- (UIDynamicAnimator *)animtor {
    if (!_animtor) {
        //创建一个物理仿真器,（顺便设置仿真范围）
        _animtor = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animtor;
}

- (UIGravityBehavior *)gryBehvior {
    if (!_gryBehvior) {
        //创建重力仿真行为
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
        
        //将重力仿真行为添加到物理仿真器中开始仿真
        [self.animtor addBehavior:_gryBehvior];

    }
    return _gryBehvior;
}

- (UICollisionBehavior *)clnBehavior {
    if (!_clnBehavior) {
        //创建物理碰撞仿真行为
        _clnBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
        //让参照视图的边框成为碰撞检测的边界
        _clnBehavior.translatesReferenceBoundsIntoBoundary = YES;
        _clnBehavior.collisionDelegate = self;

        [_clnBehavior addBoundaryWithIdentifier:@"boudaryID" forPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, viewW, viewH)]];
        
        //将碰撞仿真行为添加到物理仿真器中开始仿真
        [self.animtor addBehavior:_clnBehavior];

    }
    return _clnBehavior;
}

- (CMMotionManager *)manager {
    if (!_manager) {
        // 创建运动管理
        _manager = [[CMMotionManager alloc] init];
        // 设置更新精度
        _manager.deviceMotionUpdateInterval = 0.01;
    }
    return _manager;
}

- (UIDynamicItemBehavior *)itemBehavior {
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc] init];
        // 弹性
        _itemBehavior.elasticity = 1.0;
        [self.animtor addBehavior:_itemBehavior];
    }
    return _itemBehavior;
}
@end

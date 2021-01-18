//
//  ViewController.m
//  Anima
//
//  Created by Davis on 2020/12/19.
//  Copyright © 2020 LJ. All rights reserved.
//

#import "ViewController.h"
#import "GravityCollisionVC.h"
#import "EmitterCellsVC.h"





@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn1 = [self returnButtonWithTitle:@"重力感应"];
    
    UIButton *btn2 = [self returnButtonWithTitle:@"粒子动画"];

    btn1.frame =  CGRectMake(viewW/2.0-50, 100, 100, 40);
    btn2.frame = CGRectMake(viewW/2.0-50, 300, 100, 40);
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
}

- (void)buttonClick:(UIButton*)sender {
    if (sender.tag == 10001) {
        [self.navigationController pushViewController:[GravityCollisionVC new] animated:YES];
    }else {
        [self.navigationController pushViewController:[EmitterCellsVC new] animated:YES];
    }
    
}

- (UIButton *)returnButtonWithTitle:(NSString *)txt {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:txt forState:UIControlStateNormal];
    if ([txt isEqualToString:@"重力感应"]) {
        btn.tag = 10001;
    }
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


@end

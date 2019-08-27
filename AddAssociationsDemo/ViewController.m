//
//  ViewController.m
//  AddAssociationsDemo
//
//  Created by a on 2019/8/27.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "UILabel+Infomation.h"

static NSString * colorName = @"colorName";
// 声明关联键
const void *associatedBlockKey = @"dd";
const void *associatedTypeKey = @"ss";

@interface ViewController ()

@property(nonatomic,strong)UIColor * colorRed;
@property(nonatomic,strong) UILabel * testlabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //调用给分类添加属性-->实例变量
    [self addAssociationLabel];
    //在没有分类、没有继承的情况下，该如何添加实例变量。
    [self addAssociationOnNonCategory];
 
}

#pragma mark------在没有分类、没有继承的情况下，该如何添加实例变量。
-(void)addAssociationOnNonCategory{
    //首先创建一个对象。
    self.colorRed =  [UIColor redColor];
    self.view.backgroundColor = self.colorRed;
    
    NSString * nameClass = @"强红色";
    //添加关联对象
    objc_setAssociatedObject(self.colorRed, &colorName,nameClass, OBJC_ASSOCIATION_RETAIN);
    
    UISwitch *swit = [[UISwitch alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
    [self.view addSubview:swit];
    [swit addTarget:self action:@selector(switAction:) forControlEvents:(UIControlEventValueChanged)];
    
    // 创建要关联的对象值
    void (^block)(BOOL isOn) = ^(BOOL isOn){
        NSLog(@"%d",isOn);
    };
    NSString *type = @"love";
    //  动态添加方法：
    objc_setAssociatedObject(swit, associatedBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //  动态添加实例变量
    objc_setAssociatedObject(swit, associatedTypeKey, type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)switAction:(UISwitch*)sender{
    void (^block)(BOOL isOn) = objc_getAssociatedObject(sender, associatedBlockKey);
    block(sender.isOn);
    NSString *tempType = objc_getAssociatedObject(sender, associatedTypeKey);
    NSLog(@"%@",tempType);
    
//    UIColor * colorGreen =  [UIColor greenColor];
//    self.view.backgroundColor = colorGreen;
    
    NSString * colorNameTime = objc_getAssociatedObject(self.colorRed, &colorName);
    NSLog(@"===%@",colorNameTime);
    
    //改变testlabel的背景色
    [self.testlabel changeBackgroundColor:[UIColor greenColor]];
}



#pragma mark------调用给分类添加属性-->实例变量
//给类添加属性-->实例变量
-(void)addAssociationLabel{
    
    self.testlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.testlabel.name = @"我的名字";
    //    testlabel.text = @"欢乐的小猪";
    self.testlabel.text = self.testlabel.name;
    
    NSLog(@"======%@",self.testlabel.name);
    
    self.testlabel.center = self.view.center;
    
    [self.view addSubview:self.testlabel];

}


@end

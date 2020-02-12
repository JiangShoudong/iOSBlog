//
//  ViewController.m
//  KVO
//
//  Created by JIANG SHOUDONG on 2020/2/10.
//  Copyright © 2020 JIANG SHOUDONG. All rights reserved.
//

/**
 1、作用：监听对象的某个属性值的改变
 2、本质：
         p self.person->isa
 (Class) $0 = NSKVONotifying_NJPerson
 (lldb)  p self.person2->isa
 (Class) $1 = NJPerson
 
 NSKVONotifying_NJPerson：这个类是由Runtime动态创建的类，是NJPerson的子类
 
 methodForSelector 拿到方法实现的内存地址
 通过 p (IMP)0x7fff257223da 可以查到方法在哪里实现的。
 (lldb) p (IMP)0x7fff257223da
 (IMP) $0 = 0x00007fff257223da (Foundation`_NSSetIntValueAndNotify)
 (lldb) p (IMP)0x10bf6ff50
 (IMP) $1 = 0x000000010bf6ff50 (KVO`-[NJPerson setAge:] at NJPerson.h:14)
 */
#import "ViewController.h"
#import "NJPerson.h"
#import <objc/runtime.h>
@interface ViewController ()
@property (nonatomic, strong) NJPerson *person;
@property (nonatomic, strong) NJPerson *person2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.person = [NJPerson new];
    self.person.age = 10;
    
    self.person2 = [NJPerson new];
    self.person2.age = 20;
    
//    NSLog(@"KVO 监听执之前 - %@ - %@", object_getClass(self.person), object_getClass(self.person2));
    NSLog(@"KVO 监听执之前 - %p - %p", [self.person methodForSelector:@selector(setAge:)], [self.person2 methodForSelector:@selector(setAge:)]);
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person addObserver:self forKeyPath:@"age" options:options context:nil];
//    NSLog(@"KVO 监听执之后 - %@ - %@", object_getClass(self.person), object_getClass(self.person2));
    NSLog(@"KVO 监听执之后 - %p - %p", [self.person methodForSelector:@selector(setAge:)], [self.person2 methodForSelector:@selector(setAge:)]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.age = 15;
    self.person2.age = 30;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"监听到%@的%@属性值改变了 %@", object, keyPath, change);
}


- (void)dealloc
{
    [self.person removeObserver:self forKeyPath:@"age"];
}


@end

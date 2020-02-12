//
//  NSKVONotifying_NJPerson.m
//  KVO
//
//  Created by JIANG SHOUDONG on 2020/2/10.
//  Copyright © 2020 JIANG SHOUDONG. All rights reserved.
//

#import "NSKVONotifying_NJPerson.h"

@implementation NSKVONotifying_NJPerson

- (void)setAge:(int)age
{
    _NSSetIntValueAndNotify();
}
void _NSSetIntValueAndNotify()
{
//    [self willChangeValueForKey:@"age"];
//    [super setAge:age];
//    [self didChangeValueForKey:@"age"];
}
- (void)didChangeValueForKey:(NSString *)key
{
//    伪代码
//    通知监听器，属性值发生改变
//    [observer observerValueForKeyPath: key ofObject: self change: nil context: nil];
}

@end

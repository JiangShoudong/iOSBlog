# OC对象的本质
## 1、OC和C、C++
- OC代码，底层实现其实都是C\C++代码
- 所以OC 的面向对象都是基于C\C++的数据结构实现的
- OC的对象和类主要是基于C\C++的结构体实现的

## 2、OC 代码转为C++
xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main-arm64.cpp
在命令行中可以将OC代码转为指定平台、指定架构的c++代码

## 3、NSObject的内存本质
- 通过查看源码发现NSObject的本质
```
@interface NSObject {
    Class isa;
}
@end
```
- 在c++文件中对应结构体
`struct NSObject_IMPL {
    Class isa; 
};`

- [下载苹果源码](https://opensource.apple.com/tarballs)
- 通过下载objc源码，搜索 class_getInstanceSize 和 allocWithZone 实现，可以发现，创建一个NSObjec的对象开辟的内存空间是16 
```
 size_t instanceSize(size_t extraBytes) {
        size_t size = alignedInstanceSize() + extraBytes;
        // CF requires all objects be at least 16 bytes.
        if (size < 16) size = 16;
        return size;
    }
```

## 4、面试题：一个NSObject 对象占用多少内存？

- 系统分配了16个字节给NSObject对象（可以通过malloc_size函数获得）
- 但是NSObject对象内部只使用了8个字节的空间（64bit 环境下，可以通过class_getInstanceSize 获得）

## 5、窥探NSObject的内存
xcode中, 通过打断点，然后 Debug -> Debug Workflow -> View Memory， 输入对象的内存地址，查看内存布局。

- 结构体存在内存对齐： 结构体的内存必须是最大成员变量内存的倍数，为了提高CPU的访问速度。

- 苹果自己的内存的对齐: iOS 里面，堆空间分配的内存都是16的倍数.  提高内存的分配速度。
- Linux也有自己的内存对齐，gnu全称是gnu is not unix， 开源组织，Linux里面用了很多gnu的做法。

## 六、sizeof 注意点
- 本质是一个运算符，不是一个函数，在程序执行中就变成了常数，传的是类型
- 编译的时候就会确定值的大小
- class_getInstanceSize() 是一个函数，传入的是一个类。

## 七、OC对象的分类
- OC中的对象主要分为3种
  	- **instance**对象（实例对象）
  	- **class**对象（类对象）
  	- **meta-class**对象（元类对象）
- **instance**对象（实例对象）
	- **instance**对象就是通过类alloc出来的对象，每次调用alloca都会产生新的instance对象；
	- **instance**对象在内存中存储的信息包括 
		- isa指针
		- 其他成员变量
- **class**对象（类对象）
	- 一个类的类对象是唯一的，在内存中只有一份。
	- class对象在内存中存储的信息包括
		- isa 指针
		- superclass 指针
		- 类的**属性**信息（@property）、类的**对象方法**信息（instance method）
		- 类的**协议**信息（Protocol）、类的**成员变量**信息（ivar）（是描述信息，比如成员变量的名字等等）
- **meta-class**对象（元类对象）
	- meta-data 元数据，描述数据的数据
	- 每个类在内存中只有一个元类对象
	- meta-class 对象 和 class 对象的内存结构是一样的，但是用途不一样，在内存中存储的信息主要包括
		- isa指针
		- superclass 指针
		- 类的类方法信息（class method）
		- ...

## 八、isa和superclass
- isa指针
	- instance对象 的isa 指向 class 对象
	- class 对象的 isa 指向 meta-class 对象
	- meta-class 对象的isa 指向基类的meta-class对象；
	- **从64bit开始，isa需要进行一次位运算，才能计算出真实地址（& ISA_MSAK）**
- superclass指针
	- class 对象的superclass 指向父类的class对象
		- 如果没有父类，superclass 指针为nil
	- meta-class对象的superclass 指向父类的 meta-class 对象
		- 基类的meta-class对象 指向 基类的类对象。
## 九、面试题：对象的isa指针指向哪里？
- 实例对象的isa指针指向类对象
- 类对象的isa指针指向元类对象
- 元类对象的isa指针指向基类的元类对象
## 十、面试题：OC的类信息存放在哪里？
- 属性信息，对象方法，协议信息，成员变量信息存放在类对象中；
- 类方法信息存放在元类对象中
- 成员变量的值存放在实例对象中
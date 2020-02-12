## KVO & KVC

## KVO
### 1、iOS 用什么方式实现对一个对象的KVO（KVO的本质是什么）
- 利用runtime API 动态生成一个子类，并且让实例对象的isa 指向这个子类的类对象
- 当修改实例对象的属性时，会调用Foundation框架离得_NSSetxxValueAndNotify 函数，这个函数干了一下几件事情：
	- 调用 `willChangeValueForKey `
	- 父类原来的`setter `，setter 被重写
	- `didChangeValueForKey `，内部会出发observer的 监听方法
		- ```observeValueForKeyPath: ofObject:context:```
		
### 2、如何手动出发KVO
- 调用observer 的`willChangeValueForKey `
- `didChangeValueForKey ` , 内部会检查是否调用 `willChangeValueForKey `，如果没有调用，则不会触发

### 3、直接修改成员变量会出发KVO吗？？
- 不会
- KVO的本质是重写setter方法+KVO本质

## KVC

- 本质：
	- 先寻找 setKey  _setKey ，找到赋值
	- 如果没有找到，并且这个类允许直接访问实例对象的变量, 否则报错
		- `+ (BOOL)accessInstanceVariablesDirectly`， 默认返回YES
	- 依次查找 _key， _isKey， key， isKey
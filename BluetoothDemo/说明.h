//
//  Header.h
//  BluetoothDemo
//
//  Created by airende on 2017/6/5.
//  Copyright © 2017年 airende. All rights reserved.
//

『十月宝贝』移入『微脉』过程中的问题

-- 项目移入方面
1.由于"十月宝贝"是比较早起的项目，可能一些配置存在差异，导致项目无法编译。
2."微脉"项目中并不是完全接入"十月宝贝",所以很多代码需要移除。不需要的代码移入导致代码臃肿。
3."十月宝贝"中各个类之间的关联比较大。

- 导致  整体拖入项目(X) -> 以文件为单位移入项目(X) -> 以类为单位移入项目(V) 该过程耽误 2天

-- UI方面
1."十月宝贝"早起代码，只做3.4和4寸的屏幕处理，到之后的4.7和5.5寸的布局错误，需完全重写布局。
2."十月宝贝"使用了国际化的东西，很多地方的文案需要修改。
3.tabbar方面，需要自己根据需求自定义视图，顺带了些后退返回的问题。


-- 网络接口方面
1.网络方面，"十月宝贝"中使用manager管理类来实现网络请求，并且使用的同步请求。与"微脉"完全不符。
2.由于各种原因，网络请求都是用的"微脉"自己的服务。
3.网络接口提示错误和loading的问题

-- 代码方面
1.视图布局规格和使用一些比较特殊的桑三方实现简单的功能。导致代码复杂不好修改。
2."十月宝贝"和"微脉"中用户使用权限不一致，导致很多权限代码需要修改删除。


六、微信项目(ipad/iphone版本) ios7

1.创建项目，用git版控制
2.导入xmppframwork框架
3.导入APPICON 启动图片
4.简单的做下登录界面(iphone / ipad 适配)
5.实现登录
(a) 登录成功之后，来主界面
(b) 登录失败要提示

"当Openfire后台登录不了，然后客户端也登录了，但是服务器确实是开始状态，原因是mac版openfire不太稳定"

如果在公司开发中 使用的openfire是linux版

解决办法
删除Openfire 重新安装

"怎么删除"
step1:打开命令行，切换到 "xmpp ▸ 资源 ▸ 删除xmpp环境"目录
step2:执行命令 "sudo ./deleteOpenfire"

"【登录细节】"
》如果用户注销后，回来登陆界面，直接显示上次登录过的帐号
把用户数据保存沙盒
"什么情况下才需要把数据保存到沙盒，用户登录成功后"

启动程序的时候，再从沙盒获取数据

》用户登录成功后，如果关闭APP,重新起动程序，如果没有注销，直接来到主界面
1》记录下登录状态

》如果用户登录过，重新启动程序时候，自动登录到服务器


6.注册
》要提示
》注册成功后，回到上一个页面，上一个页面的用户label是显示注册的用户名
》提示，请重新输入密码进行登录

"为什么把所有的xmpp操作，eg。登录、注册、注销放在appDelegate里面？"
原因：因为跟服务器交互的类XMPPStream,这个类在整个程序运行过程中，只有要一个实例(对象)
所以:把xmppStream这个对象放在某一个地方，给其它所有的控制获取到（共享）


"打开XMPP日志"





7.实现主界面


8.获取个人信息(头像、电话、邮箱....)
获取个人信息 在xmpp里面，称为"电子名片信息"

》添加电子名片模块
》一般电子模块配合头像模块使用
》怎么从sqlite里获取个人信息
'使用电子名片模块的一个属性myvCardTemp'

》怎么更新个人信息
'使用电子名片模块的一个方法updateMyvCardTemp'


"如何Spark不能使用，安装资源里JavaForOSX2014-001.dmg文件就可以了"


"安装Subline xml格式化"
{ "keys": ["ctrl+shift+x"], "command": "tidy_xml" },
//command + shift+x


"【模块开发】"
xmpp里的开发基本上是基于模块开发
》电子名片模块
》头像模块
》自动连接模块


9.获取好友列表 添加添加好友 删除好
"花名册模块"

10.发送聊天消息
"消息模块"
添加消息模块-如果接收到好友发来的聊天数据，把聊天数据放在本地一个数据库

"添加模块的步骤"
1》打开模块的头部文件
2》创建模块对象
3》激活模块
4》在delealloc里做模块对象销毁


11.实现文件传输(二进制 NSData)
发送图片
发送音频
发送文档doc text


12.自己解析电子名片未解析的字段
"邮件"

13.自动登录提示

14.程序登录到后台，聊天信息通知

在ios8以前，不包括ios8,socket 是不支持后台运行

a>在ios7要做配置info.plist文件
添加 Required background modes ＝ voip; //使用soket在后台运行
b> 添加_xmppStream.enableBackgroundingOnSocket = YES;代码
c> 真机上才可能看见本通知效果



XMPP总结
XMPP　是一个即时通讯的传输协议　传输入的数据都ｘｍｌ
基本模块开发

自动连接模块 //网络不稳定 断线的时候， 自动连接服务器
电子名片模块 //获取个人信息 保存到数据库
头像模块 //获取头像的图片
花名册模块 //获取好友列表 保存到数据库
消息模块　//接收到到聊天消息 保存到数据库

XMPP是通知Socket开发，也是基于TCP协议
XMPP 跟服务交互的核心类XMPPStream
XMPPStream 里面有个CGDAsynSocket对象

CGDAsynSocket 有C语言的CFReadStreamRef CFWriteStream输入输出流

//辛辛苦苦搭建xmpp环境
//删除xmpp环境
//执行一个命令
sudo ./deleteAll




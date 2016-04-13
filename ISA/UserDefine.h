//
//  UserDefine.h
//  News
//
//  Created by apple on 14-11-16.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#ifndef News_UserDefine_h
#define News_UserDefine_h

#define NUMBERS @"0123456789"

// 4.加载JSON对象
#define NJJson(name) [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@#name withExtension:nil]] options:NSJSONReadingAllowFragments error:nil]

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)

#define fNavBarHeigth (IOS7==YES ? 64 : 44)

#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height-StatusBarHeight)


#define kSCREEN_WIDTH [ReturnDeviceType sizeOfScreen].size.width
#define kSCREEN_HEIGHT [ReturnDeviceType sizeOfScreen].size.height

#define JX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height-20

#define kUserName    @"userName"
#define kPassword    @"password"
#define kServerHost  @"serverHost"
#define kDomain      @"@sfware"

#define isNetConnected (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) && ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable) ? NO : YES )

#define isWWAN ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN)?YES:NO



#define NJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define NJGlobalBg [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]

//总接口用于图片传输
#define zongdizhiURL @"http://121.42.14.252:8081/fm"
//推荐接口
#define tuijianListURL @"http://121.42.14.252:8081/fm/a/api/tuijian"
//分类接口
#define fenleiListURl @"http://121.42.14.252:8081/fm/a/api/fenlei"
//查看个人信息接口
#define userInfoURL @"http://121.42.14.252:8081/fm/a/api/save?files=&userId="
//登录接口
#define loginListURL @"http://121.42.14.252:8081/fm/a/api/loginflag"

//#define loginListURL @"http://121.42.14.252:8081/fm/a/api/loginflag?loginName=%@&password=%@",username.text,password.text
//游客直接收听接口
#define youkeListenUrl @"http://121.42.14.252:8081/fm/a/api/tourist"

//第三方收听接口
#define sanfangListenUrl @"http://121.42.14.252:8081//fm/a/api/loginflag1?username=%@&url=%@&appInfo=%@,%@,%@",usernamee,url,identifierForVendor,udid,shebi

//背景图片
#define imgInfoURL @"http://121.42.14.252:8081/fm/a/api/imgList"
//36.调查问卷答题记录接口

#define saveRecordURL @"http://121.42.14.252:8081/fm/a/api/saveRecord_/"

//试卷
#define shijuanURL @"http://121.42.14.252:8081/fm/a/api/papersList"
//20.调查问卷试题列表接口
#define subjectsListURL  @"http://121.42.14.252:8081/fm/a/api/subjectsList"

//发送验证码
#define yanzhengmaURL @"http://121.42.14.252:8081/fm/a/api/getcode"

//学历职业
#define zhixueURL @"http://121.42.14.252:8081/fm/a/api/userProperty"

//完善信息接口
#define xinixURL @"http://121.42.14.252:8081/fm/a/api/initInfo"

#define personMessage @"http://121.42.14.252:8081/fm/a/api/userInfo"

 //2.2第三方登录接口（第一次登录）
#define diyiLoginURL @"http://121.42.14.252:8081/fm/a/api/loginflag2?loginName=%@&code=%@&appInfo=%@,%@,%@&name=%@&url=%@",username.text,password.text,identifierForVendor,devicemodel,os,self.a,self.b

//2.1第三方登录接口（已有账号）
#define yiyouLoginURL @"http://121.42.14.252:8081/fm/a/api/loginflag1?loginName=%@&password=%@&appInfo=%@,%@,%@&name=%@&url=%@",username.text, password.text,identifierForVendor,devicemodel,os,self.a,self.b


//验证验证码
#define yazhengURL @"http://121.42.14.252:8081/fm/a/api/validateCode"
//听众直接注册接口
#define zhuceListURL @"http://121.42.14.252:8081/fm/a/api/register"
//游客注册接口
#define youkeListURL @"http://121.42.14.252:8081/fm/a/api/register"
//第三方完善注册接口
#define sanfangListURL @"http://121.42.14.252:8081/fm/a/api/register1?username=%@&password=%@&email=%@&car=%@&appId=%@",username,password.text,email,car,appId

//qq第一次登录
#define thirdRegisterURL @"http://121.42.14.252:8081/fm/a/api/thirdRegister"

//qq验证登录
#define existThirdUserURL @"http://121.42.14.252:8081/fm/a/api/existThirdUser"

//?30.电台详情
#define diantaiURL @"http://121.42.14.252:8081/fm/a/api/diantai?id=%@",idq


//修改密码
#define changenUrl @"http://121.42.14.252:8081/fm/a/api/changePassword"

//找回密码接口
#define resetpasswordURL @"http://121.42.14.252:8081/fm/a/api/resetpassword"

//验证找回密码接口
#define resetpassURL @"http://121.42.14.252:8081/fm/a/api/resetpassword1"
///6张图片
#define imgsixURL @"http://121.42.14.252:8081/fm/a/api/guanggao"

#define six @"http://121.42.14.252:8081/fm"

//分享
#define  fenxiangURL @"http://121.42.14.252:8081/fm/a/api/share?channelId=%@",channelId

//查看收藏接口

#define shoucangListURL @"http://121.42.14.252:8081/fm/a/api/shoucangList"

//添加收藏接口
#define addShoucangURL @"http://121.42.14.252:8081/fm/a/api/addshoucang"
//取消收藏接口
#define removeshoucangURL @"http://121.42.14.252:8081/fm/a/api/removeshoucang"
//添加收听接口
#define addshoutingUrl @"http://121.42.14.252:8081/fm/a/api/addshouting"
//电台节目列表接口
#define programmeListUrl @"http://121.42.14.252:8081/fm/a/api/programmeList"

// unmber number prmId  programmeId 最后要改传的时候先问下

//节目评价接口
#define pingfenUrL @"http://121.42.14.252:8081/fm/a/api/pingfen"
//节目点赞接口
#define dianzanUrL @"http://121.42.14.252:8081/fm/a/api/dianzan"

//分类下级的接口
#define subfenleiUrl @"http://121.42.14.252:8081/fm/a/api/diantailist"

//搜索的接口
#define sousuoUrl @"http://121.42.14.252:8081/fm/a/api/sousuo"

//分类地区的接口

#define diqufenleiUrl @"http://121.42.14.252:8081/fm/a/api/diantailist"

//分类haiz下级的接口
#define fenliListUrl @"http://121.42.14.252:8081/fm/a/api/subfenlei"

//礼品列表
#define giftListUrl @"http://121.42.14.252:8081/fm/a/api/giftList"
//听众兑换礼品
#define exchangeGiftUrl @"http://121.42.14.252:8081/fm/a/api/exchangeGift"
//用户积分查询
#define userInfoUrl @"http://121.42.14.252:8081/fm/a/api/userInfo"
//个人兑换记录
#define exchangeListUrl @"http://121.42.14.252:8081/fm/a/api/exchangeList"


//听众上传图像
#define saveImgURL @"http://121.42.14.252:8081/fm/a/api/save"
//常见问题列表
#define quaURL @"http://121.42.14.252:8081/fm/a/api/defectList"

//意见反馈接口
#define feedbackUrl @"http://121.42.14.252:8081/fm/a/api/feedback"
//查看收听历史接口
#define shoutingListUrl @"http://121.42.14.252:8081/fm/a/api/shoutingList"
//获取版本号接口
#define versionUrl @"http://121.42.14.252:8081/fiyang/a/api/versionIOS"


//心跳  开始
#define startHeartUrl @"http://121.42.14.252:8081/fm/a/api/queue"
//心跳 停止
#define stopHeartUrl @"http://121.42.14.252:8081/fm/a/api/queue"

//供求详细接口
#define GongQiuXiangXiInfo @"http://117.34.92.93/app/getCoal/"
#endif

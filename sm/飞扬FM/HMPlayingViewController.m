//
//  HMPlayingViewController.m
//  02-黑马音乐
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMPlayingViewController.h"
#import "scModel.h"
#import "HMMusicTool.h"
#import "HMAudioTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Vitamio.h"
#import "JingRoundView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+header.h"
#import "UserDefine.h"
#import "ZYJWeekModel.h"
#import "MJExtension.h"
#import "HTTPManager.h"
#import "Statics.h"
#import "MJExtension.h"
#import "HTTPManager.h"
#import "MBProgressHUD+NJ.h"
#import "dianzanViewController.h"
#import "jiemuViewController.h"
#import "MMLocationManager.h"

#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/QuartzCore.h>
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "loginViewController.h"
#import "MyXMPP.h"

#import "jiemuD.h"
#import "Reachability.h"
#import "liantianView.h"

#import "NJMessageModel.h"
#import "NJMessageCell.h"
#import "NJMessageFrameModel.h"

#import "XMPPRoom.h"
#import "XMPPRoomMemoryStorage.h"
#import "XMPPMessage+XEP0045.h"
#import "MyXMPP.h"

#import "FaceViewController.h"
#import "UIView+Extension.h"
#import "DownSheet.h"

static NSString *_allbiqing;

@interface HMPlayingViewController ()<UITableViewDataSource, UITableViewDelegate,VMediaPlayerDelegate,JingRoundViewDelegate,UITextFieldDelegate,liantianDegate,biaoqingDegate,DownSheetDelegate>{
    BOOL didPrepared;
    NSDate *currenttime;
    NSMutableDictionary *_jiemuNarry;
    NSString *channelId,*coordinate,*_appId,*_date,*_programmeId;
    UIActionSheet *_myActionSheet;
    NSTimer   *mSyncSeekTimer;
    
    NSArray *_Imgbac;
    int iimg;
    int status;
 //保存收藏和最近收听
    NSMutableArray *_personArray;
    NSData *startTm;
    liantianView *liaotian;
    XMPPRoomMemoryStorage * _roomMemory;
    FaceViewController* _faceView;
    NSString *_biaoqing;
    
    long long _allTime,_PointTime,starttime,endtime;
    float progress;
    NSArray *MenuList;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)exit;
- (IBAction)lyricOrPic:(UIButton *)sender;
- (IBAction)downSheet:(id)sender;

@property(nonatomic, strong) XMPPRoom* xmppRoom;

@property (nonatomic, weak) HTTPManager *mgr;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)ZYJdic *ZYJdic;
@property(nonatomic,strong)NSString *userId, *pers;

@property (weak, nonatomic) IBOutlet UIView *prossgressView;
@property (weak, nonatomic) IBOutlet UIButton *sliderw;

@property (weak, nonatomic) UIImage *icon;
@property (weak, nonatomic) IBOutlet UIImageView *bacImg;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) scModel *playingMusic;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *slider;
@property (weak, nonatomic) IBOutlet UIButton *currentTimeView;

@property (weak, nonatomic) IBOutlet JingRoundView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *starttimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endtimeLab;

@property (weak, nonatomic) IBOutlet UIButton *tanmu;
- (IBAction)tanmuBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shoucang;

@property (strong,nonatomic) VMediaPlayer *mMPayer;
@property (strong,nonatomic) MMLocationManager *location;
@property (nonatomic,retain)NSString* videoPath;


@property (nonatomic, strong) NSMutableArray *messages;
// 存放所有的自动回复数据
@property (nonatomic, strong) NSDictionary *autoReplays;

/**
 *  播放进度定时器
 */
@property (nonatomic, strong) NSTimer *currentTimeTimer, *jinducurrentTimeTimer;

@property (nonatomic, strong) NSTimer *currentBacimgTimer;
/**
 *  歌词显示的定时器
 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;
- (IBAction)previous;
- (IBAction)next;
- (IBAction)playOrPause;
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender;
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
//@property (weak, nonatomic) IBOutlet HMLrcView *lrcView;

@end

@implementation HMPlayingViewController

#pragma mark - 懒加载
- (HTTPManager *)mgr
{
    if (!_mgr) {
        _mgr = [HTTPManager shareManager];
    }
    return _mgr;
}
+(instancetype)musicView
{
    static HMPlayingViewController *music = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        music = [[HMPlayingViewController alloc]init];
    });
    
    return music;
}

#pragma mark - 懒加载
- (NSMutableArray *)messages
{
    if (_messages == nil) {
        NSArray *dictArray = [HMMusicTool liaotianMessage];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        // 记录上一次的消息模型
        // NJMessageModel *previousMessage = nil;
        for (NSDictionary *dict in dictArray) {
            // 1.创建当前数据模型
            NJMessageModel *message = [NJMessageModel messageModelWithDict:dict];
            
            
            // 获取上一次的数据模型
            NJMessageModel *previousMessage = (NJMessageModel *)[[models lastObject] message];
            // 设置是否需要隐藏时间
            message.hiddenTime = [message.time isEqualToString:previousMessage.time];
            
            
            // 根据创建frame模型
            NJMessageFrameModel *mfm = [[NJMessageFrameModel alloc] init];
            // 因为该方法中计算了frame, 所以在后面再比较没有意义
            mfm.message = message;
      
            // 将frame模型保存到数组中
            [models addObject:mfm];
            
            // previousMessage = message;
        }
        self.messages = [models mutableCopy];
    }
    return _messages;
}
- (NSDictionary *)autoReplays
{
    if (_autoReplays == nil) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"autoReplay.plist" ofType:nil];
        _autoReplays = [NSDictionary dictionaryWithContentsOfFile:fullPath];
    }
    return _autoReplays;
}


-(void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"%@",_musicList);
    
    //开始播放音乐
    [self  startPlayingMusic];
    
    //收藏按钮的状态
    
    [self shoucangImg];
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    _dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    _ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];
    
    _userId = _ZYJdic.id;
    
    status  = _ZYJdic.status;
    
    _appId = _ZYJdic.appId;
    NSDictionary *loc = [defaults objectForKey:@"dingwei"];
    
    coordinate = [loc objectForKey:@"loc"];
    
    [self jianceNet];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self iniPlayer];
    
    [self loadtableView];
    
    liaotian = [[liantianView alloc]init];

    liaotian.frame = CGRectMake(0, 525, self.view.frame.size.width, 44);
    
    liaotian.hidden = YES;
    
    liaotian.delegate = self;
    
    [self.view addSubview:liaotian];
     
    _jiemuNarry = [NSMutableDictionary dictionary];
    
    _faceView = [[FaceViewController alloc]initWithFrame:CGRectMake(0, 610, 320, 160)];
    
    _faceView.degate = self;
    [self.view addSubview:_faceView];
    
    
    [self initDemoData];

    
    // KVO监听streamer的属性（Key value Observing）
      [self.playingMusic addObserver:self forKeyPath:@"url" options:NSKeyValueObservingOptionOld context:nil];

//    [self.mMPayer addObserver:self forKeyPath:@"" options:NSKeyValueObservingOptionNew context:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOr:) name:@"playOrPause" object:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextOr:) name:@"nextMUS" object:nil];
    
     NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
     NSTimeInterval aa=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
     _date = [NSString stringWithFormat:@"%.0f", aa]; //转为字符型
     iimg = 0;
    
    _allbiqing  = [NSString new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
}

-(void)initDemoData{
    DownSheetModel *Model_1 = [[DownSheetModel alloc]init];
    Model_1.icon = @"player_zan_btn";
    Model_1.icon_on = @"user_info_shoucang_select";
    Model_1.title = @"收藏";
    DownSheetModel *Model_2 = [[DownSheetModel alloc]init];
    Model_2.icon = @"player_time_btn";
    Model_2.icon_on = @"icon_album_hover";
    Model_2.title = @"分享";
    DownSheetModel *Model_3 = [[DownSheetModel alloc]init];
    Model_3.icon = @"player_download_btn";
    Model_3.icon_on = @"icon_buy_hover";
    Model_3.title = @"评分";
    DownSheetModel *Model_4 = [[DownSheetModel alloc]init];
    Model_4.icon = @"player_message_btn";
    Model_4.icon_on = @"icon_computer_hover";
    Model_4.title = @"定时";
    DownSheetModel *Model_5 = [[DownSheetModel alloc]init];
    Model_5.icon = @"user_info_yuyue";
    Model_5.icon_on = @"icon_down_hover";
    Model_5.title = @"预约";
    MenuList = [[NSArray alloc]init];
    MenuList = @[Model_1,Model_2,Model_3,Model_4,Model_5];
}

- (IBAction)downSheet:(id)sender {
    DownSheet *sheet = [[DownSheet alloc]initWithlist:MenuList height:0];
    sheet.delegate = self;
    [sheet showInView:self];

}
-(void)didSelectIndex:(NSInteger)index{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您当前点击的是第%d个按钮",index] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    if (index == 0) {
        
        if (status == 1 ) {
            
            [HMMusicTool setshouCang:self.playingMusic.name];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"userId"] = _userId;
            parameters[@"channelId"] = self.playingMusic.id;
            
            [self.mgr getPath:addShoucangURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = nil;
                
                NSData *jsonData = responseObject;
                
                if ([jsonData length]>0 && error == nil) {
                    
                    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                    NSString *aStr = (NSString *)jsonObj;
                    //字典数组转模型数组
                    
                    if ( [aStr intValue] == 1) {
                        
                        [_shoucang setImage:[UIImage imageNamed:@"user_info_shoucang_select"] forState:UIControlStateNormal];
                        
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showSuccess:@"收藏成功！"];
                        
                        
                        
                        return;
                    }
                    else  if ([aStr intValue] == -1) {
                        
                        [_shoucang setImage:[UIImage imageNamed:@"user_info_shoucang_select"] forState:UIControlStateNormal];
                        
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"已经收藏了！"];
                        return;
                    }
                    else if ([aStr intValue] == 0) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"请先登录！"];
                        
                        return;
                    }
                    else if ( [aStr intValue] == -2) {
                        
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"收藏失败！"];
                        
                        return;
                    }
                    
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"ss");
                
            }];
            
        }else{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UINavigationController *nav =  [storyboard instantiateViewControllerWithIdentifier:@"navde"];
            
            [self presentViewController:nav animated:YES completion:nil];
            
        }

    }else if (index ==1 )
    {
        [self showShareActionSheet:self.view];
    }else if (index == 2)
    {
        if (status == 1 ) {
            
            dianzanViewController *dz = [[dianzanViewController alloc]init];
            
            dz.program = _programmeId;
            [self presentViewController:dz animated:YES completion:nil];
        }else{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UINavigationController *nav =  [storyboard instantiateViewControllerWithIdentifier:@"navde"];
            
            [self presentViewController:nav animated:YES completion:nil];
            
        }

        
    }else if (index == 3)
    {
        _myActionSheet = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                          //                     otherButtonTitles: @"从手机相册获取"
                          otherButtonTitles: @"取消定时关机",@"10分钟",@"20分钟",@"30分钟",@"60分钟",@"90分钟",@"120分钟",@"节目播放完自动关闭",nil];
        //                        otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
        
        [_myActionSheet showInView:self.view];

    }else
    {
        
    }
}



-(void)liaotian:(NSNotification  *)notification
{
    /*
     userInfo = {
     // 键盘弹出的节奏
     UIKeyboardAnimationCurveUserInfoKey = 7;
     //键盘弹出执行动画的时间
     UIKeyboardAnimationDurationUserInfoKey = "0.25";      UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 216}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 588}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 372}";
     UIKeyboardFrameChangedByUserInteraction = 0;
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";
     
     // 键盘弹出时候的frame
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 264}, {320, 216}}";
     
     // 键盘隐藏时候的frame
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";
     }}
     
     */
    NSLog(@"键盘弹出 %@", notification);
    
    /*
     计算需要移动的距离
     弹出的时候移动的值 = 键盘的Y值 – 控制view的高度 = 要移动的距离
     -  480 = -216
     
     隐藏的时候移动的值 = 键盘的Y值 - 控制view的高度 = 要移动的距离
     480 -  480 = 0
     */
    // 1.获取键盘的Y值
    NSDictionary *dict  = notification.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    // 2.计算需要移动的距离
    CGFloat translationY = keyboardY - self.view.frame.size.height;
    // 通过动画移动view
    /*
     [UIView animateWithDuration:duration animations:^{
     self.view.transform = CGAffineTransformMakeTranslation(0, translationY);
     }];
     */
    /*
     输入框和键盘之间会由一条黑色的线条, 产生线条的原因是键盘弹出时执行动画的节奏和我们让控制器view移动的动画的节奏不一致导致
     */
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        // 需要执行动画的代码
        liaotian.transform = CGAffineTransformMakeTranslation(0, translationY);
        [liaotian.emojin setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];

        if (translationY == 0) {
            self.tableView.transform = CGAffineTransformMakeTranslation(0, translationY);
        }else{
            self.tableView.transform = CGAffineTransformMakeTranslation(0, translationY + 50);
             _faceView.transform = CGAffineTransformMakeTranslation(0, 0);
                  }
    } completion:^(BOOL finished) {
        // 动画执行完毕执行的代码
    }];
    
}

-(void)emojint
{

    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view endEditing:YES];
         self.tableView.transform = CGAffineTransformMakeTranslation(0, -110);
        liaotian.transform = CGAffineTransformMakeTranslation(0, -159);
        _faceView.transform = CGAffineTransformMakeTranslation(0, -200);
        [liaotian.emojin setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        //
    }];
}

-(void)emojin:(NSString *)biaoqing
{
    _biaoqing = [NSString stringWithFormat:@"-%@-",biaoqing];
    
    _allbiqing = [_allbiqing stringByAppendingString:_biaoqing];
    
    liaotian.inputTextField.text = _allbiqing;
}

-(void)deteaction
{
    NSString* s = liaotian.inputTextField.text;
    
    if([s length]<=0)
        return;
    int n=-1;
    if( [s characterAtIndex:[s length]-1] == '-'){
        for(int i=[s length]-1;i>=0;i--){
            if( [s characterAtIndex:i] == '-' ){
                n = i;
                break;
            }
        }
    }
    if(n>=0)
        liaotian.inputTextField.text = [s substringWithRange:NSMakeRange(0,n)];
    else
        liaotian.inputTextField.text = [s substringToIndex:[s length]-1];
    _allbiqing = @"";

}

-(void)liantianxinxi:(UITextField *)textField
{
  //发送消息
    
         _allbiqing = @"";
    
        // 创建自己发送的消息
        [self addMessage:textField.text type:NJMessageModelTypeMe];
        // 创建别人发送的消息
    
        //    NSString *result = [self autoReplayWithContent:textField.text];
        //    [self addMessage:result type:NJMessageModelTypeOther];
    
        // 2.刷新表格
        [self.tableView reloadData];
    
        // 3.让tableveiw滚动到最后一行
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    NSString *mesStr = textField.text;
    
    NSString *haol = [NSString stringWithFormat:@"%@%s",_programmeId,"@conference.sfware"];
    
    
    XMPPJID *chatToJid = [XMPPJID jidWithString:haol];
    
    //创建一个消息对象，并且指明接收者
    XMPPMessage *message = [XMPPMessage messageWithType:@"groupchat" to:chatToJid];
    //设置消息内容
    
    if ([Statics stringContainsEmoji:mesStr] == NO) {
        [message addBody:mesStr];
        //发送消息
        [[MyXMPP sharedMyXMPP].xmppStream sendElement:message];
    }
    
    if ([Statics stringContainsEmoji:mesStr] == YES) {
        
        //            mesStr  = [Photo image2String:mesStr];
        mesStr = @"):";
        [message addBody:mesStr];
        //发送消息
        [[MyXMPP sharedMyXMPP].xmppStream sendElement:message];
    }
            /*
         AtIndexPath: 要滚动到哪一行
         atScrollPosition:滚动到哪一行的什么位置
         animated:是否需要滚动动画
         */
}

// 传入给定内容返回自动回复的内容
- (NSString *)autoReplayWithContent:(NSString *)content
{
    // 取出用户输入的每一个字
    NSString *result = nil;
    for (int i = 0; i < content.length; i++) {
        // @"我爱你";
        //   0 1 2
        NSString *str = [content substringWithRange:NSMakeRange(i, 1)];
        //        NSLog(@"%@", str);
        result = self.autoReplays[str];
        if (result != nil) {// 代表找到了自动回复的内容
            break;
        }
    }
    
    if (result == nil) {
        result = [NSString stringWithFormat:@"%@", content];
    }
    
    return result;
}


// 添加一条消息
- (void)addMessage:(NSString *)content type:(NJMessageModelType)type
{
    // 1.修改模型(创建模型, 并且将模型保存到数组中)
    
    // 获取上一次的message
    NJMessageModel *previousMessage = ( NJMessageModel *)[[self.messages lastObject] message];
    
    if (![previousMessage.text isEqualToString:content]) {
        NJMessageModel *message = [[NJMessageModel alloc] init];
        // 实现把当前时间作为发送时间
        NSDate *date = [NSDate date]; // 创建时间对象
        //    NSLog(@"%@", date);
        // 可以将时间转换为字符串
        // 也可以将字符串转换为时间
        // 2014-05-31
        // 2014/05/31
        // 05/31/2014
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // HH 代表24小时 hh代表12小时
        formatter.dateFormat = @"HH:mm";
        NSString *time = [formatter stringFromDate:date];
        
        NSLog(@"time = %@", time);
        message.time = time;
        message.text = content;
        message.type = type;
        message.hiddenTime = [message.time isEqualToString:previousMessage.time];
        
        //根据message模型创建frame模型
        NJMessageFrameModel *mf = [[NJMessageFrameModel alloc] init];
        mf.message = message;
        
        [self.messages addObject:mf];
    }
}

-(void)loadtableView{
    
    // 设置隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置隐藏垂直的滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.dataSource=self;
    _tableView.delegate=self;

    // 设置tableview的背景颜色
//    self.tableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 设置cell不可以被选中
    self.tableView.allowsSelection = NO;
    
    self.tableView.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    NJMessageCell *cell = [NJMessageCell cellWithTableView:tableView];
    // 2.设置数据
    cell.messageFrame = self.messages[indexPath.row];
    // 3.返回cell
    return cell;
}

#pragma mark - UITableViewDelegate
// 该方法有多少条数据就会调用多少次
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出frame模型
    NJMessageFrameModel *mf = self.messages[indexPath.row];
    // 2.返回对应行的高度
    return mf.cellHeight;
}

//滚动下滑

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view endEditing:YES];
        self.tableView.transform = CGAffineTransformMakeTranslation(0, 0);
        liaotian.transform = CGAffineTransformMakeTranslation(0, 0);
        _faceView.transform = CGAffineTransformMakeTranslation(0, 0);
        [liaotian.emojin setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        //
    }];

}

- (IBAction)tanmuBtn:(id)sender {
    NSString *name = [NSString stringWithFormat:@"%@%@" ,_userId, @"@sfware"];
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] setObject:@"121.42.14.252" forKey:kServerHost];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[MyXMPP sharedMyXMPP] connect];    

    if ( liaotian.hidden) {
        [self joinInChatRoom];
        liaotian.hidden = NO;
        self.tableView.hidden = NO;
        [liaotian.inputTextField becomeFirstResponder];
         [self.tanmu setImage:[UIImage imageNamed:@"close_chat_btn"] forState:UIControlStateNormal];
    }else {
        liaotian.hidden = YES;
        self.tableView.hidden = YES;
        [liaotian.inputTextField resignFirstResponder];
         [self.tanmu setImage:[UIImage imageNamed:@"player_tan_btn"] forState:UIControlStateNormal];
    }
}

-(void)joinInChatRoom{
 
        NSString *haol = [NSString stringWithFormat:@"%@%s",_programmeId,"@conference.sfware"];
       if (_roomMemory == nil) {
          _roomMemory = [[XMPPRoomMemoryStorage alloc]init];
       }
    
        NSString* roomID = haol;
        XMPPJID * roomJID = [XMPPJID jidWithString:roomID];
        self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:_roomMemory
                                                          jid:roomJID
                                                dispatchQueue:dispatch_get_main_queue()];
    
        [self.xmppRoom activate:[MyXMPP sharedMyXMPP].xmppStream];
        [self.xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
   
        NSLog(@"ccc%@",[NSThread currentThread]);
        [self.xmppRoom joinRoomUsingNickname:_userId
                                     history:nil
                                    password:nil];
}

- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    NSLog(@"%@",message);
    
    if ([occupantJID.resource isEqualToString:_userId]) {
//               // 创建自己发送的消息
//        [self addMessage:message.body type:NJMessageModelTypeMe];
//        // 创建别人发送的消息
//        
//        //    NSString *result = [self autoReplayWithContent:textField.text];
//        //    [self addMessage:result type:NJMessageModelTypeOther];
//        
//        // 2.刷新表格
//        [self.tableView reloadData];
//        
//        // 3.让tableveiw滚动到最后一行
//        NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }else if(occupantJID.resource != nil)
    {
        NSString *result = [self autoReplayWithContent:message.body];
        [self addMessage:result type:NJMessageModelTypeOther];
        
        // 2.刷新表格
        [self.tableView reloadData];
        // 3.让tableveiw滚动到最后一行
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
       
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }
//    [HMMusicTool setAllliaotianMessage:array];

}

//来电话的时候
-(void)onAudioSessionEvent:(NSNotification *)text
{
    NSLog(@"%@",[text.userInfo objectForKey:@"AVAudioSessionInterruptionTypeKey"]);

    BOOL isPlaying  = [_mMPayer isPlaying];
    
    if ([[text.userInfo objectForKey:@"AVAudioSessionInterruptionTypeKey"]  isEqual: @1]) {
        _roundView.isPlay = NO;
        
        [_mMPayer pause];
        
        [self heartStop];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"player_status_btn"] forState:UIControlStateNormal];

    } else {
        
        if (isPlaying) {
            if(didPrepared){
                [_mMPayer start];
                _roundView.isPlay = YES;
                
                [_playOrPauseButton setImage:[UIImage imageNamed:@"player_window_status_btn"] forState:UIControlStateNormal];
            } else{
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_async(queue, ^{
                    
                    [self prepareVideo];
                });
                
            }
        }

    }
}

- (BOOL)isPlaying
{
    if ([_mMPayer isPlaying]) {
        return YES;
    }
    return NO;
}


//检测网络类型
-(void)jianceNet
{
   
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    // start the notifier which will cause the reachability object to retain itself!
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
}

- (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
    
    if(![reach isReachable])
    {
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:@"网络不可用"];
        
        _roundView.isPlay = NO;
    
        [_playOrPauseButton setImage:[UIImage imageNamed:@"player_status_btn"] forState:UIControlStateNormal];

        return;
    }
    
    if (reach.isReachableViaWiFi) {

    
    } else {
      
//        [MBProgressHUD hideHUD];
//        
//        [MBProgressHUD showError:@"wifi未开启，不能用"];

    }
    
    if (reach.isReachableViaWWAN) {
       
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *net = [defaults objectForKey:@"net"];
        
        if ([net isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showError:@"当前通过2g or 3g连接 , 请设置"];
        }
        
    } else {
    
    }
}

-(void)setMusicList:(scModel *)musicList
{
    if (_musicList != musicList) {
        
         _musicList = musicList;
        
//        //开始播放音乐
//        [self  startPlayingMusic];
//        
//        //收藏按钮的状态
//        
//        [self shoucangImg];
    }
}

/* KVO function， 只要object的keyPath属性发生变化，就会调用此函数*/

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"url"]) { // 监听到播放器状态改变了
        [self prepareVideo];
    }
}
-(void)dealloc{
    [self.musicList removeObserver:self forKeyPath:@"url"];//移除监听
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //[super dealloc];//注意启用了ARC，此处不需要调用
}

- (IBAction)yuyueBtn:(id)sender {
    
////    if (status == 1 ) {
////        
////    }else{
//    
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        UINavigationController *nav =  [storyboard instantiateViewControllerWithIdentifier:@"navde"];
//        
//        [self presentViewController:nav animated:YES completion:nil];
//
////    }
}

-(void)addshouting
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = _userId;
    
    parameters[@"channelId"] = channelId;

    [self.mgr getPath:addshoutingUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
    }];

    
}

-(void)shoucangImg
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = _userId;
    
    
    [self.mgr getPath: shoucangListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSArray *detailNSArray = (NSArray *)jsonObj;
            
            //字典数组转模型数组
       
            for (NSDictionary *ary  in  detailNSArray) {
                
                NSString *a =[ NSString stringWithFormat:@"%@",[ary objectForKey:@"id"]];
                if ([channelId isEqualToString:a]) {
                [_shoucang setImage:[UIImage imageNamed:@"user_info_shoucang.png"] forState:UIControlStateNormal];
                }else
                   [_shoucang setImage:[UIImage imageNamed:@"user_info_shoucang_select.png"] forState:UIControlStateNormal];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
           [_shoucang setImage:[UIImage imageNamed:@"user_info_shoucang.png"] forState:UIControlStateNormal];
    }];
}

-(VMediaPlayer *)mMPayer
{
    if (!_mMPayer) {
        self.mMPayer = [VMediaPlayer sharedInstance];
        [self.mMPayer setupPlayerWithCarrierView:self.view withDelegate:self];
    }
    return _mMPayer;
}

-(void)iniPlayer
{
    _roundView.delegate = self;
    _roundView.rotationDuration = 9.0;
    _roundView.isPlay = YES;
}

-(void)prepareVideo
{
    if(self.playingMusic.url)
    {
        //播放时不要锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [self.mMPayer reset];
        [self.mMPayer setDataSource: [NSURL URLWithString:self.playingMusic.url]];
        [self.mMPayer prepareAsync];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - 定时器处理
- (void)addCurrentTimeTimer
{
    [self removeCurrentTimeTimer];
    
    // 保证定时器的工作是及时的
    [self updateCurrentTime];
          self.currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currentTimeTimer forMode:NSRunLoopCommonModes];
  
}

- (void)removeCurrentTimeTimer
{
    [self.currentTimeTimer invalidate];
    self.currentTimeTimer = nil;
    
    [self.currentBacimgTimer invalidate];
    self.currentBacimgTimer = nil;
}

-(void)addCurrentBacimgTimer
{
    [self removeCurrentTimeTimer];
    
    // 保证定时器的工作是及时的
    [self updateCurrentBacTime];
    self.currentBacimgTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateCurrentBacTime) userInfo:nil repeats:YES];
   [[NSRunLoop mainRunLoop] addTimer:self.currentBacimgTimer forMode:NSRunLoopCommonModes];

}

-(void)updateCurrentBacTime
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"programmeId"] = _programmeId;
    
    if (_programmeId == nil || [_programmeId isEqualToString:@"0"]) {
        self.bacImg.image = [UIImage imageNamed:@""];
        return;
    }
    
    [[HTTPManager shareManager] getPath:imgInfoURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
             
               _Imgbac = [NSArray array];
               _Imgbac = (NSArray *)jsonObj;
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    
                    NSTimer  *mTimers = [NSTimer scheduledTimerWithTimeInterval:7.0f
                                                                         target:self
                                                                       selector:@selector(imgGG)
                                                                       userInfo:nil
                                                                        repeats:YES];
                 　  NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
                    [runLoop addTimer:mTimers forMode:NSRunLoopCommonModes];
                    [runLoop run];
             
                });
               
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"222");
    }];

}

-(void)imgGG
{
    NSLog(@"--NSThread currentThread--%@", [NSThread currentThread]);
    
    if (_Imgbac.count == 0) {
        
        self.bacImg.image = [UIImage imageNamed:@""];
        
        return;
    }
 
        UIImage *placeholder = [UIImage imageNamed:@""];
        // 下载图片
        
        NSString *filrfileURL = zongdizhiURL;
        
        NSString *url = [filrfileURL stringByAppendingString:[NSString stringWithFormat:@"%@",_Imgbac[iimg]]];
        
        [self.bacImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
        
        iimg++;
    
       if (iimg == _Imgbac.count) {
            iimg = 0;
           
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self imgGG];
           });
    }
    
}
/**
 *  更新播放进度
 */
- (void)updateCurrentTime
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"appId"] = _appId;
    parameters[@"status"] =  @"1";
    parameters[@"channelId"] = channelId;
    parameters[@"programmeId"] = _programmeId;
    parameters[@"userId"] = _userId;
    parameters[@"date"] = _date;
    parameters[@"coordinate"] = coordinate;

    [[HTTPManager shareManager] getPath:startHeartUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"0");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"222");
    }];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

-(void)heartStop{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"appId"] = _appId;
    parameters[@"status"] =  @"0";
    parameters[@"channelId"] = channelId;
    parameters[@"programmeId"] = _programmeId;
    parameters[@"userId"] = _userId;
    parameters[@"date"] = _date;
    parameters[@"coordinate"] = coordinate;
    
    [[HTTPManager shareManager] getPath:stopHeartUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"0");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"222");
    }];

}
/**
 *  更新歌词
 */
- (void)updateLrc
{
//    self.lrcView.currentTime = self.player.currentTime;
}

#pragma mark - 音乐控制
/**
 *  重置正在播放的音乐
 */
- (void)resetPlayingMusic
{
    
    self.starttimeLab.text = @"";
    self.endtimeLab.text = @"";
    self.singerLabel.text = @"";
    self.songLabel.text = @"";
    [self removeCurrentTimeTimer];

}

/**
 *  开始播放音乐
 */
- (void)startPlayingMusic
{
 //本来想用kvo来控制是否相等，大爷的kvo没起作用，就用这个判断了
    if (self.playingMusic == [HMMusicTool playingMusic]) {
        [self addCurrentjinduTimer];
        return;
    }
 //如果只有一个的话就返回
    if ([HMMusicTool playingMusic] == nil) {
        return;
    }
    
 //清除聊天信息当换台的时候
    [self.messages removeAllObjects];
    
    [self.tableView reloadData];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    NSNumber *boolNumber = [NSNumber numberWithBool:NO];
    
    dic = @{@"isPlaying":boolNumber};
    
    //创建通知
    NSNotification *notificationTT =[NSNotification notificationWithName:@"kaishi" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notificationTT];

    
    // 1.设置界面数据
    self.playingMusic = [HMMusicTool playingMusic];
    
    NSLog(@"%@",self.playingMusic);
//    self.singerLabel.text = self.playingMusic.fm;
    self.songLabel.text = self.playingMusic.name;
    
    NSString *idq = self.playingMusic.id;
    NSString *urlStr = [NSString stringWithFormat:diantaiURL ];
    
    channelId = self.playingMusic.id;
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:self.playingMusic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];


    [[HTTPManager shareManager]getPath:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *jsonData = responseObject;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSMutableDictionary *deserializedDictionary = (NSMutableDictionary *)jsonObj;
        NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
        
        _jiemuNarry = deserializedDictionary;
        
        if ([_jiemuNarry objectForKey:@"jiemu"] == nil) {
            self.starttimeLab.text = @"";
            self.endtimeLab.text = @"";
            self.singerLabel.text = @"";
        }else{
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *now;
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            now=[NSDate date];
            comps = [calendar components:unitFlags fromDate:now];
            int  week = [comps weekday] - 1;
            if (week == 0) {
                week = 7;
            }
            
            NSLog(@"%d", week);
            
            NSString *day = [NSString stringWithFormat:@"%d",week];
            
            for (NSDictionary *wee in [_jiemuNarry objectForKey:@"jiemu"]){
                
                ZYJWeekModel *week = [ZYJWeekModel mj_objectWithKeyValues:wee];
                
                NSLog(@"%@",week.starttime);
                
                NSString *yitian = [NSString stringWithFormat:@"%@",week];
                
                NSString *copyStr = [week.weekday stringByReplacingOccurrencesOfString:@"," withString:@""];

                for (int i = 0; i < [copyStr length]; i++) {
                    if ([day isEqualToString:[copyStr substringWithRange:NSMakeRange(i, 1)]]) {
                         starttime = [week.starttime doubleValue];
                        NSDate *starttime1 = [Statics zoneChange:starttime];
                        
                        endtime = [week.endtime doubleValue];
                        NSDate *endtime1 = [Statics zoneChange:endtime];
                        
                        currenttime = [Statics getCurrentTime];
                        
                        if ([Statics date:currenttime isBetweenDate:starttime1 andDate:endtime1] == 1){
                            self.starttimeLab.text = starttime1;
                            
                            startTm = week.starttime;
                            
                            self.endtimeLab.text = endtime1;
                            self.singerLabel.text = week.name;
                            
                            _allTime =  endtime - starttime;
                            //进度条
                            [self addCurrentjinduTimer];
                            
                            _programmeId = week.id;
                            //背景图片的切换
                            [self addCurrentBacimgTimer];
                            
                            self.pers = week.name;
                        }

                     }
                }
            }

        }

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.starttimeLab.text = @"";
        self.endtimeLab.text = @"";
        self.singerLabel.text = @"";
    }];
    // 2.开始播放
    
    [self prepareVideo];

    UIImage *placeholder = [UIImage imageNamed:@"diantai_default.png"];
    
    // 下载图片
    
    NSString *filrfileURL = zongdizhiURL;
    
    NSString *url = [filrfileURL stringByAppendingString:[NSString stringWithFormat:@"%@",self.playingMusic.img]];
    
    [self.roundView.roundImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
    
    self.icon = self.roundView.roundImageView.image;
    
    [_playOrPauseButton setImage:[UIImage imageNamed:@"player_window_status_btn"] forState:UIControlStateNormal];
    _roundView.isPlay = YES;
//心跳的开始
    [self addCurrentTimeTimer];

//刷新锁屏界面的信息
    [self updateLockedScreenMusic];
    
    //加最近收听
    
    [self addshouting];
    

}
- (void)updateLockedScreenMusic
{
//     1.播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] =  self.pers ;
    // 歌手
    info[MPMediaItemPropertyArtist] = self.playingMusic.fm;
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = self.playingMusic.name;
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:self.icon];
    // 设置持续时间（歌曲的总时间）
    info[MPMediaItemPropertyPlaybackDuration] = @"3600";
    // 设置当前播放进度
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @"100";
    
    // 3.切换播放信息
    center.nowPlayingInfo = info;
    
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    
    // 4.开始监听远程控制事件
    // 4.1.成为第一响应者（必备条件）
    [self becomeFirstResponder];
    // 4.2.开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - 私有方法
/**
 *  时长长度 -> 时间字符串
 */
- (NSString *)strWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%d:%d", minute, second];
}

#pragma mark - 内部控件的监听
/**
 *  退出
 */

- (IBAction)exit {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)lyricOrPic:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"channelId"] =  self.playingMusic.id;

    [self.mgr getPath:programmeListUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *aStr = (NSMutableArray *)jsonObj;
            
            NSArray *resultArray = [aStr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                NSNumber *number1 = [obj1 objectForKey: @"starttime"];
                NSNumber *number2 =  [obj2 objectForKey: @"starttime"];
                
                if(number1 < number2){
                    return -1;
                }
                if(number1 > number2){
                    return 1;
                }
            
                return 0;
            }];
            
            jiemuViewController *jiemu = [[jiemuViewController alloc]init];
            jiemu._alljiemu = resultArray;
            jiemu.timeMn = startTm;
            [self presentViewController:jiemu animated:YES completion:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];
 
}


- (IBAction)previous {
    // 1.重置当前歌曲
    [self resetPlayingMusic];
    
    // 2.获得下一首歌曲
    [HMMusicTool setPlayingMusic:[HMMusicTool previousMusic]];
    
    // 3.播放下一首
    [self startPlayingMusic];
    
    [self shoucangImg];
    
    [self updateLockedScreenMusic];
//聊天页面 关闭
    liaotian.hidden = YES;
    self.tableView.hidden = YES;
    [liaotian.inputTextField resignFirstResponder];
}

- (IBAction)next {
    // 1.重置当前歌曲
    [self resetPlayingMusic];
    
    // 2.获得下一首歌曲
    [HMMusicTool setPlayingMusic:[HMMusicTool nextMusic]];
    
    // 3.播放下一首
    [self startPlayingMusic];
    
    [self shoucangImg];

    [self updateLockedScreenMusic];
//聊天页面 关闭
    liaotian.hidden = YES;
    self.tableView.hidden = YES;
    [liaotian.inputTextField resignFirstResponder];
}


-(void)nextOr:(NSNotification *)text
{
    [self next];
    
}

-(void)playOr:(NSNotification *)text
{
    [self playOrPause];
    
}
- (IBAction)playOrPause {
    
    if(self.playingMusic.url)
    {
        BOOL isPlaying  = [_mMPayer isPlaying];
    
        NSDictionary *dic = [NSDictionary dictionary];
        
        NSNumber *boolNumber = [NSNumber numberWithBool:isPlaying];
        
        dic = @{@"isPlaying":boolNumber};
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"kaishi" object:nil userInfo:dic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        if (isPlaying) {
             _roundView.isPlay = NO;

             [_mMPayer pause];
             [self heartStop];
             [self removeCurrentTimeTimer];

             [_playOrPauseButton setImage:[UIImage imageNamed:@"player_status_btn"] forState:UIControlStateNormal];
        } else {
            if(didPrepared){
                [_mMPayer start];
                _roundView.isPlay = YES;
                [self addCurrentjinduTimer];
                
                [_playOrPauseButton setImage:[UIImage imageNamed:@"player_window_status_btn"] forState:UIControlStateNormal];

            } else{
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_async(queue, ^{
                    
                    [self prepareVideo];
                });
                
            }
//
         }
    }
  [self updateLockedScreenMusic];
}

- (void)addCurrentjinduTimer
{
   [self removejinducurrentTimeTimer];
    
    // 保证定时器的工作是及时的
    [self updatejinducurrentTimeTimer];
    
    self.jinducurrentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatejinducurrentTimeTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.jinducurrentTimeTimer forMode:NSRunLoopCommonModes];
}


- (void)removejinducurrentTimeTimer
{
    [self.jinducurrentTimeTimer invalidate];
    self.jinducurrentTimeTimer = nil;
}

/**
 *  更新播放进度
 */
- (void)updatejinducurrentTimeTimer
{
    // 1.计算进度值
    NSString *tiem = self.starttimeLab.text;
    
    if (![tiem isEqualToString:@""]) {
        long long a = [[tiem substringToIndex:2]longLongValue];
        long long  c = [[tiem substringWithRange:NSMakeRange(3,2)]longLongValue];
        long long b = [[tiem substringFromIndex:6]longLongValue];
        
        long long  alltime = (a*60*60 + c*60 + b)*1000;
        
        _PointTime = [Statics currenTime] - alltime;
    }
      if (_allTime != 0 && _PointTime != 0) {
        
        progress = _PointTime/_allTime;
    }
    
    // 2.设置滑块的x值
    CGFloat sliderMaxX = self.view.width ;
    self.sliderw.x = sliderMaxX * _PointTime/_allTime;
    
//    [self.sliderw setTitle:[self strWithTime:self.player.currentTime] forState:UIControlStateNormal];
    
//    // 3.设置进度条的宽度
    self.prossgressView.width = self.sliderw.center.x;
}

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    didPrepared = YES;
//开始播放
//    mDuration = [_vPlayer getDuration];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [player start];
    });
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    //播放完成，发送消息
    [player reset];
    didPrepared = NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
//    FMplayerStatusCode code = FMplayerStatus_ErrorPlaying;
//    NSDictionary *data = @{@"status":[NSNumber numberWithInteger:code]};
//    [[NSNotificationCenter defaultCenter] postNotificationName:KFMplayerStatusUpdata object:nil userInfo:data];
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
    //配置信息
    player.decodingSchemeHint = VMDecodingSchemeSoftware;
    player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
    //设置buffer
    [_mMPayer setBufferSize:20*1024];
    [player setAdaptiveStream:YES];
     player.useCache = NO;
    
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
    NSLog(@"NAL 1HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    NSLog(@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    //NSLog(@"开始缓冲~~~~");
//    FMplayerStatusCode code = FMplayerStatus_StartBuffing;
//    NSDictionary *data = @{@"status":[NSNumber numberWithInteger:code]};
//    [[NSNotificationCenter defaultCenter] postNotificationName:KFMplayerStatusUpdata object:nil userInfo:data];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    NSLog(@"缓冲进度=====%d%%",[(NSNumber *)arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{
    
    NSLog(@"acheNotAvailable");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    NSLog(@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    //NSLog(@"缓冲完毕，开始播放~");
    
    //    [_vPlayer start];
    //    FMplayerStatusCode code = FMplayerStatus_StartBuffing;
    //    NSDictionary *data = @{@"status":[NSNumber numberWithInteger:code]};
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KFMplayerStatusUpdata object:nil userInfo:data];
    
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
    NSLog(@"当前网速==%dKB/s",[arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg
{
    NSLog(@"NAL 1BGR video lagging....");
}



//- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
//{
//    //显示“暂停”两字
//    didPrepared = YES;
//    [player start];
//}
//
//- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
//{
//    
//    [player reset];
//    didPrepared = NO;
//    [UIApplication sharedApplication].idleTimerDisabled = NO;
//}
//
//- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
//{
//    NSLog(@"VMediaPlayer Error: %@", arg);
//}


/**
 *  点击了进度条背景
 */
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender {
//    CGPoint point = [sender locationInView:sender.view];
//    
//    // 切换歌曲的当前播放时间
//    self.player.currentTime = (point.x / sender.view.width) * self.player.duration;
//    
//    [self updateCurrentTime];
}

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    // 获得挪动的距离
    CGPoint t = [sender translationInView:sender.view];
    
}

#pragma mark - 远程控制事件监听
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
//    event.type; // 事件类型
//    event.subtype; // 事件的子类型
//    UIEventSubtypeRemoteControlPlay                 = 100,
//    UIEventSubtypeRemoteControlPause                = 101,
//    UIEventSubtypeRemoteControlStop                 = 102,
//    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
//    UIEventSubtypeRemoteControlNextTrack            = 104,
//    UIEventSubtypeRemoteControlPreviousTrack        = 105,
//    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
//    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
//    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
//    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            
        default:
            break;
    }
}

- (void)showShareActionSheet:(UIView *)view
{

/**
 * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
 **/
//    __weak ViewController *theController = self;
    

//1、创建分享参数（必要）
NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
NSString *urlStr = [NSString stringWithFormat:fenxiangURL];
NSArray* imageArray = @[[UIImage imageNamed:@"radior.png"]];
[shareParams SSDKSetupShareParamsByText:@"好的应用一起分享"
                                 images:imageArray
                                    url:[NSURL URLWithString:urlStr]
                                  title:@"飞扬FM"
                                   type:SSDKContentTypeAuto];

//1.2、自定义分享平台（非必要）
NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];

[ShareSDK showShareActionSheet:view
                         items:activePlatforms
                   shareParams:shareParams
           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
               
               switch (state) {
                       
                   case SSDKResponseStateBegin:
                   {
                       //                           [theController showLoadingView:YES];
                       break;
                   }
                   case SSDKResponseStateSuccess:
                   {
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                           message:nil
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil];
                       [alertView show];
                       break;
                   }
                   case SSDKResponseStateFail:
                   {
                       if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       else
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       break;
                   }
                   case SSDKResponseStateCancel:
                   {
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消分享"
                                                                           message:nil
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil];
                       [alertView show];
                       break;
                   }
                   default:
                       break;
               }
               
               if (state != SSDKResponseStateBegin)
               {
                   
               }
               
           }];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == _myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:9999999999999999999999999999.f
                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            break;
            
        case 1:  //打开本地相册
            
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:600.0                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            
//            [MBProgressHUD  showSuccess:@"10分钟"];
            break;
        case 2:  //打开照相机拍照
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1200.0
                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            
//            [tooles MsgBox:@"20分钟"];
            break;
            
        case 3:  //打开本地相册
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1800.0f
                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            
//            [tooles MsgBox:@"30分钟"];
            break;
            
        case 4:  //打开照相机拍照
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:3600.0f
                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            
//            [tooles MsgBox:@"60分钟"];
            break;
            
        case 5:  //打开本地相册
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:5400.0f
                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            
//            [tooles MsgBox:@"90分钟"];
            break;
        case 6:  //打开照相机拍照
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:7200.0f
                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            
//            [tooles MsgBox:@"120分钟"];
            break;
            
        case 7:  //打开本地相册
            mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:66666.f
                                                              target:self
                                                            selector:@selector(heartlei)
                                                            userInfo:nil
                                                             repeats:NO];
            
//            [tooles MsgBox:@"节目播放完自动关闭"];
            break;
    }
}

-(void)heartlei{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end

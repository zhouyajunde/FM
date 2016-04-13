 //
//  personViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "personViewController.h"
#import "ZYJList.h"
#import "ZYJShowGroup.h"
#import "NJAboutHeaderView.h"
#import "shoucangViewController.h"
#import "ZYJzuijnViewController.h"
#import "ZYJSetingViewController.h"
#import "ZYJseting.h"
#import "ZYJyueCon.h"
#import "ZYJduihaunCon.h"
#import "ZYJwenjuanCon.h"
#import "ZYJTimeViewController.h"
#import "ZYJdic.h"
#import "MJExtension.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MBProgressHUD+NJ.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
#import "scModel.h"
#import "HMMusicTool.h"

static NSString *_zjListening;
const CGFloat HMTopViewH = 350;

@interface personViewController ()<bacDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
      UIActionSheet *myActionSheet;
      NSString* filePath, *_useid;
      AFHTTPClient    *_httpClient;
      NSOperationQueue *_queue;
      NJAboutHeaderView *nj;
      int status;
}


@property (nonatomic, strong) scModel *playingMusic;
- (IBAction)tiaozhuanBtn:(id)sender;

@end

@implementation personViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tuihuc:) name:@"tuichuLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dengluSuccess:) name:@"loginSuccess" object:nil];
    
    [self add0SectionItems];
    
    [self add1SectionItems];
    
      // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    ZYJdic *_ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];
    
    _useid = _ZYJdic.id;
    
    status  = _ZYJdic.status;
    
    nj=  [NJAboutHeaderView headerView];
    
    nj.img = _ZYJdic.headimg;
    nj.name = _ZYJdic.name;
    nj.delegate = self;
    
    self.tableView.tableHeaderView = nj;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 向下拽了多少距离
//    CGFloat down = -(HMTopViewH * 0.5) - scrollView.contentOffset.y;
//    if (down < 0) return;
//    
//    CGRect frame = nj.topView.frame;
//    // 5决定图片变大的速度,值越大,速度越快
//    frame.size.height = HMTopViewH + down * 5;
//    nj.topView.frame = frame;
//    
//    NSLog(@"scro.h%f",scrollView.contentOffset.y);
//    CGFloat h = 200-(100+scrollView.contentOffset.y);
//    if (h<100) {
//        h=100;
//    }
//    self.headerH.constant =h;
//    
}

-(void)tuihuc:(NSNotification *)text
{
    nj.bacImg.image = [UIImage imageNamed:@"user_info.png"];
    nj.personLab.text = @"";
    status = 0;
}

-(void)dengluSuccess:(NSNotification *)text{
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    ZYJdic *_ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];
    _useid = _ZYJdic.id;
    status  = _ZYJdic.status;
    nj.img = _ZYJdic.headimg;
    nj.personLab.text =  _ZYJdic.name;

}

- (void)tongzhi:(NSNotification *)text{
    self.playingMusic  = [scModel mj_objectWithKeyValues:text.userInfo];
    [self refresh];
}

-(void)refresh
{
    ZYJShowGroup *group = _allGroups[0];
    ZYJItem *item = group.items[1];
    
    item.subtitle = _zjListening;
    
    _allGroups[0] = group;
    
    [self.tableView reloadData];

}

-(void)viewDidAppear:(BOOL)animated
{
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)add0SectionItems
{
    self.playingMusic = [HMMusicTool playingMusic];
    
    _zjListening = self.playingMusic.name;

    if (_zjListening == nil) {
        _zjListening = @"无最近收听";
    }
    
    NSString *scName = [HMMusicTool shouCang];
    
    ZYJList *choucang = [ZYJList itemWithIcon:@"user_info_shoucang" title:@"我的收藏" subTitle:scName];
    choucang.showVCClass = [shoucangViewController class];
    
    ZYJList *zuijin = [ZYJList itemWithIcon:@"user_info_time" title:@"最近收听" subTitle:_zjListening];
    zuijin.showVCClass = [ZYJzuijnViewController class];
    
    //    shake.key = NJSettingShakeChoose;
    
    ZYJList *yuyue = [ZYJList itemWithIcon:@"user_info_yuyue" title:@"我的预约" subTitle:@"无预约"];
    yuyue.showVCClass = [ZYJyueCon class];

    ZYJList *lipin = [ZYJList itemWithIcon:@"user_info_shoucang" title:@"礼品兑换" subTitle:@"请兑换"];
    lipin.showVCClass = [ZYJduihaunCon class];

    ZYJList *wenjuan = [ZYJList itemWithIcon:@"user_info_shoucang" title:@"问卷调查" subTitle:@"填写问卷获得积分"];
    wenjuan.showVCClass = [ZYJwenjuanCon class];

    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[choucang, zuijin, yuyue,lipin,wenjuan]];
    [_allGroups addObject:group];
}

#pragma mark 添加第1组的模型数据
- (void)add1SectionItems
{
    ZYJseting *dingshi = [ZYJseting itemWithIcon:@"user_info_guanbi" title:@"定时关机" subTitle:@"无定时关闭"];
    
    ZYJseting *shezhi = [ZYJseting itemWithIcon:@"user_info_settign" title:@"更多设置" subTitle:@"请设置"];
    shezhi.showVCClass = [ZYJSetingViewController class];
    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[dingshi, shezhi]];
    [_allGroups addObject:group];
}

-(void)huanBac{
    
    if (status == 1 ) {
    
        myActionSheet = [[UIActionSheet alloc]
                         initWithTitle:nil
                         delegate:self
                         cancelButtonTitle:@"取消"
                         destructiveButtonTitle:nil
                         otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
        
        [myActionSheet showInView:self.view];
    }else{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *nav =  [storyboard instantiateViewControllerWithIdentifier:@"navde"];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            //
            //        case 1:  //打开本地相册
            //            [self pickImageFromAlbum];
            //            break;
        case 1:  //打开本地相册
            [self pickImageFromAlbum];
            break;
            
    }
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        //        [picker release];
        //        [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)pickImageFromAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if(![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:^{}];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        
        //        UIImage *imm = [UIImage imageWithContentsOfFile:filePath];//通过path图片路径获取图片
        //
        //        NSData *data = UIImagePNGRepresentation([self imageCompressForWidth:imm targetWidth:30]);//获取图片数据
        //
        
        if (UIImagePNGRepresentation(image) == nil)
        {
            //            data = UIImageJPEGRepresentation(image, 1.0);
            data = UIImagePNGRepresentation([self imageCompressForWidth:image targetWidth:100]);
        }
        else
        {
            data = UIImagePNGRepresentation([self imageCompressForWidth:image targetWidth:100]);
            //            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];

        NSDictionary *parameter = @{@"userId":_useid};

        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:saveImgURL]];
        
        _queue = [[NSOperationQueue alloc] init];
  
        NSURLRequest *request = [_httpClient multipartFormRequestWithMethod:@"POST"
                                                                       path:@""
                                                                 parameters:parameter
                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                      
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                            // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
                                                      
        UIImage *imm = [UIImage imageWithContentsOfFile:filePath];//通过path图片路径获取图片
                                                      
        NSData *dta = UIImagePNGRepresentation([self imageCompressForWidth:imm targetWidth:300]);//获取图片数据
                                                      
        NSMutableData *imageData = [NSMutableData dataWithData:dta];//ASIFormDataRequest 的setPostBody 方法需求的为
                                                      
        [formData appendPartWithFileData:imageData name:@"images"  fileName:fileName mimeType:@"images"];
                                                      

                                                  }];
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        
        [MBProgressHUD showMessage:@"正在上传.."];
        
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *jsonData = responseObject;

        
            NSString* aStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary: [userDefaults objectForKey:@"dic"]];
            
            [mDict setObject:aStr forKey:@"headimg"];
        
            [userDefaults setObject:mDict forKey:@"dic"];
            [userDefaults synchronize];
            
            nj.img = aStr;
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showSuccess:@"成功上传"];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUD];
//            error	NSError *	domain: @"AFNetworkingErrorDomain" - code: 18446744073709550605	0x0000000146600840
            [MBProgressHUD showError:@"上传失败"];

        }];
           [_httpClient.operationQueue addOperation:op];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
    }
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}


- (IBAction)tiaozhuanBtn:(id)sender {
    
    if (status == 1 ) {
        
         [self performSegueWithIdentifier:@"2geren" sender:nil];
        
    }else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UINavigationController *nav =  [storyboard instantiateViewControllerWithIdentifier:@"navde"];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }

}
@end

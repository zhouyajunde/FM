//
//  oneViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "oneViewController.h"
#import "fenleiViewController.h"
#import "loginViewController.h"
#import "personViewController.h"
#import "MoreViewController.h"
#import "CDPSearchController.h"
#import "seacherControllerVC.h"


static  BOOL u;

@interface oneViewController(){
    
     CDPSearchController *_searchController;
     NSMutableArray *_dataArr;//数据源
    
}

- (IBAction)asas:(id)sender;

@end
@implementation oneViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    testArray = [[NSArray alloc]initWithObjects:@"推荐",@"分类",nil];
    _testSegment = [[BFSegmentControl alloc]initWithFrame:CGRectMake(0,64,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*56/568) withDataSource:self];
  
    //逗比啊 ， 设置为0 就不行了，设置为1 就能行了
    
    [self.view insertSubview:_testSegment atIndex:1];
    
    //控制器
    
    pageControl = [[UIPageControl alloc] init];
    
    pageControl.frame = CGRectMake(14, 100, 20, 20);
    
    pageControl.numberOfPages = 2;
    
    
    pageControl.currentPage = 0;
    
    mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bouncesZoom = YES;
    mainScrollView.delaysContentTouches = YES;
    mainScrollView.canCancelContentTouches = YES;
    mainScrollView.delegate = self;
    mainScrollView.userInteractionEnabled = YES;
    mainScrollView.tag = 10;
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    
    mainScrollView.backgroundColor = [UIColor clearColor];
    
    mainScrollView.frame = CGRectMake(0, 4*_testSegment.frame.size.height/5+_testSegment.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _testSegment.frame.size.height - [UIScreen mainScreen].bounds.size.height*80/568);
    
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, 0);
    [self.view addSubview:mainScrollView];
    
//    _fenlei = [[fenleiViewController alloc]init];
//    _fenlei.view.frame = CGRectMake(320, 0, 320, 568);
    

// 加载UIStoryboard(注意:仅仅是加载名称叫做Test的storyboard, 并不会创建storyboard重的控制器以及控件)
  
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"fenleiTabView" bundle:nil];
//     _fenleitTab =  [storyboard instantiateInitialViewController];
   
// 创建storyboard中箭头指向的控制器  并且进行加载
    _fenleitTab = [storyboard instantiateViewControllerWithIdentifier:@"two"];

    _fenlei = [[fenleiViewController alloc]init];
    _fenlei.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    _fenlei.delegate = self;
    _tuijian = [[tuijianViewController alloc]init];
    
    _tuijian.delegate = self;
//    [mainScrollView addSubview:_fenlei.view];
    [mainScrollView addSubview:_fenlei.view];
    [mainScrollView addSubview:_tuijian.view];
    
    _dataArr=[[NSMutableArray alloc] init];

}

-(void)TomoreView:(UIViewController *)tuijianview
{
    [self.navigationController pushViewController:tuijianview animated:YES];
//    [self presentViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>];
}

-(void)MusicView:(UIViewController *)tuijianview{
    
     [self presentViewController:tuijianview animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollview {
    
    if (scrollview.tag == 10) {
        int page = scrollview.contentOffset.x / self.view.frame.size.width;
        pageControl.currentPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    bfSegment =  (BFSegmentItem*)[_testSegment.backScrollView viewWithTag:8888+pageControl.currentPage];
    [_testSegment didTapOnItem:bfSegment];
}
#pragma mark -----分段控件
- (NSInteger)numberOfItemsInSegmentControl:(BFSegmentControl *)sgmCtrl
{
    return [testArray count];
}
- (CGFloat)widthForEachItemInsegmentControl:(BFSegmentControl *)sgmCtrl
{
    return self.view.frame.size.width/2;
}
- (NSString*)segmentControl:(BFSegmentControl *)sgmCtrl titleForItemAtIndex:(NSInteger)index
{
    return [testArray objectAtIndex:index];
}
- (void)segmentControl:(BFSegmentControl *)sgmCtrl didSelectAtIndex:(NSInteger)index
{
    mainScrollView.contentOffset = CGPointMake(self.view.frame.size.width*index, 0);
}

// 在segue跳转之前调用, 会传入performSegueWithIdentifier方法创建好的segue对象
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//    
//    NSLog(@"prepareForSegue");
//    // 1.取出目标控制器
//    UINavigationController *nav = segue.destinationViewController;
//    NJTwoViewController *two = ( NJTwoViewController *)nav.topViewController; // 获取导航控制器栈顶的控制器
//    
//    // 2.给目标控制器传递数据
//    two.name = @"lnj";
    
    NSLog(@"111%@222 %@ 333%@",segue.identifier, segue.sourceViewController, segue.destinationViewController);

    // 1.拿到目标控制器
    UIViewController *vc =  segue.destinationViewController;
    // 2.设置目标控制器的标题
    //    vc.navigationItem.title = [NSString stringWithFormat:@"%@ 的联系人列表", self.accountField.text];
    
//         vc.title  == @"haha ";
//    vc.title = [NSString stringWithFormat:@"%@ 的联系人列表", @"haha "];
    
}

- (IBAction)asas:(id)sender {
    
//搜索界面
    
    seacherControllerVC *seach=[[seacherControllerVC alloc]init];
    [self.navigationController pushViewController:seach animated:YES];
/*
    if (u == NO) {
//        loginViewController *lg = [self.storyboard instantiateViewControllerWithIdentifier: @"toytu"];
//    
//        lg.string = @"222"
        
        [self performSegueWithIdentifier:@"login" sender:nil];
        
//        [self presentViewController:lg animated:YES completion:nil];
        
        u = YES;
    }else{
        
//        personViewController *per = [self.storyboard instantiateViewControllerWithIdentifier:@"RightWin"];
        
//        [self.navigationController pushViewController:per animated:YES];
        
         [self performSegueWithIdentifier:@"person" sender:nil];
         u = NO;
    }
    */
}
@end

#import "FaceViewController.h"

#define BEGIN_FLAG @"["
#define END_FLAG @"]"

@implementation FaceViewController
@synthesize delegate=_delegate,faceArray,imageArray;


#define WIDTH_PAGE 320

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor lightGrayColor];
    
    faceArray = [[NSArray alloc]initWithObjects:@"000",@"001",@"002",@"003",@"004",@"005",@"006",@"009",
                 @"010",@"011",@"012",@"013",@"014",@"015",@"017",@"018",@"019",@"020",@"021",@"022",@"023",@"024",
                 @"025",@"026",@"027",@"029",@"030",@"031",@"033",@"034",@"035",@"036",@"037",@"038",@"040",@"041",
                 @"042",@"043",@"044",@"045",@"046",@"048",@"049",@"050",@"051",@"052",@"053",@"054",@"055",
                 @"056",@"059",@"061",@"062",@"063",@"065",@"066",nil];
    
	imageArray = [[NSMutableArray alloc] init];
    for (int i = 0;i<[faceArray count];i++){

        NSString* s = [NSString stringWithFormat:@"f_static_%@.png",faceArray[i]];
        
        [imageArray addObject:s];
       
    }
    [self create];
    return self;
}


- (NSString *)imageFilePath {
    NSString *s=[[NSBundle mainBundle] bundlePath];
    s = [s stringByAppendingString:@"/"];
    //NSLog(@"%@",s);
    return s;
}

-(void)create{
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-15)];
    _sv.contentSize = CGSizeMake(WIDTH_PAGE*3, self.frame.size.height-15);
    _sv.pagingEnabled = YES;
    _sv.scrollEnabled = YES;
    _sv.delegate = self;
    _sv.showsVerticalScrollIndicator = NO;
    _sv.showsHorizontalScrollIndicator = NO;
    _sv.userInteractionEnabled = YES;
    _sv.minimumZoomScale = 1;
    _sv.maximumZoomScale = 1;
    _sv.decelerationRate = 0.01f;
    _sv.backgroundColor = [UIColor clearColor];
    [self addSubview:_sv];
   
    int n = 0;
    UIImage *tempImage;
    NSString* s;
    for(int i=0;i<5;i++){
        int x=WIDTH_PAGE*i,y=0;
        for(int j=0;j<24;j++){
            if(n>=[faceArray count])
                break;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, y+10, 32.0f, 32.0f);
            button.tag = n;
            
            if(j==23){
                 s = [[self imageFilePath] stringByAppendingPathComponent:@"playback_close@2x.png"];
                [button addTarget:self action:@selector(actionDelete:)forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                s = [imageArray objectAtIndex:n];
                [button addTarget:self action:@selector(actionSelect:)forControlEvents:UIControlEventTouchUpInside];
                n++;
                
                if(fmod(i*24+j+1, 8)==0.0f && j>=7){
                    x = WIDTH_PAGE*i;
                    y += 50;
                }else
                    x += 40;
            }
            [button setBackgroundImage:[UIImage imageNamed:s] forState:UIControlStateNormal];
            [_sv addSubview:button];
            
        }
    }
    
    _pc = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.frame.size.height-30, 120, 30)];
    _pc.numberOfPages  = 3;
    [_pc addTarget:self action:@selector(actionPage) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_pc];
    
}


-(void)actionSelect:(UIView*)sender
{
    NSString* s = [faceArray objectAtIndex:sender.tag];
    
    [self.degate emojin:s];
    
    if( [_delegate isKindOfClass:[UITextField class]] ){
        UITextField* p = _delegate;
//        p.tag = kWCMessageTypeText;
        NSString* t = @"";
        if([p.text length]<=0)
            p.text = t;
        p.text = [p.text stringByAppendingString:s];
        [p setNeedsDisplay];
        p = nil;
    }
}

-(void)actionDelete:(UIView*)sender{
    
       [self.degate deteaction];
    if( [_delegate isKindOfClass:[UITextField class]] ){
        UITextField* p = _delegate;
        NSString* s = p.text;

        if([s length]<=0)
            return;
        int n=-1;
        if( [s characterAtIndex:[s length]-1] == ']'){
            for(int i=[s length]-1;i>=0;i--){
                if( [s characterAtIndex:i] == '[' ){
                    n = i;
                    break;
                }
            }
        }
        if(n>=0)
            p.text = [s substringWithRange:NSMakeRange(0,n)];
        else
            p.text = [s substringToIndex:[s length]-1];
        p = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/320;
    int mod   = fmod(scrollView.contentOffset.x,320);
    if( mod >= 160)
        index++;
    _pc.currentPage = index;
//    [self setPage];
}

- (void) setPage
{
	_sv.contentOffset = CGPointMake(WIDTH_PAGE*_pc.currentPage, 0.0f);
    NSLog(@"setPage:%d,%ld",_sv.contentOffset,(long)_pc.currentPage);
    [_pc setNeedsDisplay];
}

-(void)actionPage{
    [self setPage];
}

/*
-(void)createRecognizer{
    UIPanGestureRecognizer *panGR =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
    //限定操作的触点数
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMinimumNumberOfTouches:1];
    //将手势添加到draggableObj里
    [self addGestureRecognizer:panGR];
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint offset = [sender translationInView:g_App.window];
        if(offset.y>20 || offset.y<-20)
            return;
        if(offset.x>0)
            _pc.currentPage++;
        else
            _pc.currentPage--;
        [self setPage];
    }
}*/

@end
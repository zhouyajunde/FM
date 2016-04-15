#import <UIKit/UIKit.h>

@protocol biaoqingDegate <NSObject>

-(void)emojin:(NSString* )biaoqing;

-(void)deteaction;

@end

@interface FaceViewController : UIView{
	NSMutableArray            *_phraseArray;
    UIScrollView              *_sv;
    UIPageControl* _pc;
    BOOL pageControlIsChanging;
}

@property (nonatomic, assign) NSObject       *delegate;
@property (nonatomic, retain) NSArray        *faceArray;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, assign) id degate;

@end

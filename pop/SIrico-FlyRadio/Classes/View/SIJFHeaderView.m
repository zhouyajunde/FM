//
//  SIJFHeaderView.m
//  SIrico-FlyRadio
//
//  Created by Jin on 8/10/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIJFHeaderView.h"
#define FONT15  [UIFont systemFontOfSize:15]

@implementation SIJFHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //user
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        name.text = @"用户名:";
        name.font = FONT15;
        name.backgroundColor = CLEAR_COLOR;
        [self addSubview:name];
        
        _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 20)];
        _userLabel.backgroundColor = CLEAR_COLOR;
        _userLabel.font = FONT15;
        [self addSubview:_userLabel];
        
        // /// //////////////
        //age
        UILabel *age = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 50, 20)];
        age.text = @"年   龄:";
        age.font = FONT15;
        age.backgroundColor = CLEAR_COLOR;
        [self addSubview:age];
        
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 80, 20)];
        _ageLabel.backgroundColor = CLEAR_COLOR;
        _ageLabel.font = FONT15;
        [self addSubview:_ageLabel];
        
        //sex
        UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake(170, 35, 50, 20)];
        sex.text = @"性   别:";
        sex.font = FONT15;
        sex.backgroundColor = CLEAR_COLOR;
        [self addSubview:sex];
        
        _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 35, 80, 20)];
        _sexLabel.font = FONT15;
        _sexLabel.backgroundColor = CLEAR_COLOR;
        [self addSubview:_sexLabel];
        
        // /// /////
        //edu
        UILabel *edu = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 50, 20)];
        edu.text = @"学   历:";
        edu.font = FONT15;
        edu.backgroundColor = CLEAR_COLOR;
        [self addSubview:edu];
        
        _eduLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 60, 80, 20)];
        _eduLabel.backgroundColor = CLEAR_COLOR;
        _eduLabel.font = FONT15;
        [self addSubview:_eduLabel];
        
        //money
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(170, 60, 50, 20)];
        money.text = @"收   入:";
        money.font = FONT15;
        money.backgroundColor = CLEAR_COLOR;
        [self addSubview:money];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 60, 80, 20)];
        _moneyLabel.font = FONT15;
        _moneyLabel.backgroundColor = CLEAR_COLOR;
        [self addSubview:_moneyLabel];
        
        // /// /////
        //job
        UILabel *job = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 50, 20)];
        job.text = @"职   业:";
        job.font = FONT15;
        job.backgroundColor = CLEAR_COLOR;
        [self addSubview:job];
        
        _jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 85, 80, 20)];
        _jobLabel.backgroundColor = CLEAR_COLOR;
        _jobLabel.font = FONT15;
        [self addSubview:_jobLabel];
        
        //jifen
        UILabel *jifen = [[UILabel alloc] initWithFrame:CGRectMake(170, 85, 50, 20)];
        jifen.text = @"积   分:";
        jifen.font = FONT15;
        jifen.backgroundColor = CLEAR_COLOR;
        [self addSubview:jifen];
        
        _jfLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 85, 80, 20)];
        _jfLabel.font = FONT15;
        _jfLabel.backgroundColor = CLEAR_COLOR;
        [self addSubview:_jfLabel];
        
        float height = 110;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, height, 300, 20)];
        title.text = @"兑换记录";
        title.font = FONT15;
        title.backgroundColor = CLEAR_COLOR;
        [self addSubview:title];
        
        for (int i = 0 ; i < 3; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10+100*i, height+30, 100, 20)];
            lab.font = FONT15;
            lab.backgroundColor = CLEAR_COLOR;
            if (i == 0) {
                lab.text = @"兑换时间";
                
            }else if (i == 1){
                lab.text = @"礼品名称";
                lab.textAlignment = NSTextAlignmentCenter;
            }else{
                lab.text = @"兑换积分";
                lab.textAlignment = NSTextAlignmentRight;
            }
            [self addSubview:lab];
        }

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

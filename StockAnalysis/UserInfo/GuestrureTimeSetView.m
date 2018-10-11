//
//  GuestrureTimeSetView.m
//  StockAnalysis
//
//  Created by try on 2018/7/23.
//  Copyright © 2018年 try. All rights reserved.
//

#import "GuestrureTimeSetView.h"
#import "Masonry.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface GuestrureTimeSetView()
{
    UIButton* btn1;
    UIButton* btn2;
    UIButton* btn3;
    UIButton* btn4;
    UIButton* btn5;
    
    NSString* btnTitle;
}

@end


@implementation GuestrureTimeSetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initGuestrureTimeView];
//        [self setBackgroundColor:[UIColor blackColor]];
//        [self setAlpha:0.3f];
        
        btnTitle = @"";
    }
    return self;
}

-(void)initGuestrureTimeView{
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(@0);
//        make.left.mas_equalTo(@0);
//        make.right.mas_equalTo(@0);
//        make.bottom.mas_equalTo(@0);
//    }];
    [bg setBackgroundColor:[UIColor blackColor]];
    [bg setAlpha:0.4f];
    [self addSubview:bg];
    
    UIView* alert = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*0.15, ScreenHeight*0.2, ScreenWidth*0.7, ScreenHeight*0.25)];
    [alert setBackgroundColor:[UIColor whiteColor]];
    alert.layer.cornerRadius = 10;
    alert.layer.masksToBounds = YES;
    [self addSubview:alert];
    
    CGSize size  = alert.frame.size;
    UILabel* tip = [[UILabel alloc] initWithFrame:CGRectMake(0, alert.frame.size.height*0.05, alert.frame.size.width, alert.frame.size.height*0.2)];
    [tip setText:@"应用退出多久后需要手势密码解锁"];
    [tip setTextAlignment:NSTextAlignmentCenter];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setTextColor:[UIColor lightGrayColor]];
    [alert addSubview:tip];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(size.width*0.05, size.height*0.3, size.width*0.18, size.height*0.2)];
    [alert addSubview:btn1];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    btn1.layer.borderWidth = 0.5;
    btn1.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn1 setTitle:@"立即" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setFrame:CGRectMake(size.width*0.23, size.height*0.3, size.width*0.18, size.height*0.2)];
    [alert addSubview:btn2];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn2 setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:185.0/255.0 blue:66.0/255.0 alpha:1.0]];
    [btn2 setTitle:@"2分钟" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn3 setFrame:CGRectMake(size.width*0.41, size.height*0.3, size.width*0.18, size.height*0.2)];
    [alert addSubview:btn3];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:12];
    btn3.layer.borderWidth = 0.5;
    btn3.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn3 setTitle:@"5分钟" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn4 setFrame:CGRectMake(size.width*0.59, size.height*0.3, size.width*0.18, size.height*0.2)];
    [alert addSubview:btn4];
    [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:12];
    btn4.layer.borderWidth = 0.5;
    btn4.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn4 setTitle:@"10分钟" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn5 setFrame:CGRectMake(size.width*0.77, size.height*0.3, size.width*0.18, size.height*0.2)];
    [alert addSubview:btn5];
    [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:12];
    btn5.layer.borderWidth = 0.5;
    btn5.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn5 setTitle:@"30分钟" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView* hengxian = [[UIView alloc] initWithFrame:CGRectMake(0, size.height*0.65, size.width, 1)];
    [hengxian setBackgroundColor:[UIColor lightGrayColor]];
    [hengxian setAlpha:0.4];
    [alert addSubview:hengxian];
    
    UIView* shuxian = [[UIView alloc] initWithFrame:CGRectMake(size.width*0.5, size.height*0.65, 1, size.height*0.35)];
    [shuxian setBackgroundColor:[UIColor lightGrayColor]];
    [shuxian setAlpha:0.4];
    [alert addSubview:shuxian];
    
    UIButton* cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancel setFrame:CGRectMake(size.width*0.0, size.height*0.65, size.width*0.5, size.height*0.35)];
    [alert addSubview:cancel];
    cancel.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelCallback) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* sure = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sure setFrame:CGRectMake(size.width*0.5, size.height*0.65, size.width*0.5, size.height*0.35)];
    [alert addSubview:sure];
    sure.titleLabel.font = [UIFont systemFontOfSize:18];
    [sure setTitleColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sureCallback) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectBtn:(id)sender{
    
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn1.layer.borderWidth = 0.5;
    btn1.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn1 setBackgroundColor:[UIColor whiteColor]];
    
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn2.layer.borderWidth = 0.5;
    btn2.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn2 setBackgroundColor:[UIColor whiteColor]];
    
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn3.layer.borderWidth = 0.5;
    btn3.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn3 setBackgroundColor:[UIColor whiteColor]];
    
    [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn4.layer.borderWidth = 0.5;
    btn4.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn4 setBackgroundColor:[UIColor whiteColor]];
    
    [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn5.layer.borderWidth = 0.5;
    btn5.layer.borderColor =[ [UIColor grayColor] CGColor];
    [btn5 setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* btn = sender;
    [btn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:185.0/255.0 blue:66.0/255.0 alpha:1.0]];
    btn.layer.borderWidth = 0;
    btnTitle = btn.titleLabel.text;;
//    NSLog(@"btnTitle = %@",btnTitle);
    
}


-(void)cancelCallback{
    [self removeFromSuperview];
}

-(void)sureCallback{
    [self removeFromSuperview];
//    NSLog(@"btnTitle = %@",btnTitle);
    [GameData setGuestureTime:btnTitle];
    NSNotification * notice =[NSNotification notificationWithName:@"GuestureTimeSetting" object:nil userInfo:@{@"text":[NSString stringWithFormat:@"%@",btnTitle]}];
    
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}



@end

//
//  SetPasswordViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/27.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "HttpRequest.h"
#import "HUDUtil.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface SetPasswordViewController ()
@property(nonatomic,strong)NSMutableArray* buttonArr;//全部手势按键的数组
@property (nonatomic,strong)NSMutableArray *selectorArr;//选中手势按键的数组
@property (nonatomic,assign)CGPoint startPoint;//记录开始选中的按键坐标
@property (nonatomic,assign)CGPoint endPoint;//记录结束时的手势坐标
@property (nonatomic,strong)UIImageView *imageView;//画图所需
@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置手势密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (!_buttonArr) {
        _buttonArr = [[NSMutableArray alloc]initWithCapacity:9];
    }
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.imageView];
    
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ScreenWidth/12+ScreenWidth/3*j, ScreenHeight/3+ScreenWidth/3*i, ScreenWidth/7, ScreenWidth/7);
            [btn setImage:[UIImage imageNamed:@"pbg"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pbg01"] forState:UIControlStateHighlighted];
            btn.userInteractionEnabled = NO;
            [btn setTag:i*3+j];
            [self.buttonArr addObject:btn];
            [self.imageView addSubview:btn];
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)selectorArr
{
    if (!_selectorArr) {
        _selectorArr = [[NSMutableArray alloc]init];
    }
    return _selectorArr;
}

-(UIImage *)drawLine{
    UIImage *image = nil;
    
    UIColor *col = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    UIGraphicsBeginImageContext(self.imageView.frame.size);//设置画图的大小为imageview的大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context, col.CGColor);
    
    CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);//设置画线起点
    
    //从起点画线到选中的按键中心，并切换画线的起点
    for (UIButton *btn in self.selectorArr) {
        CGPoint btnPo = btn.center;
        CGContextAddLineToPoint(context, btnPo.x, btnPo.y);
        CGContextMoveToPoint(context, btnPo.x, btnPo.y);
    }
    //画移动中的最后一条线
    CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();//画图输出
    UIGraphicsEndImageContext();//结束画线
    return image;
}

//开始手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];//保存所有触摸事件
    if (touch) {
        
        
        for (UIButton *btn in self.buttonArr) {
            
            CGPoint po = [touch locationInView:btn];//记录按键坐标
            
            if ([btn pointInside:po withEvent:nil]) {//判断按键坐标是否在手势开始范围内,是则为选中的开始按键
                
                [self.selectorArr addObject:btn];
                btn.highlighted = YES;
                self.startPoint = btn.center;//保存起始坐标
            }
            
        }
        
    }
    
}

//移动中触发，画线过程中会一直调用画线方法
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        
        self.endPoint = [touch locationInView:self.imageView];
        for (UIButton *btn in self.buttonArr) {
            CGPoint po = [touch locationInView:btn];
            if ([btn pointInside:po withEvent:nil]) {
                
                BOOL isAdd = YES;//记录是否为重复按键
                for (UIButton *seBtn in self.selectorArr) {
                    if (seBtn == btn) {
                        isAdd = NO;//已经是选中过的按键，不再重复添加
                        break;
                    }
                }
                if (isAdd) {//未添加的选中按键，添加并修改状态
                    [self.selectorArr addObject:btn];
                    btn.highlighted = YES;
                    
//                    NSInteger tag = [btn tag];
//                    NSLog(@"move tag = %ld",(long)tag);
                }
                
                
                
            }
        }
    }
    self.imageView.image = [self drawLine];//每次移动过程中都要调用这个方法，把画出的图输出显示
    
}
//手势结束触发
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString* gesture =  @"";
    for (UIButton *btn in self.selectorArr) {
        NSInteger tag = [btn tag];
        NSLog(@"select tag = %ld",(long)tag);
        gesture = [NSString stringWithFormat:@"%@%ld",gesture,tag];
    }
    NSLog(@"gesture =%@",gesture);
    
    NSArray *parameters = @[ @{ @"name": @"gesture", @"value": gesture },
                             @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
    
    
    NSString* url = @"http://exchange-test.oneitfarm.com/server/account/set_gesture";
    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"SetGestureBack"];
    
    self.imageView.image = nil;
    self.selectorArr = nil;
    for (UIButton *btn in self.buttonArr) {
        btn.highlighted = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

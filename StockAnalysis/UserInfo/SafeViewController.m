//
//  SafeViewController.m
//  StockAnalysis
//
//  Created by try on 2018/6/21.
//  Copyright © 2018年 try. All rights reserved.
//

#import "SafeViewController.h"
#import "SetPasswordViewController.h"
#import "SetMoneyPasswordViewController.h"
#import "HttpRequest.h"
@interface SafeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneBindLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailBindLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneBindImage;
@property (weak, nonatomic) IBOutlet UIImageView *mailBindImage;

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"安全中心";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBindBack) name:@"GetUserBindInfo" object:nil];
    
    NSArray *parameters = @[ @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
    
    NSString* url = @"http://exchange-test.oneitfarm.com/server/account/bindInfo";
    
    [[HttpRequest getInstance] postWithUrl:url data:parameters notification:@"GetUserBindInfo"];
    
}

-(void)getBindBack{
    
    NSDictionary* data = [[HttpRequest getInstance] httpBack];
    NSLog(@"data = %@",data);
    
    NSNumber* number = [data objectForKey:@"ret"];
    if([number intValue] == 1){
        NSDictionary* info = [data objectForKey:@"data"];
        NSLog(@"info = %@",info);
        NSString* email = [info objectForKey:@"email"];
        if([email containsString:@"@"]){
            self.mailBindImage.hidden = YES;
            self.mailBindLabel.hidden = NO;
        }else{
            self.mailBindLabel.hidden = YES;
            self.mailBindImage.hidden = NO;
        }
         NSString* phone = [info objectForKey:@"phone"];
        if(phone.length>0){
            self.phoneBindImage.hidden = YES;
            self.phoneBindLabel.hidden = NO;
        }else{
            self.phoneBindLabel.hidden = YES;
            self.phoneBindImage.hidden = NO;
        }
    }
    
}
- (IBAction)clickGestureVerify:(id)sender {
    UISwitch* btn = (UISwitch*)sender;
    BOOL ison = [btn isOn];
    NSLog(@"clickGestureVerify ison = %d",ison);
}
- (IBAction)clickTwiceVerify:(id)sender {
    UISwitch* btn = (UISwitch*)sender;
    BOOL ison = [btn isOn];
    NSLog(@"clickTwiceVerify ison = %d",ison);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickMoneyPassword:(id)sender {
    SetMoneyPasswordViewController* vc = [[SetMoneyPasswordViewController alloc] initWithNibName:@"SetMoneyPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickPassword:(id)sender {
    
    SetPasswordViewController *vc = [[SetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickBindMail:(id)sender {
    
}
- (IBAction)clickBindPhone:(id)sender {
    
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

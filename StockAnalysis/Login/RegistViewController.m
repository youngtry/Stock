//
//  RegistViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/6/13.
//  Copyright © 2018年 try. All rights reserved.
//

#import "RegistViewController.h"
#import "XWCountryCodeController.h"
#import "MailRegistViewController.h"
#import "HttpRequest.h"
@interface RegistViewController ()<XWCountryCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickMainRegist:(id)sender {
    MailRegistViewController *vc = [[MailRegistViewController alloc] initWithNibName:@"MailRegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickCountryCode:(id)sender {
    
    XWCountryCodeController* countrycodeVC = [[XWCountryCodeController alloc] init];
    countrycodeVC.deleagete = self;
    [countrycodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        countryCodeStr = [countryCodeStr substringFromIndex:[countryCodeStr rangeOfString:@"+"].location];
        NSLog(@"countryCodeStr = %@",countryCodeStr);
        [self.countryCodeButton.titleLabel setText:countryCodeStr];
    }];
    
    [self presentViewController:countrycodeVC animated:YES completion:nil];
    
}
- (IBAction)clickGetVerify:(id)sender {
   
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
//                               @"Content-Type": @"application/x-www-form-urlencoded",
                               @"authorization": @"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyLCJhY2NvdW50X2lkIjoiOTBiMTYwYzEyNTliNDgzMTg1NjgxNGZmM2YyNDE2MTkiLCJjaWFjY291bnRfdG9rZW4iOiJqMG1GWTFOUDhRNUpvRVpwLlBMY01CZEE4RkkxUlp4dUsuMWVjMTcxNWU1OThkYTYzNmViNjFhNTdkMDM3ZjNhOGMiLCJleHAiOjE1MzAzNDY2MzF9.xCpz2bzjQAUUv62UeW4GKFCbnjw1OF8nNvZTbzNm5Q0",
                               @"Cache-Control": @"no-cache",
                               @"Postman-Token": @"57bb5e1b-7c27-4f1d-a5c2-fd56b5604d38" };
    NSArray *parameters = @[ @{ @"name": @"phone", @"value": @"17751766215" },
                             @{ @"name": @"captcha", @"value": @"8888" },
                             @{ @"name": @"password", @"value": @"123456" },
                             @{ @"name": @"district", @"value": @"+86" },
                             @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@\r\n", param[@"value"]];
        }
    }
    [body appendFormat:@"--%@--\r\n", boundary];
    NSLog(@"body = %@",body);
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://exchange-test.oneitfarm.com/server/register/phone"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
//                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSDictionary* _dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil ];
                                                        NSLog(@"post返回数据为：%@",_dataDictionary);
                                                        NSString* msg = [_dataDictionary objectForKey:@"msg"];
                                                        NSLog(@"mesg = %@",msg);
                                                    }
                                                }];
    [dataTask resume];
    
    return;
    
    NSString* url = @"http://exchange-test.oneitfarm.com/server/register/phone";
//    NSDictionary* params = @{@"phone":@"17751766214",
//                             @"captcha":@"8888",
//                             @"password":@"123456",
//                             @"district":@"+86",
//                             @"appkey":@"5yupjrc7tbhwufl8oandzidjyrmg6blc",
//                             @"channel":@"0"
//                             };
    NSArray *parameters1 = @[ @{ @"name": @"phone", @"value": @"17751766215" },
                             @{ @"name": @"captcha", @"value": @"8888" },
                             @{ @"name": @"password", @"value": @"123456" },
                             @{ @"name": @"district", @"value": @"+86" },
                             @{ @"name": @"appkey", @"value": @"5yupjrc7tbhwufl8oandzidjyrmg6blc" },
                             @{ @"name": @"channel", @"value": @"0" } ];
//    NSMutableData* data = [[NSMutableData alloc] init];
//    [data appendData:[@"phone=17751766214/r/n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[@"captcha=8888/r/n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[@"password=123456/r/n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[@"district=+86/r/n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[@"appkey=5yupjrc7tbhwufl8oandzidjyrmg6blc/r/n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[@"channel=0/r/n" dataUsingEncoding:NSUTF8StringEncoding]];
    [[HttpRequest getInstance] postWithUrl:url data:parameters1];
}
//1.代理传值
#pragma mark - XWCountryCodeControllerDelegate
-(void)returnCountryCode:(NSString *)countryCode{
    
    countryCode = [countryCode substringFromIndex:[countryCode rangeOfString:@"+"].location];
    NSLog(@"countryCode = %@",countryCode);
    [self.countryCodeButton.titleLabel setText:countryCode];
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

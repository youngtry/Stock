//
//  ZhifubaoViewController.m
//  StockAnalysis
//
//  Created by Macbook on 2018/8/14.
//  Copyright © 2018年 try. All rights reserved.
//

#import "ZhifubaoViewController.h"
#import "MoneyVerifyViewController.h"

@interface ZhifubaoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *alipayAccount;
@property (weak, nonatomic) IBOutlet UITextField *verifyInput;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaIcon;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImage;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation ZhifubaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置支付宝";
    UITapGestureRecognizer *f = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test)];
    [self.view addGestureRecognizer:f];
    self.view.userInteractionEnabled = YES;
    
    [self.saveBtn setEnabled:NO];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"alipay_pay.jpg"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fullPath error:nil];
    
//    MoneyVerifyViewController* vc = [[MoneyVerifyViewController alloc] initWithNibName:@"MoneyVerifyViewController" bundle:nil];
//
//    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    self.definesPresentationContext = YES;
//
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
-(void)test{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editEnd:(id)sender {
    if([self isInputAll]){
        [self.saveBtn setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0]];
        [self.saveBtn setEnabled:YES];
    }else{
        [self.saveBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
        [self.saveBtn setEnabled:NO];
    }
}

-(BOOL)isInputAll{
    if(self.nameLabel.text.length == 0){
        return NO;
    }
    if(self.alipayAccount.text.length == 0){
        return NO;
    }
    if(self.verifyInput.text.length == 0){
        return NO;
    }
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"alipay_pay.jpg"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:fullPath];
    
    return result;
}

- (IBAction)clickSendVerifyBtn:(id)sender {
}
- (IBAction)clickUpbtn:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    sheet.tag = 2550;
    //显示消息框
    [sheet showInView:self.view];
}
- (IBAction)clickSaveBtn:(id)sender {
    
    MoneyVerifyViewController* vc = [[MoneyVerifyViewController alloc] initWithNibName:@"MoneyVerifyViewController" bundle:nil];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    [self.navigationController presentViewController:vc animated:YES completion:nil];

    
    vc.block = ^(NSString* token) {
        if(token.length>0){
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"alipay_pay.jpg"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL result = [fileManager fileExistsAtPath:fullPath];
            
            if(!result){
                fullPath = @"";
                [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"收款码未上传,请重新上传"];
                return;
            }
            
            NSString* url = @"wallet/set_alipay";
            NSDictionary* params = @{@"name":self.nameLabel.text,
                                     @"alipay_id":self.alipayAccount.text,
                                     @"phone_captcha":self.verifyInput.text,
                                     @"asset_token":token
                                     };
            
            NSDictionary* file = @{@"paycode":fullPath};
            [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中…"];
            [[HttpRequest getInstance] postWithURLWithFile:url parma:params file:file block:^(BOOL success, id data) {
                if(success){
                    [HUDUtil hideHudView];
                    if([[data objectForKey:@"ret"] intValue] == 1){
                        [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"设置成功"];
                        [fileManager removeItemAtPath:fullPath error:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
                    }
                }
            }];
        }
    };
    
    
}

#pragma mark -消息框代理实现-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 2550) {
        NSUInteger sourceType = 0;
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.delegate = self; //设置代理
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType; //图片来源
            if (buttonIndex == 0) {
                return;
            }else if (buttonIndex == 1) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else if (buttonIndex == 2){
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage]; //通过key值获取到图片
    
    _erweimaImage.image = image;
    [_upBtn setHidden:YES];
    [_erweimaIcon setHidden:YES];
    _erweimaImage.userInteractionEnabled = YES;
    [_erweimaImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUpbtn:)]];
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
    //    ......
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"alipay_pay.jpg"];
    //将图片写入文件中
    [imageData writeToFile:fullPath atomically:NO];
    
    
    if([self isInputAll]){
        [self.saveBtn setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:186.0/255.0 blue:46.0/255.0 alpha:1.0]];
        [self.saveBtn setEnabled:YES];
    }else{
        [self.saveBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
        [self.saveBtn setEnabled:NO];
    }
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
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

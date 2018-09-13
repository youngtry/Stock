//
//  AuthApprove23VC.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthApprove23VC.h"
#import "AuthViewController.h"
@interface AuthApprove23VC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *authImage;

@end

@implementation AuthApprove23VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"级别2";
    self.nextBtn.layer.cornerRadius = 25;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.enabled = NO;
    [self.nextBtn setTitleColor:kColor(251, 173, 20) forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:kColor(255, 255, 255) forState:UIControlStateDisabled];
    
    self.preBtn.layer.cornerRadius = 25;
    self.preBtn.layer.masksToBounds = YES;
    self.preBtn.enabled = YES;
    self.preBtn.layer.borderColor = kColor(251, 173, 20).CGColor;
    self.preBtn.layer.borderWidth = 1;
    [self.preBtn setTitleColor:kColor(251, 173, 20) forState:UIControlStateNormal];
    [self.preBtn setTitleColor:kColor(255, 255, 255) forState:UIControlStateDisabled];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAutiImage)];
    self.authImage.userInteractionEnabled = YES;
    [self.authImage addGestureRecognizer:tap];
}
-(void)clickAutiImage{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    sheet.tag = 2550;
    //显示消息框
    [sheet showInView:self.view];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickPreBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickNextBtn:(id)sender {
    
    NSString *fullPath1 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Auth_1.jpg"];
    NSString *fullPath2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Auth_2.jpg"];
    NSString *fullPath3 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Auth_3.jpg"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result1 = [fileManager fileExistsAtPath:fullPath1];
    BOOL result2 = [fileManager fileExistsAtPath:fullPath2];
    BOOL result3 = [fileManager fileExistsAtPath:fullPath3];
    NSLog(@"这个文件已经存在：%@",result1?@"是的":@"不存在");
    NSLog(@"这个文件已经存在：%@",result2?@"是的":@"不存在");
    NSLog(@"这个文件已经存在：%@",result3?@"是的":@"不存在");
    NSLog(@"path1 = %@,path2 = %@,path3 = %@",fullPath1,fullPath2,fullPath3);
    if(!result1){
        fullPath1 = @"";
    }
    
    if(!result2){
        fullPath2 = @"";
    }
    
    if(!result3){
        fullPath3 = @"";
    }
    
    NSString* url = @"account/verity2";
    NSDictionary* params = @{};
    
    NSDictionary* file = @{@"card_front":fullPath1,
                           @"card_back":fullPath2,
                           @"card_hand_held":fullPath2
                           };
    [HUDUtil showHudViewInSuperView:self.navigationController.view withMessage:@"认证中,请稍后"];
    [[HttpRequest getInstance] postWithURLWithFile:url parma:params file:file block:^(BOOL success, id data) {
        if(success){
            if([[data objectForKey:@"ret"] intValue] == 1){
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:@"认证成功"];
                for (UIViewController*vc in self.navigationController.childViewControllers) {
                    if([vc isKindOfClass:[AuthViewController class]]){
                        [self.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
            }else{
                [HUDUtil showHudViewTipInSuperView:self.navigationController.view withMessage:[data objectForKey:@"msg"]];
            }
        }
    }];
    
    
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    self.authImage.image = image;
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
    //    ......
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"Auth_3.jpg"]];
    //将图片写入文件中
    [imageData writeToFile:fullPath atomically:NO];
    
    self.nextBtn.layer.borderColor = kColor(251, 173, 20).CGColor;
    self.nextBtn.layer.borderWidth = 1;
    [self.nextBtn setEnabled:YES];
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

//
//  AuthApprove21ViewController.m
//  StockAnalysis
//
//  Created by ymx on 2018/7/6.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AuthApprove21ViewController.h"
#import "AuthApprove22VC.h"
@interface AuthApprove21ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *authImage;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation AuthApprove21ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"Level_2");
    self.nextButton.layer.cornerRadius = 25;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.enabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAutiImage)];
    self.authImage.userInteractionEnabled = YES;
    [self.authImage addGestureRecognizer:tap];
    
    [self.nextButton setBackgroundColor:kColor(224, 224, 224)];
    [self.nextButton setEnabled:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)clickAutiImage{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:Localize(@"Select") delegate:self cancelButtonTitle:nil destructiveButtonTitle:Localize(@"Menu_Cancel") otherButtonTitles:Localize(@"Take_Photo"),Localize(@"Select_Photo"), nil];
    sheet.tag = 2550;
    //显示消息框
    [sheet showInView:self.view];
}
- (IBAction)clickNext:(id)sender {
    AuthApprove22VC *vc = [[AuthApprove22VC alloc] initWithNibName:@"AuthApprove22VC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.authImage.image = image;
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
    //    ......
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"Auth_1.jpg"]];
    //将图片写入文件中
    [imageData writeToFile:fullPath atomically:NO];
    
    [self.nextButton setBackgroundColor:kColor(243, 186, 46)];
    [self.nextButton setEnabled:YES];
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

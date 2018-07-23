//
//  FeedbackEditVC.m
//  StockAnalysis
//
//  Created by Macbook on 2018/7/7.
//  Copyright © 2018年 try. All rights reserved.
//

#import "FeedbackEditVC.h"

@interface FeedbackEditVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UILabel *topLab1;
@property (weak, nonatomic) IBOutlet UILabel *topLab2;
@property (weak, nonatomic) IBOutlet UIImageView *headerV;
@property (weak, nonatomic) IBOutlet UIImageView *headerV1;
@property (weak, nonatomic) IBOutlet UIButton *firstClosebtn;

@property (weak, nonatomic) IBOutlet UIButton *secondCloseBtn;
@property(nonatomic,strong) UIImagePickerController *imagePicker;

@property(nonatomic)int clickIndex;

@end

@implementation FeedbackEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.commitBtn.layer.cornerRadius = 25;
    self.commitBtn.layer.masksToBounds = YES;
    
    _topLab1.text = self.title1;
    _topLab2.text = self.title2;
    
    _firstClosebtn.enabled  = NO;
    _firstClosebtn.hidden = YES;
    
    _secondCloseBtn.enabled  = NO;
    _secondCloseBtn.hidden = YES;
    
    _clickIndex = 1;
    
    [self setImgUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickCloseFirstPic:(id)sender {
    _headerV.image = [UIImage imageNamed:@"jia.png"];
    _firstClosebtn.enabled  = NO;
    _firstClosebtn.hidden = YES;
}
- (IBAction)clickCloseSecondPic:(id)sender {
    _headerV1.image = [UIImage imageNamed:@"jia.png"];
    _secondCloseBtn.enabled  = NO;
    _secondCloseBtn.hidden = YES;
}

- (void)setImgUI {
    //UIimageView的基本设置
//    _headerV.layer.cornerRadius = 100/2;
//    _headerV.clipsToBounds = YES;
//    _headerV.layer.borderWidth = 1;
//    _headerV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headerV.userInteractionEnabled = YES;
    [_headerV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    
//    _headerV1.layer.cornerRadius = 100/2;
//    _headerV1.clipsToBounds = YES;
//    _headerV1.layer.borderWidth = 1;
//    _headerV1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headerV1.userInteractionEnabled = YES;
    [_headerV1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick1)]];
}
#pragma mark -头像UIImageview的点击事件-
- (void)headClick {
    //自定义消息框
    _clickIndex = 1;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    sheet.tag = 2550;
    //显示消息框
    [sheet showInView:self.view];
}

- (void)headClick1 {
    //自定义消息框
    _clickIndex = 2;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    sheet.tag = 2550;
    //显示消息框
    [sheet showInView:self.view];
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
    if(_clickIndex == 1){
        _headerV.image = image;  //给UIimageView赋值已经选择的相片
        _firstClosebtn.enabled = YES;
        _firstClosebtn.hidden = NO;
    }else if (_clickIndex == 2){
        _headerV1.image = image;  //给UIimageView赋值已经选择的相片
        _secondCloseBtn.enabled = YES;
        _secondCloseBtn.hidden = NO;
    }
 
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
//    ......
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

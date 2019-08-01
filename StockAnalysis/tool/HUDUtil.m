//
//  HUDUtil.h
//
//
//  Created by ymx
//  Copyright (c) 2018年 ymx. All rights reserved.
//

#import "HUDUtil.h"
static MBProgressHUD *hud;
@implementation HUDUtil

+(void) showHudViewInSuperView:(UIView *)view withMessage:(NSString *)message
{
    if(hud){
        [self hideHudView];
    }
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
}

+(void) showHudViewTipInSuperView:(UIView *)view withMessage:(NSString *)message
{
    if(hud){
        [self hideHudView];
    }
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14];
    [hud hide:YES afterDelay:kTipDelay];
}

+(void) hideHudView
{
    if (hud)
    {
        [hud hide:YES];
        hud = nil;
    }
}

+(void) hideHudViewWithSuccessMessage:(NSString *)message
{
    if (!hud)
    {
        return;
    }
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hud_success"]];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    [hud hide:YES afterDelay:kTipDelay];
}

+(void) hideHudViewWithFailureMessage:(NSString *)message
{
    if (!hud)
    {
        return;
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    [hud hide:YES afterDelay:kTipDelay];
}

+(void) showCustomView:(UIView *)customView byReduceDeltaY:(CGFloat)deltaY message:(NSString *)message
{
    hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.labelText = message;
    hud.yOffset = deltaY;
    [hud show:YES];
}

+(void) updateLabelText:(NSString *)labelText
{
    if (hud)
    {
        hud.labelText = labelText;
    }
}

+(void)showSystemTipView:(UIViewController*)vc  title:(NSString *)title withContent:(NSString *)content{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:Localize(@"Menu_Sure") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //弹出提示框；
    [vc presentViewController:alert animated:true completion:nil];
}
@end

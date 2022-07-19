//
// Created by admin on 2022/7/18.
//

#import "EnvironmentAlertUI.h"
#import "EnvironmentModel.h"
#import <UIKit/UIKit.h>


@implementation EnvironmentAlertUI
+ (void)showEnvironment:(NSArray<EnvironmentModel *> *)modelList
         selectCallBack:(_Nullable EnvironmentSelectBlock)callBack {

    NSArray<EnvironmentModel *> *environmentList = modelList;

    //初始化弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择服务环境"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (EnvironmentModel *model in environmentList) {
        __block EnvironmentModel *value = model;
        [alert addAction:[UIAlertAction actionWithTitle:model.environmentName
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    if (callBack) {
                                                        callBack(value);
                                                    }
                                                }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

    }]];
    //弹出提示框
    [[self currentViewController] presentViewController:alert animated:true completion:nil];
}


+ (UIViewController *)currentViewController {
    UIWindow *window = [self getKeyWindow];
    UIViewController *presentedVC = [[window rootViewController] presentedViewController];
    if (presentedVC) {
        return presentedVC;

    } else {
        return window.rootViewController;
    }
}



+ (UIWindow *)getKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    } else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}
@end


@implementation EnvironmentAlertUI(SimpleAlert)
+ (void)showError:(NSString *)msg {
    [self showAlert:@"失败" msg:msg];
}

+ (void)showSuccess:(NSString *)msg {
    [self showAlert:@"成功" msg:msg];
}

+ (void)showAlert:(NSString *)title msg:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

    }]];
    //弹出提示框
    [[self currentViewController] presentViewController:alert animated:true completion:nil];
}
@end
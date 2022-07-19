//
// Created by admin on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "EnvironmentModel.h"

typedef void (^EnvironmentSelectBlock)(EnvironmentModel * __nonnull model);

@interface EnvironmentAlertUI : NSObject
+ (void)showEnvironment:(NSArray<EnvironmentModel *> * __nonnull)modelList
         selectCallBack:(_Nullable EnvironmentSelectBlock)callBack;
@end

@interface EnvironmentAlertUI(SimpleAlert)
+ (void)showError:(NSString * __nonnull)msg;
+ (void)showSuccess:(NSString * __nonnull)msg;
@end
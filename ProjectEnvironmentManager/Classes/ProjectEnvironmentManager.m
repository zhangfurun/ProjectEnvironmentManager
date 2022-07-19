//
//  ProjectEnvironmentManager.m
//  ProjectEnvironmentManager
//
//  Created by admin on 2022/7/18.
//

#import "ProjectEnvironmentManager.h"
#import "ProjectEnvironmentDelegate.h"
#import "EnvironmentAlertUI.h"

#import <MobileProvision/MobileProvision.h>


static NSString *CY_ENVIRONMENT_LOCAL_RECORD_KEY = @"CY_ENVIRONMENT_LOCAL_RECORD_KEY";


static ProjectEnvironmentManager *_manager = nil;

@interface ProjectEnvironmentManager ()
/// 选择版本管理
@property(nonatomic, weak) id <ProjectEnvironmentDelegate> delegate;
/// 服务器列表
@property(nonatomic, strong) NSArray<EnvironmentModel *> *environmentList;
@property(nonatomic, strong) EnvironmentModel *currentEnvironmentModel;

@property(nonatomic, strong, readonly) ProjectEnvironmentManager *sharedManager;
@end

@implementation ProjectEnvironmentManager

#pragma mark - Manager Load Method

+ (void)loadManagerWithEnvironmentList:(NSArray<EnvironmentModel *> *)modelList {
    [self initManagerWithEnvironmentList:modelList];

    [ProjectEnvironmentManager postLoadFinishMsg];
}

+ (void)loadManagerWithEnvironmentList:(NSArray<EnvironmentModel *> *)modelList
                              delegate:(nonnull id <ProjectEnvironmentDelegate>)delegate {
    ProjectEnvironmentManager *manager = [self initManagerWithEnvironmentList:modelList];
    manager.delegate = delegate;

    [ProjectEnvironmentManager postLoadFinishMsg];
}


+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ProjectEnvironmentManager alloc] init];
    });
    return _manager;
}


+ (EnvironmentModel *)currentEnvironment {
    return [[self sharedManager] currentEnvironmentModel];
}

+ (void)exchangeEnvironment {
    [EnvironmentAlertUI showEnvironment:[[self sharedManager] environmentList]
                         selectCallBack:^(EnvironmentModel *model) {
                             // 判断选择的和当前的是否一致
                             if ([self currentEnvironment].identifyID == model.identifyID) {
                                 [EnvironmentAlertUI showError:[NSString stringWithFormat:@"切换失败: 当前已经是%@", model.environmentName]];
                             } else {
                                 [self.sharedManager updateEnvironment:model];

                                 NSLog(@"切换成功:%@", [self currentEnvironment].environmentName);
                             }
                         }];
}

#pragma mark - Private Method
+ (instancetype)initManagerWithEnvironmentList:(NSArray<EnvironmentModel *> *)modelList {
    NSArray<EnvironmentModel *> *environmentList = [modelList mutableCopy];

    // 断言判断当前服务器列表是否合规
    NSAssert(modelList && modelList.count > 1, @"服务器配置数组不能为空数组");

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isProMain == YES"];
    NSArray<EnvironmentModel *> *result = [modelList filteredArrayUsingPredicate:predicate];
    NSAssert(result && result.count == 1, @"服务器配置必须包含一个isProMain为YES的情况");
    // 当前的默认服务器模型
    EnvironmentModel *proMainModel = result.firstObject;

    // ================= 判断当前的安装包的环境  =====================
    MPProvision *provision = [MPProvision embeddedProvision]; // embedded.mobileprovision
    if (!provision) {
        // 只校验有证书的情况
        if (provision.type == MPProvisionTypeAppStore) {
            environmentList = @[proMainModel];
        }
    }

    // 此时已经过滤出符合条件的服务器的列表
    // 获取本地保存的服务器, 与当前列表作对比
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *recordEnvironment = [userDefaults stringForKey:CY_ENVIRONMENT_LOCAL_RECORD_KEY];

    ProjectEnvironmentManager *manager = [self sharedManager];

    if (recordEnvironment) {
        // 本地有记录, 则对比
        NSPredicate *isHaveInEnvListPredicate = [NSPredicate predicateWithFormat:@"identifyID like %@", recordEnvironment];
        NSArray<EnvironmentModel *> *listHaveModel = [environmentList filteredArrayUsingPredicate:isHaveInEnvListPredicate];
        if (listHaveModel && listHaveModel.count > 0) {
         // 如果本地有, 则设置当前model为current
            manager.currentEnvironmentModel = listHaveModel.firstObject;
        } else {
            manager.currentEnvironmentModel = proMainModel;
        }
    } else {
        // 本地没有记录 直接赋值
        manager.currentEnvironmentModel = proMainModel;
    }

    manager.environmentList = environmentList;
    return manager;
}

#pragma mark - Update Local Record

- (void)updateEnvironment:(EnvironmentModel *)model {
    self.currentEnvironmentModel = model;
}

- (void)setCurrentEnvironmentModel:(EnvironmentModel *)currentEnvironmentModel {
    BOOL isFirstSetting = _currentEnvironmentModel == nil;
    _currentEnvironmentModel = currentEnvironmentModel;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:_currentEnvironmentModel.identifyID
                    forKey:CY_ENVIRONMENT_LOCAL_RECORD_KEY];
    [userDefaults synchronize];
    
    if (!isFirstSetting) {
        [ProjectEnvironmentManager postExchangeMsg:_currentEnvironmentModel];
    }
}

#pragma mark - Msg

+ (void)postLoadFinishMsg {
    ProjectEnvironmentManager *manager = self.sharedManager;
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(environmentLoadingFinish)]) {
        [manager.delegate environmentLoadingFinish];
    } else {
        // 通知的形式
        [[NSNotificationCenter defaultCenter] postNotificationName:CY_ENVIROMENT_LOAD_FINISH_NOTIFICATION_NAME
                                                            object:nil
                                                          userInfo:nil];
    }
}

+ (void)postExchangeMsg:(EnvironmentModel *)model {
    ProjectEnvironmentManager *manager = self.sharedManager;
    if(manager.delegate && [manager.delegate respondsToSelector:@selector(environmentChange:)]) {
        [manager.delegate environmentChange:model];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:CY_ENVIROMENT_CHANGE_NOTIFICATION_NAME
                                                            object:nil
                                                          userInfo:nil];
    }
}
@end

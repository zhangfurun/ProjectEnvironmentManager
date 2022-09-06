//
//  ProjectEnvironmentManager.h
//  ProjectEnvironmentManager
//
//  Created by admin on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "EnvironmentModel.h"
#import "ProjectEnvironmentDelegate.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *CY_ENVIRONMENT_LOAD_FINISH_NOTIFICATION_NAME = @"CY_ENVIRONMENT_LOAD_FINISH_NOTIFICATION_NAME";
static NSString *CY_ENVIRONMENT_CHANGE_NOTIFICATION_NAME = @"CY_ENVIRONMENT_CHANGE_NOTIFICATION_NAME";

#define ENVIRONMENT_DELEGATE delegate:(id<ProjectEnvironmentDelegate>)delegate;

@interface ProjectEnvironmentManager : NSObject

+ (void)loadManagerWithEnvironmentList:(NSArray<EnvironmentModel *> *)modelList;
+ (void)loadManagerWithEnvironmentList:(NSArray<EnvironmentModel *> *)modelList ENVIRONMENT_DELEGATE;

+ (EnvironmentModel *)currentEnvironment;

+ (void)exchangeEnvironment;
@end

NS_ASSUME_NONNULL_END

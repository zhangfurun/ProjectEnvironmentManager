//
// Created by admin on 2022/7/18.
//

#import <Foundation/Foundation.h>

#import "EnvironmentModel.h"

@protocol ProjectEnvironmentDelegate <NSObject>
/// 环境初始化
- (void)environmentLoadingFinish;
/// 切换环境(此处不做相等判断处理)
- (void)environmentChange:(EnvironmentModel *)environmentModel;
@end

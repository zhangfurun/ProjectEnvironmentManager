//
//  EnvironmentModel.h
//  ProjectEnvironmentManager
//
//  Created by admin on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnvironmentModel : NSObject
/// 服务器标识符id
@property(nonatomic, copy) NSString *identifyID;
/// 服务器环境
@property(nonatomic, copy) NSString *environmentName;
/**
 * 是不是生产正式服(即为线上)
 * 注: 在配置数组中, 此标签仅为数组中设置的第一个数据有效, 如果没有设置, 则会断言报错
 */
@property(nonatomic, assign) BOOL isProMain;


//- (instancetype)initWithIdentifyID:(NSString *)identifyID
//                   environmentName:(NSString *)environmentName
//                         isProMain:(BOOL)isProMain NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

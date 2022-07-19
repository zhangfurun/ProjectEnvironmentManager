//
//  EnvironmentModel.m
//  ProjectEnvironmentManager
//
//  Created by admin on 2022/7/18.
//

#import "EnvironmentModel.h"

@implementation EnvironmentModel

- (instancetype)initWithIdentifyID:(NSString *)identifyID
                   environmentName:(NSString *)environmentName
                         isProMain:(BOOL)isProMain  {
    
    if (self = [super init]) {
        _identifyID = identifyID;
        _environmentName = environmentName;
        _isProMain = isProMain;
    }
    return self;
}
@end

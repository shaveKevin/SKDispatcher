//
//  SKDispatcher.m
//  DispatcherManager
//
//  Created by shavekevin on 2018/1/16.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKDispatcher.h"


NSString * const kSKDispatcherScheme = @"scheme";
NSString * const kSKDispatcherTarget = @"target";
NSString * const kSKDispatcherAction = @"action";
NSString * const kSKDispatcherTransformType = @"transformType";
NSString * const kSKDispatcherParams = @"params";

@implementation SKDispatcher

+ (instancetype)sharedInstance {
    static SKDispatcher *dispatcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatcher = [[SKDispatcher alloc]init];
    });
    return dispatcher;
}

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    
    // this used for forward call, if url call isn't current return no else do something
    if (![url.scheme isEqualToString:self.appName]) {
        return @(NO);
    }
    // get params by url then set parmes to params
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elements = [param componentsSeparatedByString:@"="];
        // if string is not param && count <2 return
        if ([elements count] < 2)continue;
        [params setObject:[elements lastObject] forKey:[elements firstObject]];
    }
    //avoid forward call native module
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (self.nativeActionName&& self.nativeActionName.length) {
        if ([actionName hasPrefix:self.nativeActionName]) {
            return @(NO);
        }
    }else {
        if ([actionName hasPrefix:@"native"]) {
            return @(NO);
        }
    }
    // take actions
    id result = [self performTarget:url.host action:actionName params:params];
    // according  to  action result show completion  block
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        }else {
            completion(nil);
        }
    }
    return result;
}

- (id)performActionWithJson:(NSString *)json completion:(void (^)(NSDictionary *))completion {
    
    id result = nil;
    if (json) {
        NSDictionary *dict = [self transmitJsonStingToDict:json];
        if (dict) {
            // if not target app return
            if (![dict[kSKDispatcherScheme] isEqualToString:self.appName]) {
                return result;
            }
            //
            NSString *targetName = dict[kSKDispatcherTarget];
            NSString *actionName = dict[kSKDispatcherAction];
            NSDictionary *params = dict[kSKDispatcherScheme];
            result = [self performTarget:targetName action:actionName params:params];
            // according  to  action result show completion  block
            if (completion) {
                if (result) {
                    completion(@{@"result":result});
                }else {
                    completion(nil);
                }
            }
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params {
    
    // Target_targetName：target class name；Action_actionName：method name in target Class
    NSString *targetClassString  = [NSString stringWithFormat:@"%@%@",(self.targetClassName?self.targetClassName:@"Target_"),targetName];
    NSString *actionString = [NSString stringWithFormat:@"%@%@:",(self.actionMethodName?self.actionMethodName:@"action_"), actionName];
    // target do SEL
    Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc]init];
    SEL action = NSSelectorFromString(actionString);
    //if target is nil return nil
    if (target == nil) {
        return nil;
    }
    // do actions performSelector
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    }else {
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        } else {
            //2.2.2如果notFound都没有的时候，直接return
            return nil;
        }
    }
}

- (UIViewController *)dispatcher_viewControllerForTargetDict:(NSDictionary *)targetParame
                                                      params:(NSDictionary *)params {
    
    NSAssert(targetParame[@"Target"] != nil && targetParame[@"Action"] != nil, @"字典中必须要有Target和Action字段");
    
    if (targetParame[@"Target"] && targetParame[@"Action"]) {
        // 创建Controller
        UIViewController * viewController = [self performTarget:targetParame[@"Target"]
                                                         action:targetParame[@"Action"]
                                                         params:params];
        // 交付view controller 由外界选择是push 还是 present
        if ([viewController isKindOfClass:[UIViewController class]]) {
            return viewController;
        } else {
            return [[UIViewController alloc] init];
        }
    } else {
        return [[UIViewController alloc] init];
    }
}

+ (void)dispatcher_viewControllerForTargetDict:(NSDictionary *)targetParame
                                        params:(NSDictionary *)params
                                       pushNav:(UINavigationController *)pushNav
                                      animated:(BOOL)animated {
    if (!pushNav) {
        return;
    }
    
    NSAssert(targetParame[@"Target"] != nil && targetParame[@"Action"] != nil, @"字典中必须要有Target和Action字段");
    
    if (targetParame[@"Target"] && targetParame[@"Action"]) {
        // 创建Controller
        UIViewController * viewController = [[SKDispatcher sharedInstance] performTarget:targetParame[@"Target"]
                                                                                   action:targetParame[@"Action"]
                                                                                   params:params];
        // 交付view controller  由外界选择是push 还是 present
        if ([viewController isKindOfClass:[UIViewController class]]) {
            [pushNav pushViewController:viewController animated:animated];
        } else {
            [pushNav pushViewController:[[UIViewController alloc] init] animated:animated];
        }
    } else {
        [pushNav pushViewController:[[UIViewController alloc] init] animated:animated];
    }
}
#pragma mark utils
// jsonStringToDict
- (NSDictionary *)transmitJsonStingToDict:(NSString *)jsonDict {
    
    NSData *jsonData = [jsonDict dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    return dict;
}
// dictToJsonString
- (NSString *)transmitDictToJsonString:(NSDictionary *)dict {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end

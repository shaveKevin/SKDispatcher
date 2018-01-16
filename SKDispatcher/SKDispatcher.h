//
//  SKDispatcher.h
//  DispatcherManager
//
//  Created by shavekevin on 2018/1/16.
//  Copyright © 2018年 shavekevin. All rights reserved.
//
// 跳转的类
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const kSKDisptcherScheme;
extern NSString * const kSKDispatcherTarget;
extern NSString * const kSKDispatcherAction;
extern NSString * const kSKDispatcherTransformType;
extern NSString * const kSKDispatcherParams;

@interface SKDispatcher : NSObject
/**
 appName used for analyse(应用名字，用于统计以及调用)
 */
@property (nonatomic, copy) NSString *appName;
/**
 nativeActionName default is native (本地action调用的方法前缀)optional
 */
@property (nonatomic, copy) NSString *nativeActionName;
/**
 targetClassName default is Target_xxx(默认target类名前缀,默认为Target_)optional
 */
@property (nonatomic, copy) NSString *targetClassName;
/**
 actionMethodName default is action_xxx optional(默认的方法名前缀,默认为action_)optional
 */
@property (nonatomic, copy) NSString *actionMethodName;
/**
 single
 @return self
 */
+ (instancetype)sharedInstance;
/**
 forward app  called ,other app call current app

 @param url scheme://[target]/[action]?[params]
 @param completion finishblock
 @return called result
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
/**
 forward server  called ,called with jsonstring
 @  param json transmit json as follows
 *               scheme：appName
 *               target：module name
 *               action：module action
 *               params：module params should be a dict
 @param completion finished block
 @return called result
 */
- (id)performActionWithJson:(NSString *)json completion:(void(^)(NSDictionary *info))completion;

/**
 current call
 @param targetName targetName
 @param actionName actionName
 @param params params
 @return called result
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;

@end

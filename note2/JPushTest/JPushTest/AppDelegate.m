//
//  AppDelegate.m
//  JPushTest
//
//  Created by huangxu on 16/1/20.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#define JPushAppKey @"04aa6ee1b6d14ee158608a21"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self handleSetUpJPush:launchOptions];
    return YES;
}

- (void)handleSetUpJPush:(NSDictionary *)launchOptions
{
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:nil apsForProduction:NO];
}

//在APNs上注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册DeviceToken成功：%@", deviceToken);
    
    [JPUSHService registerDeviceToken:deviceToken];
    
#pragma  mark - JPush通知事件
    //监听 建立连接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    
    //监听 关闭连接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    
    //监听 注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    
    //监听 登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    //监听 接收到信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //监听 错误信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ServiceError:) name:kJPFServiceErrorNotification object:nil];
}

//注册失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册失败：%@", error);
}

//接收到远程消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma  mark -- JPush推送
// 已建立连接
-(void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"已与JPush建立连接");
}

// 已关闭连接
-(void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"已与JPush关闭连接");
}

// 已注册成功
-(void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"已在JPush上注册成功");
}

// 已登陆成功
-(void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"已在JPush上登陆成功");
}

// 已接收到数据
-(void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSLog(@"已接收到JPush发送过来的数据：%@", notification.userInfo);
}

// 已出现错误
-(void)ServiceError:(NSNotification *)notification
{
    NSLog(@"出现错误");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  AppDelegate.m
//  MapDemo
//
//  Created by Y杨定甲 on 16/2/29.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "AppDelegate.h"

#import <MAMapKit/MAMapKit.h>
@interface AppDelegate ()<CLLocationManagerDelegate>

@end
#define MAMapKey @"d8b0c5c5a92678c1171dd2994aea1c56"
@implementation AppDelegate
{
    CLLocationManager  *locationManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化高德地图key
    [self configureAPIKey];
    return YES;
}

#pragma mark - 加载高德地图key
- (void)configureAPIKey
{
    [MAMapServices sharedServices].apiKey = MAMapKey;
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];//注意，这里的locationManager不是局部变量
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        //兼容iOS8定位
        SEL requestSelector = NSSelectorFromString(@"requestAlwaysAuthorization");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
            [locationManager respondsToSelector:requestSelector]) {
            
            [locationManager requestAlwaysAuthorization];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"定位失败" message:@"请打开定位或者检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
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

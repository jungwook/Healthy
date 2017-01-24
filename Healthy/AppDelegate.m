//
//  AppDelegate.m
//  Healthy
//
//  Created by 한정욱 on 2017. 1. 5..
//  Copyright © 2017년 SMARTLY CO. All rights reserved.
//

#import "AppDelegate.h"
@import Parse;
#import "History.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"Healthy";
        configuration.server = @"http://mondays.kr:1340/Healthy";
        configuration.clientKey = @"Healthy";
        configuration.localDatastoreEnabled = YES;
    }]];
    
    [History new];
    
//    PFObject *gameScore = [PFObject objectWithClassName:@"Tits"];
//    gameScore[@"score"] = @1337;
//    gameScore[@"playerName"] = @"Sean Plott";
//    gameScore[@"cheatMode"] = @NO;
//    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"OK SAVED");
//            // The object has been saved.
//            PFQuery *query = [PFQuery queryWithClassName:@"Tits"];
//            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//                NSLog(@"Found %ld Objects", objects.count);
//                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    NSLog(@"OB:%@", obj);
//                }];
//            }];
//        } else {
//            NSLog(@"NOT OK><>...");
//            NSLog(@"ERROR:%@", error.localizedDescription);
//        }
//    }];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

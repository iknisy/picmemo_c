//
//  AppDelegate.h
//  picmemo_c
//
//  Created by 陳昱宏 on 2019/5/22.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


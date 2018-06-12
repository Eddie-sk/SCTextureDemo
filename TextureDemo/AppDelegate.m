//
//  AppDelegate.m
//  TextureDemo
//
//  Created by sunkai on 2018/5/30.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "AppDelegate.h"
#import "KKPhotoViewController.h"
#import "KKAnimationViewController.h"
#import "KKKittenViewController.h"
#import "KKCollectionViewController.h"
#import "KKSocialViewController.h"
#import "KKHorizontalContentView.h"
#import "KKCustomCollectionVC.h"

#define LOCK pthread_mutex_lock(&_lock);
#define UNLOCK pthread_mutex_unlock(&_lock);

@interface AppDelegate () {
    NSThread *thread1;
    NSThread *thread2;
    NSInteger tacketSurplusCount;
    NSLock *lock;
    pthread_mutex_t _lock;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self syncSerial];
    
    //mainSync在主队列中执行。因为同步执行的特点是任务立即执行，当把mainSync中的第一个任务也放在主队列中执行时，需要等待mainSync执行完成才会立即执行。mainSync任务会卡主线程，而第一个任务一直在等待mainSync任务执行完成，就会造成互相等待，会造成线程卡死。
//    [self mainSync];
//    dispatch_async(dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL), ^{
//        [self mainSync];
//    });
    
//    [self setRootController];
    
    
    
    [self ticketOperation];
    
    
    return YES;
}

- (void)initThreadClock {
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    
    pthread_mutex_init(&_lock, &attr);
    pthread_mutexattr_destroy(&attr);
}

- (void)ticketOperation {
    [self initThreadClock];
    
    tacketSurplusCount = 10;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:@"1"];
//    operation.queuePriority = NSOperationQueuePriorityLow;
    
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:@"2"];
//    operation1.queuePriority = NSOperationQueuePriorityHigh;
    
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3) object:@"3"];
//    operation2.queuePriority = NSOperationQueuePriorityNormal;
    
//    [operation1 addDependency:operation];
    [queue addOperation:operation];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
}

- (void)addDendency {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1----%@",[NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2----%@",[NSThread currentThread]);
        }
    }];
    
    [op2 addDependency:op1];//op2添加依赖op1的完成
    
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)operationQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
//    queue.maxConcurrentOperationCount = -1;//不限制，串行、并行不限制
//    queue.maxConcurrentOperationCount = 1;//串行队列
    queue.maxConcurrentOperationCount = 2;//并行队列
//    queue.maxConcurrentOperationCount = 3;
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1----%@",[NSThread currentThread]);
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2----%@",[NSThread currentThread]);
        }
    }];
    
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3----%@",[NSThread currentThread]);
        }
    }];
    
}

- (void)saleTicketNotSafe:(NSString *)object {
    while (1) {
        //        @synchronized(self) {
        //            [lock lock];
        LOCK
        if (tacketSurplusCount > 0) {
            tacketSurplusCount -- ;
            NSLog(@"%@",[NSString stringWithFormat:@"剩余票数:%ld 窗口：%@",tacketSurplusCount, object]);
            [NSThread sleepForTimeInterval:0.2];
        }else {
            NSLog(@"车票已售罄");
            break;
        }
        //            [lock unlock];
        UNLOCK
        //        }
    }
}

- (void)saleTicketNotSafe {
    while (1) {
        //        @synchronized(self) {
        //            [lock lock];
        LOCK
        if (tacketSurplusCount > 0) {
            tacketSurplusCount -- ;
            NSLog(@"%@",[NSString stringWithFormat:@"剩余票数:%ld 窗口：%@",tacketSurplusCount, [NSThread currentThread].name]);
            [NSThread sleepForTimeInterval:0.2];
        }else {
            NSLog(@"车票已售罄");
            break;
        }
        //            [lock unlock];
        UNLOCK
        //        }
    }
}

- (void)nsthread {
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    
    pthread_mutex_init(&_lock, &attr);
    pthread_mutexattr_destroy(&attr);
    
    lock = [[NSLock alloc] init];
    
    
    tacketSurplusCount = 100;
    thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketNotSafe) object:nil];
    thread1.name = @"售票口1";
    thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketNotSafe) object:nil];
    thread2.name = @"售票口2";
    [thread1 start];
    [thread2 start];
}

- (void)task1 {
    for (int i = 0; i < 2;  i ++) {
//        [NSThread sleepForTimeInterval:2];
        NSLog(@"1----%@",[NSThread currentThread]);
    }
}

- (void)task2 {
    for (int i = 0; i < 2;  i ++) {
//        [NSThread sleepForTimeInterval:2];
        NSLog(@"2----%@",[NSThread currentThread]);
    }
}

- (void)task3 {
    for (int i = 0; i < 2;  i ++) {
//        [NSThread sleepForTimeInterval:2];
        NSLog(@"3----%@",[NSThread currentThread]);
    }
}

- (void)invocationOperation {
    NSInvocationOperation *queue = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    [queue start];

}

- (void)blockOperation {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2----%@",[NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3----%@",[NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4----%@",[NSThread currentThread]);
        }
    }];
    [op start];

}


//mainSync
- (void)mainSync {
    NSLog(@"mainSync :Start");
    
    dispatch_queue_t serialQueue = dispatch_get_main_queue();
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"mainSync :1 %@",[NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"mainSync :2 %@",[NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"mainSync :3 %@",[NSThread currentThread]);
    });
    
    
    NSLog(@"mainSync :End");
}

- (void)syncSerial {
    NSLog(@"syncSerial :Start");
    
    dispatch_queue_t serialQueue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"syncSerial :1 %@",[NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"syncSerial :2 %@",[NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"syncSerial :3 %@",[NSThread currentThread]);
    });
    
    
    NSLog(@"syncSerial :End");
}

- (void)syncConcurrent {
    NSLog(@"syncConcurrent :Start");
    
    dispatch_queue_t serialQueue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"syncConcurrent :1 %@",[NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"syncConcurrent :2 %@",[NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"syncConcurrent :3 %@",[NSThread currentThread]);
    });
    NSLog(@"syncConcurrent :End");
}


- (void)setRootController {
    
    [ASDisplayNode setShouldShowRangeDebugOverlay:YES];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor  = [UIColor whiteColor];
    ASTabBarController *tabbar = [[ASTabBarController alloc] init];
    
    KKPhotoViewController *photoVC = [[KKPhotoViewController alloc] init];
    photoVC.title = @"List";
    ASNavigationController *nav = [[ASNavigationController alloc] initWithRootViewController:photoVC];
    
    
    KKAnimationViewController *photoVC1 = [[KKAnimationViewController alloc] init];
    photoVC1.title = @"Animation";
    ASNavigationController *nav1 = [[ASNavigationController alloc] initWithRootViewController:photoVC1];
    
    KKKittenViewController *kittenVC = [[KKKittenViewController alloc] init];
    kittenVC.title = @"Kitten";
    ASNavigationController *kittenNav = [[ASNavigationController alloc] initWithRootViewController:kittenVC];
    self.window  = window;
    
    KKCollectionViewController *collection = [[KKCollectionViewController alloc] init];
    collection.title = @"collection";
    ASNavigationController *collectionNav = [[ASNavigationController alloc] initWithRootViewController:collection];
    
    KKSocialViewController *social = [[KKSocialViewController alloc] init];
    social.title = @"Social";
    ASNavigationController *socialNav = [[ASNavigationController alloc] initWithRootViewController:social];
    
    
    KKHorizontalContentView *horizontalVC = [[KKHorizontalContentView alloc] init];
    horizontalVC.title = @"horizontalVC";
    ASNavigationController *horizontalNAV = [[ASNavigationController alloc] initWithRootViewController:horizontalVC];
    
    
    KKCustomCollectionVC *customCollection = [[KKCustomCollectionVC alloc] init];
    customCollection.title = @"collection";
    ASNavigationController *customCollectionNav = [[ASNavigationController alloc] initWithRootViewController:customCollection];
    
    self.window  = window;
    tabbar.viewControllers = @[nav, nav1,kittenNav,collectionNav, socialNav,horizontalNAV,customCollectionNav];
    window.rootViewController = tabbar;
    [window makeKeyAndVisible];
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

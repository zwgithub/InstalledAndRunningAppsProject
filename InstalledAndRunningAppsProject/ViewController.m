//
//  ViewController.m
//  InstalledAndRunningAppsProject
//
//  Created by shanWu on 16/4/10.
//  Copyright © 2016年 caozhenwei. All rights reserved.
//

#import "ViewController.h"
#import "RunningAppList.h"
#include <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, retain) NSMutableArray *appsIconArr;
@property (nonatomic, retain) NSMutableArray *appsNameArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appsIconArr = [[NSMutableArray alloc]init];
    self.appsNameArr = [[NSMutableArray alloc]init];
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSMutableArray *appsInfoArr = [workspace performSelector:@selector(allApplications)];
    
    [appsInfoArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSDictionary *boundIconsDictionary = [obj performSelector:@selector(boundIconsDictionary)];
         
         NSString *iconPath = [NSString stringWithFormat:@"%@/%@.png", [[obj performSelector:@selector(resourcesDirectoryURL)] path], [[[boundIconsDictionary objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]lastObject]];
         
         
         //         [self.appsNameArr addObject:[obj performSelector:@selector(localizedName)]];
         UIImage *image = [[UIImage alloc]initWithContentsOfFile:iconPath];
         if (image)
         {
             [self.appsIconArr addObject:image];
             [self.appsNameArr addObject:[obj performSelector:@selector(localizedName)]];
         }
     }];
    
    //获取正在运行的app
    NSArray *array = [RunningAppList getRunningProcesses];
    NSLog(@"%@",array);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

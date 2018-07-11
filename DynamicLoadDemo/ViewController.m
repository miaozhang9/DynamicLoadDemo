//
//  ViewController.m
//  DynamicLoadDemo
//
//  Created by Miaoz on 2018/6/29.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <SSZipArchive/SSZipArchive.h>
static void *libHandle = NULL;
@interface ViewController ()
@property (weak, nonatomic) NSBundle *bundle;
@property (copy, nonatomic) NSString *zipPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn5.layer.borderColor = [UIColor blueColor].CGColor;
    btn5.layer.borderWidth = 1.0;
    btn5.frame = CGRectMake(0, 0, 300, 50);
    btn5.center = CGPointMake(self.view.center.x, self.view.center.y - 150 -2* 70);
    [btn5 setTitle:@"1.zip到沙盒" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(click5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn6.layer.borderColor = [UIColor blueColor].CGColor;
    btn6.layer.borderWidth = 1.0;
    btn6.frame = CGRectMake(0, 0, 300, 50);
    btn6.center = CGPointMake(self.view.center.x, self.view.center.y - 150 - 70);
    [btn6 setTitle:@"2.unzip到沙盒" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(click6) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.frame = CGRectMake(0, 0, 300, 50);
    btn.center = CGPointMake(self.view.center.x, self.view.center.y - 150);
    [btn setTitle:@"3.NSBundle调用" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.layer.borderColor = [UIColor blueColor].CGColor;
    btn1.layer.borderWidth = 1.0;
    btn1.frame = CGRectMake(0, 0, 300, 50);
    btn1.center = CGPointMake(self.view.center.x, self.view.center.y - 150+70);
    [btn1 setTitle:@"3.dlopen调用" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.layer.borderColor = [UIColor blueColor].CGColor;
    btn2.layer.borderWidth = 1.0;
    btn2.frame = CGRectMake(0, 0, 300, 50);
    btn2.center = CGPointMake(self.view.center.x, self.view.center.y - 150+2*70);
    [btn2 setTitle:@"4.调用动态FrameWork加载方法" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.layer.borderColor = [UIColor blueColor].CGColor;
    btn3.layer.borderWidth = 1.0;
    btn3.frame = CGRectMake(0, 0, 300, 50);
    btn3.center = CGPointMake(self.view.center.x, self.view.center.y - 150+3*70);
    [btn3 setTitle:@"卸载Bundle" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.layer.borderColor = [UIColor blueColor].CGColor;
    btn4.layer.borderWidth = 1.0;
    btn4.frame = CGRectMake(0, 0, 300, 50);
    btn4.center = CGPointMake(self.view.center.x, self.view.center.y - 150+4*70);
    [btn4 setTitle:@"卸载dlopen" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(click4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}
-(void)click5 {
    NSString *sampleDataPath = [[NSBundle mainBundle].bundleURL
                                URLByAppendingPathComponent:@"Sample Data"
                                isDirectory:YES].path;
    _zipPath = [self tempZipPath];
   
    
    BOOL success = [SSZipArchive createZipFileAtPath:_zipPath
                             withContentsOfDirectory:sampleDataPath
                                 keepParentDirectory:NO
                                    compressionLevel:-1
                                            password:nil
                                                 AES:YES
                                     progressHandler:nil];
    NSString *str = nil;
    if (success) {
        str = @"Success zip";
        NSLog(@"Success zip");
      
    } else {
        str = @"No success zip";
        NSLog(@"No success zip");
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

-(void)click6 {
    if (!_zipPath) {
        return;
    }
    NSString *unzipPath = [self tempUnzipPath];
    if (!unzipPath) {
        return;
    }

    BOOL success = [SSZipArchive unzipFileAtPath:_zipPath
                                   toDestination:unzipPath
                              preserveAttributes:YES
                                       overwrite:YES
                                  nestedZipLevel:0
                                        password:nil
                                           error:nil
                                        delegate:nil
                                 progressHandler:nil
                               completionHandler:nil];
    NSString *str = nil;
    if (success) {
        str = @"Success unzip";
        NSLog(@"Success unzip");
    } else {
        str = @"No success unzip";
        NSLog(@"No success unzip");
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    NSError *error = nil;
    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                          contentsOfDirectoryAtPath:unzipPath
                                          error:&error] mutableCopy];
    if (error) {
        return;
    }
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
    }];

}

#pragma mark - Private
- (NSString *)tempZipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@.zip",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      @"framework"];// [NSUUID UUID].UUIDString
    return path;
}

- (NSString *)tempUnzipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      @"framework"];//[NSUUID UUID].UUIDString
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}

-(void)click {
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *frameworkPath = [NSString stringWithFormat:@"%@/QHLoanlib.framework",[self tempUnzipPath]];
//    NSString *frameworkPath = [NSString stringWithFormat:@"%@/Documents/QHLoanlib.framework",NSHomeDirectory()];
    
    NSError *err = nil;
    NSBundle *bundle = [NSBundle bundleWithPath:frameworkPath];
    NSString *str = @"加载动态库失败!";
    if ([bundle loadAndReturnError:&err]) {
        NSLog(@"bundle load framework success.");
        str = @"加载动态库成功!";
        self.bundle = bundle;
    } else {
        NSLog(@"bundle load framework err:%@",err);
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

-(void)click1 {
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载(注意需要加上PiaoJinDylib)
    NSString *frameworkPath = [NSString stringWithFormat:@"%@/QHLoanlib.framework/QHLoanlib",[self tempUnzipPath]];
    libHandle = NULL;
    libHandle = dlopen([frameworkPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    NSString *str = @"加载动态库失败!";
    
    if (libHandle == NULL) {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
    } else {
        NSLog(@"dlopen load framework success.");
        str = @"加载动态库成功!";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)click2 {
    Class piaoJinClass = NSClassFromString(@"QHLoanDoor");
    if(piaoJinClass){
        //        //事先要知道有什么方法在这个FrameWork中
        ;
        id object = [[piaoJinClass alloc] init];
        //        //由于没有引入相关头文件故通过performSelector调用
        
        id object2 = [piaoJinClass performSelector:@selector(share)];
        //        setStartPageUrl
        
        
        
        unsigned int count = 0;
        //1. 获取某个类的成员变量列表
        Ivar *ivarList = class_copyIvarList([piaoJinClass class], &count);
        //    2.遍历成员变量列表
        for (int i = 0; i < count; i++) {
            const char *ivarName = ivar_getName(ivarList[i]);
            NSString *ivarNameStr = [NSString stringWithUTF8String:ivarName];
            NSLog(@"------%@",ivarNameStr);
            //    3.找到要改变的变量
            //            if ([ivarNameStr isEqualToString:@"_startPage"]) {
            //                //    4.修改变量的值
            //                object_setIvar(object2, ivarList[i], @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/ajd/index.html?t=list");
            //                //    根据需求，中断循环
            ////                break;
            //            }
            if ([ivarNameStr isEqualToString:@"_barColor"]) {
                object_setIvar(object2, ivarList[i], @"#FFC125");
            }
            
            if ([ivarNameStr isEqualToString:@"_basicDelegate"]) {
                object_setIvar(object2, ivarList[i],self);
            }
            
            
        }
        free(ivarList);
        
        [object2 performSelector:@selector(testStart)];
        
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"调用方法失败!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
}

-(void)click3 {
    if([self.bundle unload]){
        NSLog(@"释放成功!");
    }else{
        NSLog(@"释放失败!");
    }
}

-(void)click4 {
    int result = dlclose(libHandle);
    //为0表示释放成功
    if(result == 0){
        NSLog(@"释放成功!");
    }else{
        NSLog(@"释放失败!");
    }
}


//跳转new的h5Page
-(BOOL)openNewPageWithUrl:(NSString *)url{
    
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  DJDebugCustomSettingViewController.m
//  Pods
//
//  Created by iBlock on 16/7/29.
//
//

#import "DJDebugCustomSettingViewController.h"
#import "DJDebugConfig.h"

extern DJDebugConfig *DJDebugConfigObj;

@interface DJDebugCustomSettingViewController ()<IASKSettingsDelegate>

@end

@implementation DJDebugCustomSettingViewController

- (id)initWithFile:(NSString*)file specifier:(IASKSpecifier*)specifier{
    self = [self init];
    if (self) {
        self.neverShowPrivacySettings = NO;
        if (DJDebugConfigObj.configBundleFileName) {
            self.file = DJDebugConfigObj.configBundleFileName;
        } else {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"项目中还没配有自定义设置项哦，请查看Demo工程中的配置例子。";
            label.font = [UIFont systemFontOfSize:26];
            label.numberOfLines = 0;
            label.frame = CGRectMake(20, 20, self.view.frame.size.width-40, 200);
            [self.view addSubview:label];
        }
    }
    return self;
}

- (NSString *)bundleName {
    return [NSString stringWithFormat:@"%@.bundle",DJDebugConfigObj.configBundleFileName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

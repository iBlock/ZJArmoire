//
//  DJDebugAPIAlarmInfoPage.h
//  Pods
//
//  Created by iBlock on 16/9/1.
//
//  API错误报警信息

#import <UIKit/UIKit.h>
#import "DJDebugURLProtocol.h"

@interface DJDebugAPIAlarmInfoPage : UIViewController

@property (nonatomic, strong) UITableView *apiInfoTableVeiw;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *switchInfoLabel;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSArray *errorApiAllKeys;
@property (nonatomic, strong) DJDebugProtocolModel *debugProtocol;

@end

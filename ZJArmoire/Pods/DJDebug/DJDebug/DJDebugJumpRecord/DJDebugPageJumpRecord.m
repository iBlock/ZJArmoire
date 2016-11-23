//
//  DJDebugPageJumpRecord.m
//  Pods
//
//  Created by iBlock on 16/9/7.
//
//

#import "DJDebugPageJumpRecord.h"
#import "IASKSpecifier.h"

NSString *const kDJDebugPageJumpRecord = @"kDJDebugPageJumpRecord";
NSString *const kDJDebugPageJumpMark = @"Debug跳页";
NSString *const kDJDebugPageTitle = @"kDJDebugPageTitle";
NSString *const kDJDebugJumpRecordInfoSwitchState = @"kDJDebugJumpRecordInfoSwitchState";

extern NSMutableDictionary *DJDebugJumpPageInfoDic;

@interface DJDebugPageJumpRecord ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *pageInfoTableView;
@property (nonatomic, strong) NSArray *pageRecordAllKeys;
@property (nonatomic, strong) NSDictionary *pageRecordInfos;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation DJDebugPageJumpRecord

- (instancetype)initWithFile:(NSString*)file key:(IASKSpecifier*)specifier
{
    self = [super init];
    if (self) {
        self.title = specifier.title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageInfoTableView];
    [self.pageInfoTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL switchState = [[[NSUserDefaults standardUserDefaults] objectForKey:kDJDebugJumpRecordInfoSwitchState] boolValue];
    [self.switchView setOn:switchState animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.pageRecordAllKeys count] == 0) {
        NSString *title = @"暂时还没有页面跳转记录记录。";
        cell.textLabel.text = title;
        cell.detailTextLabel.text = @"";
    } else {
        NSString *pageKey = self.pageRecordAllKeys[indexPath.row];
        NSDictionary *parameters = self.pageRecordInfos[pageKey];
        cell.textLabel.text = parameters[kDJDebugPageTitle];
        cell.detailTextLabel.text = pageKey;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.pageRecordAllKeys.count <= 0) {
        return ;
    }
    NSString *pageKey = self.pageRecordAllKeys[indexPath.row];
    NSDictionary *parameters = self.pageRecordInfos[pageKey];
    NSArray *parameterAllKeys = [parameters allKeys];
    Class class = NSClassFromString(pageKey);
    UIViewController *jumpPage = [[class alloc] init];
    if ([jumpPage respondsToSelector:@selector(DJDebugViewController)]) {
        jumpPage = [jumpPage performSelector:@selector(DJDebugViewController)];
    }
    for (NSString *key in parameterAllKeys) {
        id value = parameters[key];
        NSString *firstWord = [[key substringToIndex:1] uppercaseString];
        NSString *setMethodStr = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstWord];
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@:",setMethodStr]);
        if ([jumpPage respondsToSelector:sel]) {
            [jumpPage performSelector:sel withObject:value];
        }
    }
    jumpPage.title = kDJDebugPageJumpMark;
    [self.navigationController pushViewController:jumpPage animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pageRecordAllKeys.count == 0 ? 1 : self.pageRecordAllKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Event and Respone

- (void)switchValueChange:(UISwitch *)switchView {
    [[NSUserDefaults standardUserDefaults] setValue:@(switchView.on) forKey:kDJDebugJumpRecordInfoSwitchState];
}

#pragma mark - Setter and Getter

- (UITableView *)pageInfoTableView {
    if (!_pageInfoTableView) {
        _pageInfoTableView = [[UITableView alloc] init];
        _pageInfoTableView.frame = self.view.bounds;
        _pageInfoTableView.delegate = self;
        _pageInfoTableView.dataSource = self;
        _pageInfoTableView.sectionHeaderHeight = 90;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
        [_pageInfoTableView setTableFooterView:headView];
    }
    return _pageInfoTableView;
}

- (NSArray *)pageRecordAllKeys {
    if (!_pageRecordAllKeys) {
        _pageRecordAllKeys = [self.pageRecordInfos allKeys];
    }
    return _pageRecordAllKeys;
}

- (NSDictionary *)pageRecordInfos {
    if (!_pageRecordInfos) {
        NSMutableDictionary *recordInfo = @{}.mutableCopy;
        _pageRecordInfos = [NSDictionary dictionaryWithDictionary:DJDebugJumpPageInfoDic];
    }
    return _pageRecordInfos;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        [_tableHeaderView addSubview:self.switchView];
        
        UILabel *warningLabel = [[UILabel alloc] init];
        warningLabel.text = @"每次变更需要重启APP";
        warningLabel.frame = CGRectMake(CGRectGetMaxY(self.switchView.frame)+25, 15, CGRectGetWidth(self.view.frame)-(CGRectGetMaxY(self.switchView.frame)+25), 20);
        [_tableHeaderView addSubview:warningLabel];
        
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.font = [UIFont systemFontOfSize:16];
        noticeLabel.numberOfLines = 0;
        noticeLabel.textColor = [UIColor brownColor];
        noticeLabel.text = @"下面列出了所有打开过的页面，从列表中可快速进入到之前打开过的页面。";
        noticeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.switchView.frame)+5, CGRectGetWidth(self.view.frame)-30, 40);
        [_tableHeaderView addSubview:noticeLabel];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.frame = CGRectMake(15, 89.5, CGRectGetWidth(self.view.frame)-15, 0.5);
        [_tableHeaderView addSubview:lineView];
    }
    return _tableHeaderView;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.frame = CGRectMake(10, 10, 60, 20);
        [_switchView addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

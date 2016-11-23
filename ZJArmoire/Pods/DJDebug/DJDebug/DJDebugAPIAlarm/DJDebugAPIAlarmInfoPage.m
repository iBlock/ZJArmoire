//
//  DJDebugAPIAlarmInfoPage.m
//  Pods
//
//  Created by iBlock on 16/9/1.
//
//

#import "DJDebugAPIAlarmInfoPage.h"
#import "DJDebugURLProtocol.h"
#import "IASKSpecifier.h"
#import "DJDebugApiDetailPage.h"

NSString *const kDJDebugAPISwitchState = @"kDJDebugAPISwitchState";

@interface DJDebugAPIAlarmInfoPage ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *apiInfoTableVeiw;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *switchInfoLabel;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) DJDebugProtocolModel *debugProtocol;
@property (nonatomic, strong) NSArray *errorApiAllKeys;

@end

@implementation DJDebugAPIAlarmInfoPage

#pragma mark - Life Cycle

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
    [self.view addSubview:self.apiInfoTableVeiw];
    [self.apiInfoTableVeiw reloadData];
    UIBarButtonItem *rightBarItem =
    [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(onClickedCleanbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)viewWillAppear:(BOOL)animated {
    BOOL switchState = [[[NSUserDefaults standardUserDefaults] objectForKey:kDJDebugAPISwitchState] boolValue];
    [self.switchView setOn:switchState animated:YES];
    [self switchValueChange:self.switchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tableHeaderView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.debugProtocol.errorApiList count] == 0) {
        NSString *title = @"暂时还没有错误的API请求记录。";
        cell.textLabel.text = title;
        cell.detailTextLabel.text = @"";
    } else {
        NSString *apiKey = self.errorApiAllKeys[indexPath.row];
        NSDictionary *apiInfo = [self.debugProtocol.errorApiList[apiKey] firstObject];
        cell.textLabel.text = apiInfo[@"path"];
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",
                                     [self.debugProtocol.errorApiList[apiKey] count]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.errorApiAllKeys.count > 0) {
        NSString *apiKey = self.errorApiAllKeys[indexPath.row];
        DJDebugApiDetailPage *apiDetailPage = [[DJDebugApiDetailPage alloc] init];
        apiDetailPage.apiErrorList = self.debugProtocol.errorApiList[apiKey];
        [self.navigationController pushViewController:apiDetailPage animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *apiKey = self.errorApiAllKeys[indexPath.row];
        [self.debugProtocol.errorApiList removeObjectForKey:apiKey];
        [self.debugProtocol syncUserdefault];
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.errorApiAllKeys.count == 0 ? 1 : self.errorApiAllKeys.count;
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
    [[NSUserDefaults standardUserDefaults] setValue:@(switchView.on) forKey:kDJDebugAPISwitchState];
    [DJDebugURLProtocol updateURLProtocol];
}

- (void)onClickedCleanbtn {
    [self.debugProtocol.errorApiList removeAllObjects];
    [self.debugProtocol syncUserdefault];
    [self.apiInfoTableVeiw reloadData];
}

#pragma mark - Setter and Getter

- (UITableView *)apiInfoTableVeiw {
    if (!_apiInfoTableVeiw) {
        _apiInfoTableVeiw = [[UITableView alloc] init];
        _apiInfoTableVeiw.frame = self.view.bounds;
        _apiInfoTableVeiw.delegate = self;
        _apiInfoTableVeiw.dataSource = self;
        _apiInfoTableVeiw.sectionHeaderHeight = 65;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
        [_apiInfoTableVeiw setTableFooterView:headView];
    }
    return _apiInfoTableVeiw;
}

- (UILabel *)switchInfoLabel {
    if (!_switchInfoLabel) {
        _switchInfoLabel = [[UILabel alloc] init];
        _switchInfoLabel.numberOfLines = 0;
        _switchInfoLabel.font = [UIFont systemFontOfSize:16];
        _switchInfoLabel.frame = CGRectMake(CGRectGetMaxX(self.switchView.frame)+5, 5, CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.switchView.frame)-20, 44);
        _switchInfoLabel.text = @"开启API错误报警后，所有失败的请求都会在下面列表中显示。";
    }
    return _switchInfoLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.frame = CGRectMake(10, 10, 100, 20);
        [_switchView addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        [_tableHeaderView addSubview:self.switchView];
        [_tableHeaderView addSubview:self.switchInfoLabel];
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.font = [UIFont systemFontOfSize:12];
        noticeLabel.text = @"注意：每次开关变更后需要重新打开APP才会生效";
        noticeLabel.textColor = [UIColor redColor];
        noticeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.switchView.frame)+5, CGRectGetWidth(self.view.frame)-15, 15);
        [_tableHeaderView addSubview:noticeLabel];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.frame = CGRectMake(15, CGRectGetMaxY(noticeLabel.frame)+5, CGRectGetWidth(self.view.frame)-15, 0.5);
        [_tableHeaderView addSubview:lineView];
    }
    return _tableHeaderView;
}

- (DJDebugProtocolModel *)debugProtocol {
    if (!_debugProtocol) {
        _debugProtocol = [DJDebugProtocolModel shareInstance];
    }
    return _debugProtocol;
}

- (NSArray *)errorApiAllKeys {
    return self.debugProtocol.errorApiList.allKeys;
}

@end

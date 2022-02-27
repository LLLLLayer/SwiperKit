//
//  SWPEmailTableViewController.m
//  SwiperKit_Example
//
//  Created by yangjie.layer on 2022/2/26.
//  Copyright © 2022 LLLLLayer. All rights reserved.
//

#import "SWPSWPEmailTableViewCell.h"
#import "SWPEmailTableViewController.h"
#import "SWPEmailViewControllerViewModel.h"
#import "SWPEmailCollectionViewController.h"

#import <SwiperKit/SWPSwipeAction.h>
#import <SwiperKit/SWPSwipeOptions.h>
#import <SwiperKit/SWPSwipeTableViewCell.h>
#import <SwiperKit/SWPSwipeTableViewCellDelegate.h>

@interface SWPEmailTableViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
SWPSwipeTableViewCellDelegate
>

@property (nonatomic, strong) SWPEmailViewControllerViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SWPEmailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setupUI];
}

#pragma mark - Methond

- (void)__setupUI
{
    // NavigationBar
    self.title = @"Email - TableView";
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(__handleTapMoreButton:)];
    self.navigationItem.rightBarButtonItem = moreButton;
    
    
    UIBarButtonItem *otherPageButton = [[UIBarButtonItem alloc] initWithTitle:@"TransferToCollectionView"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(__handleTapotherPageButton:)];
    self.navigationItem.leftBarButtonItem = otherPageButton;
    
    // Others
    [self.view addSubview:self.tableView];
}

#pragma mark - Action
- (void)__handleTapMoreButton:(UIBarButtonItem *)buttom
{
    [self.viewModel showMore];
}

- (void)__handleTapotherPageButton:(UIBarButtonItem *)buttom
{
    [self.navigationController pushViewController:[[SWPEmailCollectionViewController alloc] init] animated:YES];
}

#pragma mark - Getter

- (SWPEmailViewControllerViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[SWPEmailViewControllerViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        [_tableView registerClass:SWPSWPEmailTableViewCell.class forCellReuseIdentifier:SWPSWPEmailTableViewCell.identifier];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.sections[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWPSWPEmailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SWPSWPEmailTableViewCell.identifier];
    cell.swipeTableViewCelldelegate = self;
    [cell configWithEmailModel:self.viewModel.sections[indexPath.section][indexPath.row]];
    return cell;
}

#pragma mark - SWPSwipeTableViewViewCellDelegate

- (NSArray<SWPSwipeAction *> *)tableView:(UITableView *)tableView editActionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation
{
    SWPSwipeAction *r1 = [[SWPSwipeAction alloc] init];
    r1.title = @"More";
    r1.backgroundColor = UIColor.grayColor;
    
    SWPSwipeAction *r2 = [[SWPSwipeAction alloc] init];
    r2.title = @"Flag";
    r2.backgroundColor = UIColor.orangeColor;
    
    SWPSwipeAction *r3 = [[SWPSwipeAction alloc] init];
    r3.title = @"Trash";
    r3.backgroundColor = UIColor.redColor;
    r3.handler = ^(SWPSwipeAction * _Nonnull ation, NSIndexPath * _Nonnull indexPath) {
        NSMutableArray *tempSection = self.viewModel.sections[indexPath.section].mutableCopy;
        [tempSection removeObjectAtIndex:indexPath.item];
        NSMutableArray *tempSections = self.viewModel.sections.mutableCopy;
        tempSections[indexPath.section] = tempSection;
        self.viewModel.sections = tempSections.copy;
        [self.tableView reloadData];
    };
    
    SWPSwipeAction *l1 = [[SWPSwipeAction alloc] init];
    l1.title = @"Read";
    l1.backgroundColor = UIColor.blueColor;
    
    SWPSwipeAction *l2 = [[SWPSwipeAction alloc] init];
    l2.title = @"Forward";
    l2.backgroundColor = UIColor.greenColor;
    
    return orientation == SWPSwipeActionsOrientationLeft ? @[l1, l2] : @[r1, r2, r3];
}

- (SWPSwipeOptions *)tableView:(UITableView *)tableView editActionsOptionsForItemAtIndexPath:(nonnull NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation
{
    return self.viewModel.options;
}

@end

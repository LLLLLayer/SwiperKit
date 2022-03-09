//
//  SWPEmailCollectionViewController.m
//  SwiperKit
//
//  Created by LLLLLayer on 02/09/2022.
//  Copyright (c) 2022 LLLLLayer. All rights reserved.
//

#import "SWPEmailCollectionViewCell.h"
#import "SWPEmailViewControllerViewModel.h"
#import "SWPEmailCollectionViewController.h"
#import "SWPEmailTableViewController.h"
#import "SWPEmailModel.h"

#import <SwiperKit/SWPSwipeAction.h>
#import <SwiperKit/SWPSwipeOptions.h>
#import <SwiperKit/SWPSwipeCollectionViewCell.h>
#import <SwiperKit/SWPSwipeCollectionViewCellDelegate.h>

@interface SWPEmailCollectionViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
SWPSwipeCollectionViewCellDelegate
>

@property (nonatomic, strong) SWPEmailViewControllerViewModel *viewModel;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SWPEmailCollectionViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self __setupUI];
}

#pragma mark - Methond

- (void)__setupUI
{
    // NavigationBar
    self.title = @"Email - CollectionView";
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(__handleTapMoreButton:)];
    self.navigationItem.rightBarButtonItem = moreButton;
    
    UIBarButtonItem *otherPageButton = [[UIBarButtonItem alloc] initWithTitle:@"TransferToTableView"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(__handleTapotherPageButton:)];
    self.navigationItem.leftBarButtonItem = otherPageButton;
    
    // Others
    [self.view addSubview:self.collectionView];
}

#pragma mark - Action

- (void)__handleTapMoreButton:(UIBarButtonItem *)buttom
{
    [self.viewModel showMore];
}

- (void)__handleTapotherPageButton:(UIBarButtonItem *)buttom
{
    [self.navigationController pushViewController:[[SWPEmailTableViewController alloc] init] animated:YES];
}

#pragma mark - Getter

- (SWPEmailViewControllerViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[SWPEmailViewControllerViewModel alloc] init];
    }
    return _viewModel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0;
        layout.estimatedItemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 200);
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.systemBackgroundColor;
        _collectionView.autoresizesSubviews = YES;
        [_collectionView registerClass:[SWPEmailCollectionViewCell class] forCellWithReuseIdentifier:[SWPEmailCollectionViewCell identifier]];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.sections[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWPEmailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SWPEmailCollectionViewCell identifier] forIndexPath:indexPath];
    [cell configWithEmailModel:self.viewModel.sections[indexPath.section][indexPath.row]];
    cell.swipeCollectionViewCelldelegate = self;
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    return cell;
}

#pragma mark - SWPSwipeCollectionViewCellDelegate

- (NSArray<SWPSwipeAction *> *)collectionView:(UICollectionView *)collectionView editActionsForItemAtIndexPath:(NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation
{
    SWPSwipeAction *r1 = [[SWPSwipeAction alloc] init];
    r1.title = @"More";
    r1.backgroundColor = [UIColor grayColor];
    r1.textColor = [UIColor whiteColor];
    r1.highlightedTextColor = [UIColor blackColor];
    r1.image = [[UIImage systemImageNamed:@"ellipsis.circle"] imageWithTintColor:[UIColor whiteColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    r1.highlightedImage = [[UIImage systemImageNamed:@"ellipsis.circle"] imageWithTintColor:[UIColor blackColor] renderingMode:UIImageRenderingModeAlwaysOriginal];

    SWPSwipeAction *r2 = [[SWPSwipeAction alloc] init];
    r2.title = @"Flag";
    r2.backgroundColor = UIColor.orangeColor;
    r2.textColor = [UIColor whiteColor];
    r2.highlightedTextColor = [UIColor blackColor];
    r2.image = [[UIImage systemImageNamed:@"flag.circle"] imageWithTintColor:[UIColor whiteColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    r2.highlightedImage = [[UIImage systemImageNamed:@"flag.circle"] imageWithTintColor:[UIColor blackColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SWPSwipeAction *r3 = [[SWPSwipeAction alloc] init];
    r3.title = @"Trash";
    r3.backgroundColor = UIColor.redColor;
    r3.textColor = [UIColor whiteColor];
    r3.highlightedTextColor = [UIColor blackColor];
    r3.image = [[UIImage systemImageNamed:@"trash.circle"] imageWithTintColor:[UIColor whiteColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    r3.highlightedImage = [[UIImage systemImageNamed:@"trash.circle"] imageWithTintColor:[UIColor blackColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    r3.handler = ^(SWPSwipeAction * _Nonnull ation, NSIndexPath * _Nonnull indexPath) {
        NSMutableArray *tempSection = self.viewModel.sections[indexPath.section].mutableCopy;
        [tempSection removeObjectAtIndex:indexPath.item];
        NSMutableArray *tempSections = self.viewModel.sections.mutableCopy;
        tempSections[indexPath.section] = tempSection;
        self.viewModel.sections = tempSections.copy;
    };
    
    SWPSwipeAction *l1 = [[SWPSwipeAction alloc] init];
    l1.title = @"Read";
    l1.backgroundColor = UIColor.blueColor;
    l1.textColor = [UIColor whiteColor];
    l1.highlightedTextColor = [UIColor blackColor];
    l1.image = [[UIImage systemImageNamed:@"bookmark.circle"] imageWithTintColor:[UIColor whiteColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    l1.highlightedImage = [[UIImage systemImageNamed:@"bookmark.circle"] imageWithTintColor:[UIColor blackColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    l1.handler = ^(SWPSwipeAction * _Nonnull ation, NSIndexPath * _Nonnull indexPath) {
        SWPEmailModel *model = self.viewModel.sections[indexPath.section][indexPath.item];
        [model updateReadStatus];
    };
    
    return orientation == SWPSwipeActionsOrientationLeft ? @[l1] : @[r1, r2, r3];
}

- (SWPSwipeOptions *)collectionView:(UICollectionView *)collectionView editActionsOptionsForItemAtIndexPath:(nonnull NSIndexPath *)indexPath forOrientation:(SWPSwipeActionsOrientation)orientation
{
    return orientation == SWPSwipeActionsOrientationRight ? self.viewModel.options : self.viewModel.leftOptions;
}

@end

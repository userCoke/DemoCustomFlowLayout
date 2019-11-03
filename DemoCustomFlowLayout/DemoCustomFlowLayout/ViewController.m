//
//  ViewController.m
//  DemoCustomFlowLayout
//
//  Created by hj on 2019/11/4.
//  Copyright © 2019 JKH. All rights reserved.
//

#import "ViewController.h"
#import "JKHMyLayout.h"

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collect;
@property (nonatomic, assign) NSInteger itemCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemCount = 11;
    
    JKHMyLayout *layout = [[JKHMyLayout alloc] init];
    layout.palaces = 4;
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.collect = collect;
    collect.pagingEnabled = YES;
    collect.delegate = self;
    collect.dataSource = self;
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];

    [self.view addSubview:collect];
    [self contentInsetHeaderView];
}


- (void)contentInsetHeaderView {
    CGFloat header_w = [UIScreen mainScreen].bounds.size.width;
    self.collect.contentInset = UIEdgeInsetsMake(0, header_w, 0, 0);
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(-header_w, 0, header_w, [UIScreen mainScreen].bounds.size.height)];
    headerView.text = @"我是表头";
    headerView.textColor = [UIColor redColor];
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.backgroundColor = [UIColor blueColor];
    [self.collect addSubview:headerView];
    [self.collect setContentOffset:CGPointMake(-header_w, -0)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lab.center = cell.contentView.center;
    lab.textColor = [UIColor redColor];
    lab.text = [NSString stringWithFormat:@"row=%ld", indexPath.row];
    [cell.contentView addSubview:lab];
    return cell;
}

@end

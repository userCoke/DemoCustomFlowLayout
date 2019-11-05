//
//  ResultViewController.m
//  DemoCustomFlowLayout
//
//  Created by hj on 2019/11/4.
//  Copyright © 2019 JKH. All rights reserved.
//

#import "ResultViewController.h"
#import "JKHMyLayout.h"
#import "Masonry.h"

static NSString *cellID = @"cellID";

@interface ResultViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collect;
@property (nonatomic, strong) JKHMyLayout *layout;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    JKHMyLayout *layout = [JKHMyLayout layoutWithRowWithRow:self.row column:self.column scrollDirection:self.direction];
    self.layout = layout;
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    self.collect = collect;
    collect.pagingEnabled = YES;
    collect.delegate = self;
    collect.dataSource = self;
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];

    [self.view addSubview:collect];
    [self contentInsetHeaderView];
}


- (void)contentInsetHeaderView {
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGr:)];
    tapGr.numberOfTapsRequired = 2;
    
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        // 横向
        CGFloat header_w = [UIScreen mainScreen].bounds.size.width;
        self.collect.contentInset = UIEdgeInsetsMake(0, header_w, 0, 0);
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(-header_w, 0, header_w, [UIScreen mainScreen].bounds.size.height)];
        headerView.text = @"双击表头返回首页~";
        headerView.textColor = [UIColor redColor];
        headerView.textAlignment = NSTextAlignmentCenter;
        headerView.backgroundColor = [UIColor blueColor];
        headerView.userInteractionEnabled = YES;
        [headerView addGestureRecognizer:tapGr];
        [self.collect addSubview:headerView];
        [self.collect setContentOffset:CGPointMake(-header_w, -0)];
    } else {
        // 纵向
        CGFloat header_h = [UIScreen mainScreen].bounds.size.height;
        self.collect.contentInset = UIEdgeInsetsMake(header_h, 0, 0, 0);
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, -header_h, [UIScreen mainScreen].bounds.size.width, header_h)];
        headerView.text = @"双击表头返回首页~";
        headerView.textColor = [UIColor redColor];
        headerView.textAlignment = NSTextAlignmentCenter;
        headerView.backgroundColor = [UIColor blueColor];
        [headerView addGestureRecognizer:tapGr];
        [self.collect addSubview:headerView];
        [self.collect setContentOffset:CGPointMake(-0, -header_h)];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *lab = [[UILabel alloc] init];
    [cell.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    lab.textColor = [UIColor redColor];
    lab.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    lab.textAlignment = NSTextAlignmentCenter;

    return cell;
}

- (void)tapGr:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end

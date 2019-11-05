//
//  HomeViewController.m
//  DemoCustomFlowLayout
//
//  Created by hj on 2019/11/5.
//  Copyright © 2019 JKH. All rights reserved.
//

#import "HomeViewController.h"
#import "ResultViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *rowSlider;
@property (weak, nonatomic) IBOutlet UISlider *columnSlider;
@property (weak, nonatomic) IBOutlet UISlider *dataCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *rowLab;
@property (weak, nonatomic) IBOutlet UILabel *columnLab;
@property (weak, nonatomic) IBOutlet UILabel *dataCountLab;

@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    self.rowSlider.value = 2;
    self.columnSlider.value = 2;
    self.dataCountSlider.value = 10;
    
    self.rowLab.text = [NSString stringWithFormat:@"%.0lf行", self.rowSlider.value];
    self.columnLab.text = [NSString stringWithFormat:@"%.0lf列", self.columnSlider.value];
    self.dataCountLab.text = [NSString stringWithFormat:@"%.0lf个数据", self.dataCountSlider.value];
    [self updateBtnTitle];
}
- (IBAction)rowChanged:(UISlider *)sender {
    self.rowLab.text = [NSString stringWithFormat:@"%.0lf行", self.rowSlider.value];
    [self updateBtnTitle];
}

- (IBAction)columnChanged:(UISlider *)sender {
    self.columnLab.text = [NSString stringWithFormat:@"%.0lf列", self.columnSlider.value];
    [self updateBtnTitle];
}
- (IBAction)dataCountChanged:(UISlider *)sender {
    self.dataCountLab.text = [NSString stringWithFormat:@"%.0lf个数据", self.dataCountSlider.value];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    NSString *row = [NSString stringWithFormat:@"%.0lf", self.rowSlider.value];
    NSString *column = [NSString stringWithFormat:@"%.0lf", self.columnSlider.value];
    NSString *dataCount = [NSString stringWithFormat:@"%.0lf", self.dataCountSlider.value];
    NSLog(@"\n row = %ld col = %ld data = %ld", row.integerValue, column.integerValue, dataCount.integerValue);
    ResultViewController *vc = [[ResultViewController alloc] init];
    vc.row = row.integerValue;
    vc.column = column.integerValue;
    vc.itemCount = dataCount.integerValue;
    vc.direction = self.segmentedControl.selectedSegmentIndex == 0 ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)updateBtnTitle {
    NSString *row = [NSString stringWithFormat:@"%.0lf", self.rowSlider.value];
    NSString *column = [NSString stringWithFormat:@"%.0lf", self.columnSlider.value];
    NSString *title = [NSString stringWithFormat:@"%ld宫格 >>>GO", row.integerValue*column.integerValue];
    [self.nextBtn setTitle:title forState:UIControlStateNormal];
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

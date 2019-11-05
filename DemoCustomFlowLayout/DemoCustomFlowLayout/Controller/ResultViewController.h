//
//  ResultViewController.h
//  DemoCustomFlowLayout
//
//  Created by hj on 2019/11/4.
//  Copyright © 2019 JKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) UICollectionViewScrollDirection direction;

@end


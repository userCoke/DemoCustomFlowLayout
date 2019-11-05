//
//  JKHMyLayout.h
//  DemoPhotoCheck
//
//  Created by hj on 2019/10/31.
//  Copyright © 2019 PPX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKHMyLayout : UICollectionViewFlowLayout
// 提供初始化方法
- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

+ (instancetype)layoutWithRowWithRow:(NSInteger)row column:(NSInteger)column scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

@end

NS_ASSUME_NONNULL_END

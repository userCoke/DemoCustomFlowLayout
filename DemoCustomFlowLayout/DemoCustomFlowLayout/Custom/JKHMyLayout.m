//
//  JKHMyLayout.m
//  DemoPhotoCheck
//
//  Created by hj on 2019/10/31.
//  Copyright © 2019 PPX. All rights reserved.
//

#import "JKHMyLayout.h"

@interface JKHMyLayout ()
/** 所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation JKHMyLayout
#pragma mark - Lazy
- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - Life
// TODO:1.布局前的准备会调用这个方法
- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.palaces == 0) {
        self.palaces = 4;
    }
    
    // 根据宫格规则布局
    [self prepareLayoutWithPalaces:self.palaces];
}

// TODO:2.返回collectionView的内容大小
- (CGSize)collectionViewContentSize {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger page = count/self.palaces;
    if (count%self.palaces>0) {
        page++;
    }
    CGSize size = CGSizeMake(self.collectionView.frame.size.width*page, self.collectionView.frame.size.height);
    return size;
}

// TODO:3.返回布局数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attrsArray;
}


#pragma mark - Custom
// 根据宫格规则布局
- (void)prepareLayoutWithPalaces:(NSInteger)palaces {
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    if (palaces == 3) {
        // 三宫格
        NSInteger count = [self.collectionView numberOfItemsInSection:0];
        for (int i = 0; i < count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            // 设置布局属性
            if (i == 0) {
                CGFloat x = 0;
                CGFloat y = 0;
                CGFloat width = self.collectionView.frame.size.width;
                CGFloat height = self.collectionView.frame.size.height/2;
                attrs.frame = CGRectMake(x, y, width, height);
            } else if (i == 1) {
                CGFloat x = 0;
                CGFloat y = self.collectionView.frame.size.height/2;
                CGFloat width = self.collectionView.frame.size.width/2;
                CGFloat height = self.collectionView.frame.size.height/2;
                attrs.frame = CGRectMake(x, y, width, height);
            } else if (i == 2) {
                CGFloat x = self.collectionView.frame.size.width/2;
                CGFloat y = self.collectionView.frame.size.height/2;
                CGFloat width = self.collectionView.frame.size.width/2;
                CGFloat height = self.collectionView.frame.size.height/2;
                attrs.frame = CGRectMake(x, y, width, height);
            } else {
                UICollectionViewLayoutAttributes *lastAttrs = self.attrsArray[i - 3];
                CGRect lastFrame = lastAttrs.frame;
                lastFrame.origin.x += self.collectionView.frame.size.width;
                attrs.frame = lastFrame;
            }
            
            [self.attrsArray addObject:attrs];
        }
    }
    
    if (palaces == 4) {
        // 四宫格
        NSInteger count = [self.collectionView numberOfItemsInSection:0];
        for (int i = 0; i < count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            // 设置布局属性
            if (i == 0) {
                CGFloat x = 0;
                CGFloat y = 0;
                CGFloat width = self.collectionView.frame.size.width/2;
                CGFloat height = self.collectionView.frame.size.height/2;
                attrs.frame = CGRectMake(x, y, width, height);
            } else if (i == 1) {
                CGFloat x = 0;
                CGFloat y = self.collectionView.frame.size.height/2;
                CGFloat width = self.collectionView.frame.size.width/2;
                CGFloat height = self.collectionView.frame.size.height/2;
                attrs.frame = CGRectMake(x, y, width, height);
            } else if (i == 2) {
                CGFloat x = self.collectionView.frame.size.width/2;
                CGFloat y = 0;
                CGFloat width = self.collectionView.frame.size.width/2;
                CGFloat height = self.collectionView.frame.size.height/2;
                attrs.frame = CGRectMake(x, y, width, height);
            } else if (i == 3) {
                CGFloat x = self.collectionView.frame.size.width/2;
                CGFloat y = self.collectionView.frame.size.height/2;
                CGFloat width = self.collectionView.frame.size.width/2;
                CGFloat height = self.collectionView.frame.size.height/2;
                attrs.frame = CGRectMake(x, y, width, height);
            } else {
                UICollectionViewLayoutAttributes *lastAttrs = self.attrsArray[i - 4];
                CGRect lastFrame = lastAttrs.frame;
                lastFrame.origin.x += self.collectionView.frame.size.width;
                attrs.frame = lastFrame;
            }
            [self.attrsArray addObject:attrs];
        }
    }
    
    
    // TODO: 对最后一页布局进行调整
     if (count%self.palaces == 1) {
         // 剩1个 铺满
         UICollectionViewLayoutAttributes *attrs = self.attrsArray.lastObject;
         CGRect lastFrame = attrs.frame;
         lastFrame.size.width = self.collectionView.frame.size.width;
         lastFrame.size.height = self.collectionView.frame.size.height;
         attrs.frame = lastFrame;
         [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];
     } else if (count%self.palaces == 2) {
         // 剩2个 上1下1
         UICollectionViewLayoutAttributes *attrs = self.attrsArray[count-1];
         CGRect lastFrame = attrs.frame;
         lastFrame.size.width = self.collectionView.frame.size.width;
         attrs.frame = lastFrame;
         [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];
         
         attrs = self.attrsArray[count-2];
         lastFrame = attrs.frame;
         lastFrame.size.width = self.collectionView.frame.size.width;
         attrs.frame = lastFrame;
         [self.attrsArray replaceObjectAtIndex:count-2 withObject:attrs];
     } else if (count%self.palaces == 3) {
         // 剩3个 上1下2
         UICollectionViewLayoutAttributes *attrs = self.attrsArray[count-3];
         CGRect lastFrame = attrs.frame;
         lastFrame.size.width = self.collectionView.frame.size.width;
         attrs.frame = lastFrame;
         [self.attrsArray replaceObjectAtIndex:count-3 withObject:attrs];
         
         attrs = self.attrsArray.lastObject;
         lastFrame = attrs.frame;
         lastFrame.origin.y = self.collectionView.frame.size.height/2;
         attrs.frame = lastFrame;
         [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];
     }
}

@end

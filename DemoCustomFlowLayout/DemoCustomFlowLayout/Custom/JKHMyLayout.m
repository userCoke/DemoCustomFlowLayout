//
//  JKHMyLayout.m
//  DemoPhotoCheck
//
//  Created by hj on 2019/10/31.
//  Copyright © 2019 PPX. All rights reserved.
//

#import "JKHMyLayout.h"

@interface JKHMyLayout ()
/** 几宫格 */
@property (nonatomic, assign) NSInteger palaces;
/** 宫格行数 */
@property (nonatomic, assign) NSInteger placesRow;
/** 宫格列数 */
@property (nonatomic, assign) NSInteger placesColumn;
/** 宫格宽 */
@property (nonatomic, assign) CGFloat placesWidth;
/** 宫格高 */
@property (nonatomic, assign) CGFloat placesHeight;
/** 单元格下标 */
@property (nonatomic, assign) NSInteger cellIndex;
/** 单元格宽 */
@property (nonatomic, assign) CGFloat cellWidth;
/** 单元格高 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 单元格所在行数 */
@property (nonatomic, assign) NSInteger cellRow;
/** 单元格所在列数 */
@property (nonatomic, assign) NSInteger cellColumn;
/** 单元格横坐标 */
@property (nonatomic, assign) CGFloat cellOriginX;
/** 单元格纵坐标 */
@property (nonatomic, assign) CGFloat cellOriginY;
/** 是否是纵向 */
@property (nonatomic, assign) BOOL isVertical;
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
- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    if (self = [super init]) {
        self.placesRow = row;
        self.placesColumn = column;
        self.palaces = row * column;
        self.scrollDirection = scrollDirection;
        self.isVertical = (scrollDirection == UICollectionViewScrollDirectionVertical);
    }
    return self;
}

// TODO:1.布局前的准备会调用这个方法
- (void)prepareLayout {
    [super prepareLayout];
    
    // 根据宫格规则布局
    self.placesWidth = self.collectionView.frame.size.width;
    self.placesHeight = self.collectionView.frame.size.height;
    self.cellWidth = self.placesWidth/self.placesColumn;
    self.cellHeight = self.placesHeight/self.placesRow;
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        NSInteger cellRow;
        NSInteger cellColumn;
        CGFloat cellX;
        CGFloat cellY;

        if (self.isVertical) {
            cellRow = i / self.placesRow;
            cellColumn = i % self.placesRow;
        } else {
            cellRow = i % self.placesRow;
            cellColumn = i / self.placesRow;
        }
        cellX = cellColumn * self.cellWidth;
        cellY = cellRow * self.cellHeight;
        
        attrs.frame = CGRectMake(cellX, cellY, self.cellWidth, self.cellHeight);
        [self.attrsArray addObject:attrs];
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
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            lastFrame.size.height = self.collectionView.frame.size.height;
        } else {
            lastFrame.size.width = self.collectionView.frame.size.width;
        }
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];

        attrs = self.attrsArray[count-2];
        lastFrame = attrs.frame;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            lastFrame.size.height = self.collectionView.frame.size.height;
        } else {
            lastFrame.size.width = self.collectionView.frame.size.width;
        }
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
    
    
    //    if (self.palaces == 0) {
    //        self.palaces = 4;
    //    }
    
    // 根据宫格规则布局
    //    [self prepareLayoutWithPalaces:self.palaces];
}

// TODO:2.返回collectionView的内容大小
- (CGSize)collectionViewContentSize {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger page = count/self.palaces;
    if (count%self.palaces>0) {
        page++;
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        // 横向
        CGSize size = CGSizeMake(self.collectionView.frame.size.width*page, self.collectionView.frame.size.height);
        return size;
    } else {
        // 纵向
        CGSize size = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height*page);
        return size;
    }
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

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
/** 单元格宽 */
@property (nonatomic, assign) CGFloat cellWidth;
/** 单元格高 */
@property (nonatomic, assign) CGFloat cellHeight;
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
    CGFloat cellWidth = self.collectionView.frame.size.width/self.placesColumn;
    CGFloat cellHeight = self.collectionView.frame.size.height/self.placesRow;
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        NSInteger cellRow;
        NSInteger cellColumn;
        CGFloat cellX;
        CGFloat cellY;

        if (self.isVertical) {
            cellColumn = i % self.placesColumn;
            cellRow = i / self.placesColumn;
        } else {
            cellColumn = i / self.placesRow;
            cellRow = i % self.placesRow;
        }
        cellX = cellColumn * self.cellWidth;
        cellY = cellRow * self.cellHeight;
        
        attrs.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        [self.attrsArray addObject:attrs];
    }
    
    // TODO: 对最后一页布局进行调整
    if (count%self.palaces == 1) {
        // 剩1个 铺满
        UICollectionViewLayoutAttributes *attrs = self.attrsArray[count-1];
        CGRect lastFrame = attrs.frame;
        lastFrame.size.width = self.collectionView.frame.size.width;
        lastFrame.size.height = self.collectionView.frame.size.height;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];
    } else if (count%self.palaces == 2) {
        // 剩2个 上1下1
        UICollectionViewLayoutAttributes *attrs = self.attrsArray[count-2];
        CGRect lastFrame = attrs.frame;
        lastFrame.size.width = self.collectionView.frame.size.width;
        lastFrame.size.height = self.collectionView.frame.size.height/2;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-2 withObject:attrs];

        attrs = self.attrsArray[count-1];
        lastFrame.origin.y += lastFrame.size.height;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];
    } else if (count%self.palaces == 3) {
        // 剩3个 上1
        UICollectionViewLayoutAttributes *attrs = self.attrsArray[count-3];
        CGRect lastFrame = attrs.frame;
        lastFrame.size.width = self.collectionView.frame.size.width;
        lastFrame.size.height = self.collectionView.frame.size.height/2;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-3 withObject:attrs];

        // 下2
        attrs = self.attrsArray[count-2];
        lastFrame.origin.y = lastFrame.size.height;
        lastFrame.size.width = lastFrame.size.width/2;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-2 withObject:attrs];

        attrs = self.attrsArray[count-1];
        lastFrame.origin.x += lastFrame.size.width;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];
    } else if (count%self.palaces == 4) {
        // 剩4个 上2
        UICollectionViewLayoutAttributes *attrs = self.attrsArray[count-4];
        CGRect lastFrame = attrs.frame;
        lastFrame.size.width = self.collectionView.frame.size.width/2;
        lastFrame.size.height = self.collectionView.frame.size.height/2;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-4 withObject:attrs];

        attrs = self.attrsArray[count-3];
        lastFrame.origin.y = CGRectGetMaxY(lastFrame);
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-3 withObject:attrs];

        // 下2
        attrs = self.attrsArray[count-2];
        lastFrame.origin.x = CGRectGetMaxX(lastFrame);
        lastFrame.origin.y = CGRectGetMinY(lastFrame)-lastFrame.size.height;
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-2 withObject:attrs];

        attrs = self.attrsArray[count-1];
        lastFrame.origin.y = CGRectGetMaxY(lastFrame);
        attrs.frame = lastFrame;
        [self.attrsArray replaceObjectAtIndex:count-1 withObject:attrs];
    }
}

// TODO:2.返回collectionView的内容大小
- (CGSize)collectionViewContentSize {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger page;
    if (count%self.palaces > 0) {
        page = count/self.palaces + 1;
    } else {
        page = count/self.palaces;
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

@end

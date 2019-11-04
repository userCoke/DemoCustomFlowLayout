# DemoCustomFlowLayout
自定义UICollectionViewFlowlayout

关键词  
NSInteger placesRow：宫格行数  
NSInteger placesColumn：宫格列数  
CGFloat placesWidth：宫格宽  
CGFloat placesHeight：宫格高  

NSInteger cellIndex：单元格下标  
NSInteger cellRow：单元格所在行数  
NSInteger cellColumn：单元格所在列数  
CGFloat cellWidth: 单元格宽  
CGFloat cellHeight：单元格高  
CGFloat cellX：单元格横坐标  
CGFloat cellY：单元格纵坐标  

关系  
cellWidth = placesWidth / placesHeight;  
cellHeight = placesHeight / placesRow;  
cellRow = cellIndex / placesRow;(纵向排)  
cellColumn = cellIndex % placesRow;(纵向排)  
cellRow = cellIndex % placesRow;(横向排)  
cellColumn = cellIndex / placesRow;(横向排)  
cellX = cellColumn * cellWidth;  
cellY = cellRow * cellHeight;  

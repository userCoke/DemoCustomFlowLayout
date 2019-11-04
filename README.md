# DemoCustomFlowLayout
自定义UICollectionViewFlowlayout

关键词
placesRow：宫格行数  
placesCol：宫格列数  
placesWidth：宫格宽
placesHeight：宫格高

cellIndex：单元格下标
cellWidth: 单元格宽
cellHeight：单元格高
cellRow：单元格所在行数
cellCol：单元格所在列数
cellX：单元格横坐标
cellY：单元格纵坐标

关系
cellWidth = placesWidth / placesRow;
cellHeight = placesHeight / placesHeight;

cellRow = cellIndex % placesRow; （纵向排）
cellCol = cellIndex / placesRow；（纵向排）
cellRow = cellIndex / placesRow; （横向排）
cellCol = cellIndex % placesRow；（横向排）

cellX = cellCol * cellWidth;
cellY = cellRow * cellHeight; 

//
//  SYTagListView.m
//  SuYun
//
//  Created by iBlock on 15/11/19.
//  Copyright © 2015年 58. All rights reserved.
//

#import "SYTagListView.h"

@interface SYTagListView ()

@property (assign, nonatomic) CGFloat validContentWidth;

@property (strong, nonatomic) NSMutableArray *itemArray;

@property (copy, nonatomic) ClickedIndexBlock clickedIndexBlock;

@property (copy, nonatomic) TagListViewUpdateFrameBlock updateFrameBlock;

@end

@implementation SYTagListView

- (instancetype)initWithFrame:(CGRect)frame andTags:(NSArray*)tagsArr
{
    if (self = [super initWithFrame:frame]) {
        [self configInitValueForProperty];
        self.tagsArr = tagsArr;
        [self checkObjectTypeNSString];
        [self makeItems];
        [self resetItemsFrame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)addTagWithTagName:(NSString *)tagName {
    UIButton *button = [self makeItemButton:tagName];
    [self.itemArray addObject:button];
    [self addSubview:button];
    [self resetItemsFrame];
}

/** Tag标签数据检查 */
- (void)checkObjectTypeNSString
{
    for (id obj in self.tagsArr) {
        NSAssert([obj isKindOfClass:[NSString class]], @"tag标签中的数据只能是字符串");
    }
}

/** 初始化Tag标签属性 */
- (void)configInitValueForProperty
{
    _contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _itemSpacing = 6;
    _lineSpacing = 6;
    _font = [UIFont systemFontOfSize:13];
    _autoItemHeightWithFontSize = YES;
    _autoItemWidthWithFontSize = YES;
    _tagBackgroundColor = [UIColor whiteColor];
    _tagTextColor = [UIColor blackColor];
    _tagBoarderColor = [UIColor whiteColor];
    _tagBorderWidth = 1;
    _tagCornerRadius = 3;
    _isClickEnable = YES;
    _selectTagTextColor = [UIColor whiteColor];
    _selectTagBoarderColor = [UIColor clearColor];
    
    if (self.autoItemHeightWithFontSize) {
        UIFontDescriptor *fontDescriptor = [self.font fontDescriptor];
        _itemHeight = [[[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorSizeAttribute] floatValue]+4;
    }
    
    self.validContentWidth = CGRectGetWidth(self.frame) - self.contentInsets.right;
}

/** 构建标签列表 */
- (void)makeItems
{
    for (NSString *tagStr in self.tagsArr) {
        UIButton *button = [self makeItemButton:tagStr];
        [self.itemArray addObject:button];
        [self addSubview:button];
    }
}

- (UIButton *)makeItemButton:(NSString *)tagStr {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = self.font;
    button.backgroundColor = self.tagBackgroundColor;
    [button setTitleColor:self.tagTextColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectTagTextColor forState:UIControlStateSelected];
    [button setTitle:tagStr forState:UIControlStateNormal];
    button.layer.borderColor = self.tagBoarderColor.CGColor;
    button.layer.borderWidth = self.tagBorderWidth;
    button.layer.cornerRadius = self.tagCornerRadius;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - frame helper

- (void)resetItemsFrame
{
    CGFloat x = self.contentInsets.left+_oneItemSpacing;
    CGFloat y = self.contentInsets.top;
    for (UIButton *button in self.itemArray) {
        //计算文字所占的宽高
        CGSize size = [button.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (_autoItemWidthWithFontSize) {
            size.width += 20;
//            /** 根据UI图显示最小为70 */
//            if (size.width < 70) {
//                size.width = 70;
//            }
        } else {
            size.width = _itemWidth;
        }
        [button setFrame:CGRectMake(x, y, size.width, self.itemHeight)];
        button.layer.masksToBounds = YES;
        
        //判断是否已经超出了有效区域
        if (CGRectGetMaxX(button.frame) > self.validContentWidth) {
            //如果超出换行到下一行
            //重新计算x,y
            x = self.contentInsets.left;
            y = CGRectGetMaxY(button.frame) + self.lineSpacing;
            button.frame = CGRectMake(x, y, size.width, self.itemHeight);
            
            }
        //计算下一个的x,y
        x += size.width + self.itemSpacing;
        y = button.frame.origin.y;
        
    }
    UIButton *lastObj = [self.itemArray lastObject];
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            CGRectGetMaxY(lastObj.frame) + self.contentInsets.bottom);
    if (self.updateFrameBlock) {
         self.updateFrameBlock(self.frame);
    }
    if ([self.delegate respondsToSelector:@selector(tagListView:didUpdateFrame:)]) {
        [self.delegate tagListView:self didUpdateFrame:self.frame];
    }
}

#pragma mark - Public Methods
- (void)setSelectedIndex:(NSInteger)index {
    
    if (index >= 0 && index < self.itemArray.count) {
        UIButton *btn = [self.itemArray objectAtIndex:index];
        [self buttonClicked:btn];
    }
}

#pragma mark - block

- (void)clickedIndex:(ClickedIndexBlock)block
{
    self.clickedIndexBlock = block;
}

- (void)didUpdatedTagListViewFrame:(TagListViewUpdateFrameBlock)block
{
    self.updateFrameBlock = block;
}

#pragma mark - button action

- (void)buttonClicked:(UIButton*)button
{
    if (self.clickedIndexBlock) {
        self.clickedIndexBlock(button);
    }
    if ([self.delegate respondsToSelector:@selector(tagListView:didClickedAtIndex:)]) {
        [self.delegate tagListView:self didClickedAtIndex:[self.itemArray indexOfObject:button]];
    }
    
    // 设置选中样式
    UIButton *lastSelectedBtn;
    for (UIButton *btn in self.itemArray) {
        if (btn.state == UIControlStateSelected) {
            lastSelectedBtn = btn;
            break;
        }
    }
    if (lastSelectedBtn != nil || button != lastSelectedBtn) {
        lastSelectedBtn.selected = NO;
        button.selected = YES;
        
        lastSelectedBtn.layer.borderColor = self.tagBoarderColor.CGColor;
        button.layer.borderColor = self.selectTagBoarderColor.CGColor;
    }
}

#pragma mark - setter 

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    self.validContentWidth = CGRectGetWidth(self.frame) - self.contentInsets.right;
    [self resetItemsFrame];
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
    _itemSpacing = itemSpacing;
    [self resetItemsFrame];
}

- (void)setOneItemSpacing:(CGFloat)oneItemSpacing
{
    _oneItemSpacing = oneItemSpacing;
    [self resetItemsFrame];
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    [self resetItemsFrame];
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    
    if (self.autoItemHeightWithFontSize) {
        return;
    }else{
        _itemHeight = itemHeight;
        [self resetItemsFrame];
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    for (UIButton *button in self.itemArray) {
        button.titleLabel.font = font;
    }
    if (self.autoItemHeightWithFontSize) {
        UIFontDescriptor *fontDescriptor = [self.font fontDescriptor];
        _itemHeight = [[[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorSizeAttribute] floatValue] + 4;
    }
    [self resetItemsFrame];
}

- (void)setAutoItemHeightWithFontSize:(BOOL)autoItemHeightWithFontSize
{
    _autoItemHeightWithFontSize = autoItemHeightWithFontSize;
    if (autoItemHeightWithFontSize) {
        UIFontDescriptor *fontDescriptor = [self.font fontDescriptor];
        _itemHeight = [[[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorSizeAttribute] floatValue] + 4;
        [self resetItemsFrame];
    }
}

- (void)setIsClickEnable:(BOOL)isClickEnable {
    _isClickEnable = isClickEnable;
    for ( UIButton *button in self.itemArray) {
        button.enabled = isClickEnable;
    }
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
{
    _tagBackgroundColor = tagBackgroundColor;
    for ( UIButton *button in self.itemArray) {
        button.backgroundColor = tagBackgroundColor;
    }
}

- (void)setTagBorderWidth:(CGFloat)tagBorderWidth {
    _tagBorderWidth = tagBorderWidth;
    for ( UIButton *button in self.itemArray) {
        button.layer.borderWidth = tagBorderWidth;
    }
}

- (void)setTagCornerRadius:(CGFloat)tagCornerRadius {
    _tagCornerRadius = tagCornerRadius;
    for ( UIButton *button in self.itemArray) {
        button.layer.cornerRadius = tagCornerRadius;
    }
}

- (void)setTagTextColor:(UIColor *)tagTextColor
{
    _tagTextColor = tagTextColor;
    for ( UIButton *button in self.itemArray) {
        [button setTitleColor:tagTextColor forState:UIControlStateNormal];
    }
}
//selectTagTextColor
- (void)setSelectTagTextColor:(UIColor *)selectTagTextColor {
    
    _selectTagTextColor = selectTagTextColor;
    for ( UIButton *button in self.itemArray) {
        [button setTitleColor:selectTagTextColor forState:UIControlStateSelected];
    }
}

- (void)setTagBoarderColor:(UIColor *)tagBoarderColor
{
    _tagBoarderColor = tagBoarderColor;
    for ( UIButton *button in self.itemArray) {
        button.layer.borderColor = tagBoarderColor.CGColor;
    }
}

- (void)setSelectTagBoarderColor:(UIColor *)selectTagBoarderColor {
    
    _selectTagTextColor = selectTagBoarderColor;
    for (UIButton *button in self.itemArray) {
        if (button.state == UIControlStateSelected) {
            button.layer.borderColor = selectTagBoarderColor.CGColor;
        }
    }
}

#pragma mark - getter

- (NSMutableArray *)itemArray
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (UIButton *)fetchTagAtIndex:(int)index {
    return self.itemArray[index];
}

@end

//
//  SYTagListView.h
//  SuYun
//
//  Created by iBlock on 15/11/19.
//  Copyright © 2015年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedIndexBlock)(UIButton *cityBtn);
typedef void(^TagListViewUpdateFrameBlock)(CGRect frame);

@protocol SYTagListViewDelegate;

@interface SYTagListView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTags:(NSArray*)tagsArr;
- (instancetype)initWithCanEdit:(CGRect)frame;
- (void)addTagWithTagName:(NSString *)tagName;

/** 调整完样式后需要调用该方法进行更新 */
- (void)resetItemsFrame;

/**
 *  可以实现代理，也可以不实现，有相同的功能的block方法代替。
 */
@property (weak, nonatomic) id<SYTagListViewDelegate>delegate;


/**
 *  tag的数据源
 */
@property (copy, nonatomic) NSArray *tagsArr;

/**
 *  tag的有效区域。默认（0，0，0，0）
 */
@property (assign, nonatomic) UIEdgeInsets contentInsets;

/**
 *  同一行两个相临tag的间距。默认6
 */
@property (assign, nonatomic) CGFloat itemSpacing;

/** 第一个标签所在的位置,这个属性只是针对需求，并不通用 */
@property (assign, nonatomic) CGFloat oneItemSpacing;

/**
 *  两行tag之间的间距。默认6
 */
@property (assign, nonatomic) CGFloat lineSpacing;

/**
 *  tag标签的高度,一般情况下不设置。
 */
@property (assign, nonatomic) CGFloat itemHeight;

/**
 *  tag标签的宽度,一般情况下不设置。
 */
@property (assign, nonatomic) CGFloat itemWidth;

/** 标签是否可点击,默认YES */
@property (assign, nonatomic) BOOL isClickEnable;

/**
 *  tag标签的字体，默认系统字体13号
 */
@property (strong, nonatomic) UIFont *font;

/**
 *  是否自动计算tag的高度。默认YES,当设置为NO时，需要设置itemHeight属性
 */
@property (assign, nonatomic) BOOL autoItemHeightWithFontSize;

/**
 *  是否自动计算tag的宽度。默认YES,当设置为NO时，需要设置itemWidth属性
 */
@property (assign, nonatomic) BOOL autoItemWidthWithFontSize;

/** tag边框大小，默认2像素 */
@property (nonatomic, assign) CGFloat tagBorderWidth;

/** tag边框弧度，默认6像素 */
@property (nonatomic, assign) CGFloat tagCornerRadius;

/**
 *  标签的背景颜色，默认白色
 */
@property (strong, nonatomic) UIColor *tagBackgroundColor;

/**
 *  标签文字的颜色，默认黑色
 */
@property (strong, nonatomic) UIColor *tagTextColor;
/**
 *  标签选中时文字颜色, 默认红色
 */
@property (strong, nonatomic) UIColor *selectTagTextColor;

/**
 *  标签边框的颜色,默认lightGrayColor
 */
@property (strong, nonatomic) UIColor *tagBoarderColor;
/**
 *  标签选中时边框颜色, 默认红色
 */
@property (strong, nonatomic) UIColor *selectTagBoarderColor;

- (void)setSelectedIndex:(NSInteger)index;


/**
 *  block传递点中的位置
 *
 *  @param block 点中的位置的block
 */
- (void)clickedIndex:(ClickedIndexBlock)block;

/**
 *  在自动布局计算完成后，会自动调整TagListView的height。该方法可根据需要自行使用。
 *
 *  @param block frame更新的block
 */
- (void)didUpdatedTagListViewFrame:(TagListViewUpdateFrameBlock)block;

/** 根据数据位置Index获取Tag */
- (UIButton *)fetchTagAtIndex:(int)index;

@end

@protocol SYTagListViewDelegate <NSObject>

@optional
/**
 *  点中tag后的代理，有block方法
 *
 *  @param tagListView ====
 *  @param index       点中的位置
 */
- (void)tagListView:(SYTagListView*)tagListView didClickedAtIndex:(NSInteger)index;

/**
 *  在自动布局计算完成后，会自动调整TagListView的height。该代理方法可根据需要自行使用。
 *
 *  @param tagListView =====
 *  @param frame       更新后的frame
 */
- (void)tagListView:(SYTagListView *)tagListView didUpdateFrame:(CGRect)frame;

@end

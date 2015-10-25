//
//  ViewController.m
//  JYDragView
//
//  Created by joyann on 15/10/19.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "ViewController.h"

static const CGFloat JYMainViewMaxY    = 200;
static const CGFloat JYMainViewSpacing = 200;

#define JYScreenWidth   [UIScreen mainScreen].bounds.size.width
#define JYScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, weak) UIView *mainView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubviews];
    [self addGesturesToMainView];
    [self addGesturesToView];
}

#pragma mark - Add Subviews

- (void)addSubviews
{
    // 添加右侧view
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    rightView.backgroundColor = [UIColor blueColor];
    self.rightView = rightView;
    [self.view addSubview:rightView];
    
    // 添加左侧view
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    leftView.backgroundColor = [UIColor yellowColor];
    self.leftView = leftView;
    [self.view addSubview:leftView];
    
    // 添加中间主view
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor orangeColor];
    self.mainView = mainView;
    [self.view addSubview:mainView];
}

#pragma mark - Add Gestures

- (void)addGesturesToMainView
{
    // 滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.mainView addGestureRecognizer:pan];
    
}

- (void)addGesturesToView
{
    // 为控制器视图增加手势，点击的时候将mainView放回原点
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Handle Actions

- (void)handleTap: (UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = self.view.bounds;
    }];
}

- (void)handlePan: (UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        // 移动mainView
        CGPoint translationPoint = [pan translationInView:self.view];

        [self frameWithOffsetX:translationPoint.x];
        
        if (self.mainView.frame.origin.x > 0) {    // 右滑时显示leftView
            self.leftView.hidden = NO;
            
        } else {    // 左滑时显示rightView
            self.leftView.hidden = YES;
        }
        
        // 重置translation
        [pan setTranslation:CGPointZero inView:self.mainView];
    }
    
    CGFloat mainViewX = 0.0f;
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 判断mainView的位置
        if (self.mainView.frame.origin.x > 0.5 * JYScreenWidth) {
            mainViewX = JYScreenWidth - JYMainViewSpacing;
        } else if (CGRectGetMaxX(self.mainView.frame) < 0.5 * JYScreenWidth) {
            mainViewX = JYMainViewSpacing - JYScreenWidth;
        }
        CGFloat offsetX = mainViewX - self.mainView.frame.origin.x;
        [UIView animateWithDuration:0.25 animations:^{
            [self frameWithOffsetX:offsetX];
        }];
    }
}

#pragma mark - Helper Methods

- (void)frameWithOffsetX: (CGFloat)offsetX
{
    CGRect frame = self.mainView.frame;
    // 根据移动距离改变mainView的x坐标
    frame.origin.x += offsetX;
    // 根据移动距离改变mainView的y坐标, 最大到200
    // 计算公式为： 当前的y / 最大的y(即为200) = 当前的x / 最大的x(即为屏幕宽度)
    // 也就是说，当mainView的横轴坐标与屏幕宽度相等时，y正好为最大值200
    frame.origin.y = fabs(frame.origin.x * JYMainViewMaxY / JYScreenWidth);
    frame.size.height = JYScreenHeight - 2 * frame.origin.y;
    
    self.mainView.frame = frame;
}

@end














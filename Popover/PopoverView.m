//
//  PopoverView.m
//  Popover
//
//  Created by lx on 16/9/18.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import "PopoverView.h"

#define ArrowMarginYWithItem  2

#define ArrowWidth 15
#define ArrowHeight 8

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define leftAndRightMargin 10 //左右间距


#define kContentViewWidth 140
#define kContenViewHeight 150

@interface ArrowView : UIView

@property (nonatomic, strong) UIColor *arrowFillColor;

@end

@implementation ArrowView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arrowFillColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    [super drawRect:rect];
    
    CGSize size = rect.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //线宽
    CGContextSetLineWidth(context, 1);
    
    CGContextSetFillColorWithColor(context, self.arrowFillColor.CGColor);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, size.width / 2, 0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

-(void)setArrowFillColor:(UIColor *)arrowFillColor
{
    _arrowFillColor = arrowFillColor;
    [self setNeedsDisplay];
}


@end


@interface UIBackgroundView : UIView<UIGestureRecognizerDelegate>

@end

@implementation UIBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


- (void)viewTapped:(UITapGestureRecognizer *)tap
{
    [PopoverView dismiss];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = gestureRecognizer.view;
    CGPoint point = [touch locationInView:view];
    for (UIView *subViews in self.subviews) {
        if (CGRectContainsPoint(subViews.frame, point)) {
            return  false;
        }
    }
    return true;
}

@end



@interface PopoverView ()

@end

@implementation PopoverView


+ (void)initWithDataSourceView:(UIView *)view toItem:(UIView *)itemView
{
    NSAssert(view != nil, @"view 不能为空");
    UIBackgroundView *backgroundView = [[UIBackgroundView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
    
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;

    //将坐标转换到backgroundView上
    CGRect newItemSize = [itemView convertRect:itemView.bounds toView:nil];
    
    CGFloat arrowX = newItemSize.origin.x + (itemView.frame.size.width - ArrowWidth)/ 2;
    CGFloat arrowY = CGRectGetMaxY(newItemSize) + ArrowMarginYWithItem;
    
    ArrowView *arrowView = [[ArrowView alloc] init];
    arrowView.alpha = 0.0;
    arrowView.frame = CGRectMake(arrowX, arrowY, ArrowWidth, ArrowHeight);
    
    // x轴是到item宽度的一半
    CGFloat contentViewX = arrowView.frame.origin.x - (view.frame.size.width - arrowView.frame.size.width) / 2;
    CGFloat contentViewY = CGRectGetMaxY(arrowView.frame) - ArrowMarginYWithItem;
    
    view.frame = CGRectMake(arrowX, 64, 0, 0);
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        arrowView.alpha = 1.0;
        view.frame = CGRectMake(contentViewX, contentViewY,kContentViewWidth,kContenViewHeight);
        [self updateViewFrameXWithTagetView:view];
    } completion:nil];
    
    [backgroundView addSubview:arrowView];
    [backgroundView insertSubview:view aboveSubview:arrowView];

}

+(void)dismiss
{
    CGFloat arrowViewX = 0.0;
    for (UIView *arrowView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([arrowView isKindOfClass:[UIBackgroundView class]]) {
            for (UIView *view in arrowView.subviews) {
                if ([view isKindOfClass:[ArrowView class]]) {
                    view.alpha = 0.0;
                    arrowViewX = view.frame.origin.x;
                }else{
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        view.frame = CGRectMake(arrowViewX + ArrowWidth / 2, 64, 0, 0);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [view removeFromSuperview]; 
                            [arrowView removeFromSuperview];
                        }
                    }];
                }
            }
        }
    }
}

+ (void)updateViewFrameXWithTagetView:(UIView *)targetView
{
      //view的x轴超过了右间距
    if (CGRectGetMaxX(targetView.frame) > (kScreenWidth - leftAndRightMargin)) {
        CGRect frame = targetView.frame;
        frame.origin.x = kScreenWidth - leftAndRightMargin - targetView.frame.size.width;
        targetView.frame = frame;
    }
}


@end

//
//  PopoverView.h
//  Popover
//
//  Created by lx on 16/9/18.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverView : NSObject


+ (void) initWithDataSourceView:(UIView *)view toItem:(UIView *)itemView;


+ (void)dismiss;

@end

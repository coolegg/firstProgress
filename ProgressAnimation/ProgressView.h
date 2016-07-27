//
//  ProgressView.h
//  ProgressAnimation
//
//  Created by MaRui on 16/7/18.
//  Copyright © 2016年 MaRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame setProgress:(CGFloat)percentag Duration:(CFTimeInterval)duration;
@end

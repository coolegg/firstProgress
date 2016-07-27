//
//  ProgressView.m
//  ProgressAnimation
//
//  Created by MaRui on 16/7/18.
//  Copyright © 2016年 MaRui. All rights reserved.
//

#import "ProgressView.h"
#import "UIViewExt.h"
#import "BMViewDefine.h"
//RGB
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)     RGBA(r, g, b, 1.0f)

@interface ProgressView (){
    
}
@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,strong) UIImageView *bigImg;
@property (nonatomic,strong) UIImageView *pointImg;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,assign) CGFloat sumSteps;
@property (nonatomic,strong) NSTimer *timer;
//进度百分比
@property (nonatomic,assign)  CGFloat percentage;
@property (nonatomic,assign)  CFTimeInterval duration;
@end

@implementation ProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame setProgress:(CGFloat)percentag Duration:(CFTimeInterval)duration{
    self = [super initWithFrame:frame];
    if (self) {
        _percentage = percentag;
        _duration = duration;
        _sumSteps = 0.0;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        
        UIImageView *bigImg = [[UIImageView alloc]init];
        bgView.clipsToBounds = YES;
        bgView.layer.cornerRadius = self.height/2;
        bigImg.alpha = 0.2;
        bigImg.image = [UIImage imageNamed:@"fb_wave"];
        self.bigImg = bigImg;
        [bgView addSubview:bigImg];
        
        self.bigImg.frame = CGRectMake(-2*frame.size.width, 0, 3*frame.size.width, frame.size.height);
        self.bigImg.top = DEF_BOTTOM(bigImg)-10;
        self.bigImg.right = DEF_RIGHT(bigImg);
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.lineWidth = 8;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.lineWidth = 8;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        _backgroundLayer.lineCap = kCALineCapRound;
        _backgroundLayer.lineJoin = kCALineCapRound;
        
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineJoin = kCALineCapRound;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x , self.center.y) radius:(self.bounds.size.width - 8)/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _backgroundLayer.path = path.CGPath;
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x , self.center.y) radius:(self.bounds.size.width - 8)/2 startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI *2 clockwise:YES];
        _progressLayer.path = path1.CGPath;
        
        [bgView.layer addSublayer:_backgroundLayer];
        [bgView.layer addSublayer:_progressLayer];
        
        
        /*为进度条实现颜色渐变
         *把左半边设置一个颜色渐变，右半边上下部分各设置颜色渐变（效果同在颜色数组里设置更多个颜色）
         */
        //左半边实现颜色渐变
        CALayer *gradientLayer = [CALayer layer];
        
        CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
        gradientLayer1.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height);
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[RGB(252, 200, 83) CGColor],(id)[RGB(209, 172.5, 108) CGColor],(id)[RGB(208, 173, 108) CGColor],(id)[RGB(205, 172, 106) CGColor],(id)[RGB(205, 173, 106) CGColor], nil]];
        [gradientLayer1 setLocations:@[@0.2,@0.4,@0.6,@0.8,@1]];
        [gradientLayer1 setStartPoint:CGPointMake(0, 0)];
        [gradientLayer1 setEndPoint:CGPointMake(1, 1)];
        [gradientLayer addSublayer:gradientLayer1];
        
        //右半边 下半部分
        //右下角
        CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
        gradientLayer2.frame = CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width/2, frame.size.height/2);
        [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[RGB(194,166,121) CGColor],(id)[RGB(209, 172, 120) CGColor],(id)[RGB(190,165,123) CGColor], nil]];
        [gradientLayer2 setLocations:@[@0.33,@0.66,@1]];
        [gradientLayer2 setStartPoint:CGPointMake(0, 0)];
        [gradientLayer2 setEndPoint:CGPointMake(1, 1)];
        [gradientLayer addSublayer:gradientLayer2];
        
        //右半边 上半部分
        //右上角
        CAGradientLayer *gradientLayer3 =  [CAGradientLayer layer];
        gradientLayer3.frame = CGRectMake(frame.size.width/2-4, -frame.size.height/2-45, frame.size.width/2+4, frame.size.height/2+frame.size.height/2+45);
        [gradientLayer3 setColors:[NSArray arrayWithObjects:(id)[RGB(140, 129, 170) CGColor], (id)[RGB(160, 149, 150) CGColor],(id)[RGB(194,166,121) CGColor],nil]];
        [gradientLayer3 setLocations:@[@0.33,@0.66,@1]];
        [gradientLayer3 setStartPoint:CGPointMake(0, 0)];
        [gradientLayer3 setEndPoint:CGPointMake(1, 1)];
        [gradientLayer addSublayer:gradientLayer3];
        
        
        [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        
        
        //百分比label
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
        _progressLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self.progressLabel setTextColor:[UIColor colorWithRed:240/255.0 green:198/255.0 blue:83/255.0 alpha:1]];
        self.progressLabel.text = @"0%";
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        self.progressLabel.font = [UIFont systemFontOfSize:35 weight:0.4];
        [bgView addSubview:self.progressLabel];
        
        
        UIImageView *pointImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        pointImg.center = CGPointMake(bgView.width/2, bgView.height/2);
        //pointImg.backgroundColor = [UIColor redColor];
        pointImg.image = [UIImage imageNamed:@"jindupoint"];
        self.pointImg = pointImg;
        [self addSubview:pointImg];
        //改变锚点，使旋转动画与进度条动画一致。（另一种实现，把原点加在另一个视图上，旋转原点点父视图）
        pointImg.layer.anchorPoint = CGPointMake(0.5, 3.7);
        
        
        [self setProgress:percentag Duration:duration];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
-(void)setProgress:(CGFloat)percentage Duration:(CFTimeInterval)duration{
    //进度条动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:percentage];
    _progressLayer.strokeEnd = percentage;
    animation.duration = duration;
    [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    
    //原点跟着进度条一起动
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 *percentage];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = 1;
    //rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;//动画结束了禁止删除
    rotationAnimation.fillMode = kCAFillModeForwards;//停在动画结束处
    [self.pointImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    //水波 左右滑动
    __weak __typeof(&*self)weakSelf = self;
    void(^acallBack)(CGFloat start) = ^(CGFloat start) {
        CAKeyframeAnimation * moveAction = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        moveAction.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-60],[NSNumber numberWithFloat:start],nil];
        moveAction.duration = duration;
        moveAction.autoreverses = YES;
        moveAction.repeatCount = MAXFLOAT;
        [weakSelf.bigImg.layer addAnimation:moveAction forKey:@"waveMoveAnimation"];
    };
    
    //水波上涨动画（图片从底部斜向滑进来）
    CGFloat avgScore = percentage;
    [UIView animateWithDuration:duration animations:^{
        self.bigImg.top = self.height - (avgScore * self.height);
        self.bigImg.left = 0;
    } completion:^(BOOL finished) {
        //水波到达指定高度，执行不停活动的动画
        acallBack(self.bigImg.layer.position.x);
        
    }];
    
    //start timer
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(numberAnimation)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
}


-(void)numberAnimation
{
    //百分比 增长 动画
    _sumSteps += 0.1;
    float sumSteps =  _percentage/_duration*_sumSteps;
    if (sumSteps > _percentage) {
        //close timer
        [_timer invalidate];
        _timer = nil;
        return;
    }
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",sumSteps *100];
}
@end

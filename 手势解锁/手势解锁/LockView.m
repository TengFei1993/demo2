//
//  LockView.m
//  手势解锁
//
//  Created by yangxiaofei on 15/12/30.
//  Copyright (c) 2015年 yangxiaofei. All rights reserved.
//

#import "LockView.h"

@interface LockView ()

//设置一个数组，存放所有的选中的按钮
@property (nonatomic,strong) NSMutableArray *selectedbtns;

//还需要最后一个点，这个是在move方法中得到的，但是需要在绘图中使用，所以使用属性
@property (nonatomic,assign) CGPoint lastpoint;

@end

@implementation LockView

/*重写init初始化方法，初始化自定义view的时候，同时将view里面的小控件画好1*/
- (instancetype) init
{
    if (self == [super init]) {
        [self setsubviews];
    }
    return self;
}
- (NSMutableArray *) selectedbtns
{
    if (!_selectedbtns) {
        _selectedbtns = [NSMutableArray array];
    }
    return _selectedbtns;
}

//添加 小控件
- (void) setsubviews
{
    NSInteger count = 9;
    for (NSInteger i = 0; i < count; i++) {
#warning 创建按钮的时候应该使用按钮的custom的类型，才可以对按钮操作，更加方便的得到自己想要的样式，如果选择system，会有许多自己不想要的结果。若在按钮的各种状态时得不到自己需要的样式，找错误时候应该看看按钮的类型
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i;
        
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        //设置选中状态的图片，并设置button为不可用
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        //添加到view上
        [self addSubview:btn];
    }
}

//系统提供的方法，用来设置控件的frame，这样就不用在创建控件的时候设置frame了，在这个方法里面设置就好
//重新布局9个按钮
- (void)layoutSubviews
{
    NSInteger count = 9;
    //控件的 宽度 和 高度
    CGFloat btnW = 74;
    CGFloat btnH = 74;
    //间距
    CGFloat margin = (self.bounds.size.width - 3 * btnW) / 4;
    
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        //行号 和 列号
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        //x,y
        CGFloat btnX = margin + (margin + btnW) * column;
        CGFloat btnY = margin + (margin + btnH) * row;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);

    }
}

//判断当前点是否在btn的范围内，如果是就设置btn的选中状态为选中
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

/*
 在这个方法的这条线上，获得的当前点和前一个点并不是只有两个，而是有n多个
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取touch对象
    UITouch *touch = [touches anyObject];
    //获取当前点
    CGPoint location = [touch locationInView:touch.view];
    //判断该点是否在btn的范围内，如果是就设置它的状态为选中
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, location)) {
            //同一个按钮，当是第一次点击时候，即是no的时候，才添加到数组
            if (btn.selected == NO) {
                //判断是否要把某个按钮放到数组中，并不是靠是否selected状态，而是靠当前点是否在这个按钮的范围内，如果在，就放，不在不放
                [self.selectedbtns addObject:btn];
            }
            btn.selected = YES;
        }else{
            self.lastpoint = location;
        }
    }
    //重绘
    [self setNeedsDisplay];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%ld",self.selectedbtns.count);
    NSMutableString *str = [NSMutableString string];
    for (UIButton *btn in self.selectedbtns) {
        [str appendFormat:@"%ld",btn.tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(lockview:andStr:)]){
        [self.delegate lockview:self andStr:str];
    }
    
    
    
    // 将所有的选中的按钮的状态设置成no,数组中所有的对象都执行一个方法，并且object起一个参数的作用
    [self.selectedbtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@NO];
    
    
    //将线清空
    [self.selectedbtns removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}
//画线－－ 将所有的选中的按钮的中心点连接起来


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
 调用这个绘图方法的时候，如果不给view设置一个背景颜色，则默认的是黑色的背景颜色。
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //使用UIBezierPath画线
//<Error>: void CGPathAddLineToPoint(CGMutablePathRef, const CGAffineTransform *, CGFloat, CGFloat): no current point.
#warning 上述的解决方法
    if (self.selectedbtns.count == 0) return;
    
    
    //创建一个路径
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    //使用这个路径根据点画线
    NSInteger cout = self.selectedbtns.count;
    for (NSInteger i = 0; i < cout; i++) {
        UIButton *btn = self.selectedbtns[i];
        CGPoint point = btn.center;
        if (i == 0) {
            [bezier moveToPoint:point];
        }else{
            [bezier addLineToPoint:point];
        }
    }
    //当将所有的点连线完毕之后，追加最后一个点
    [bezier addLineToPoint:self.lastpoint];
    
    
    bezier.lineWidth = 8;
    bezier.lineJoinStyle = kCGLineCapRound;
    bezier.lineCapStyle = kCGLineCapRound;
    [[UIColor greenColor] set];
    //渲染
    [bezier stroke];
}

@end

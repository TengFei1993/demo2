//
//  LockView.h
//  手势解锁
//
//  Created by yangxiaofei on 15/12/30.
//  Copyright (c) 2015年 yangxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LockView;

@protocol  LockViewDelegate <NSObject>

@optional

- (void) lockview:(LockView *)lockview andStr:(NSString *) string;

@end

@interface LockView : UIView

@property (nonatomic,weak) id<LockViewDelegate> delegate;

@end

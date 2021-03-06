//  Created by Alejandro Isaza on 2013-03-26.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.

#import <UIKit/UIKit.h>


@interface AIAnimation : NSOperation <NSCopying>

typedef void (^AISetupBlock)();
typedef void (^AIAnimationBlock)();
typedef void (^AICompletionBlock)(BOOL finished);

@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSTimeInterval delay;

@property (assign, nonatomic) BOOL easeIn;
@property (assign, nonatomic) BOOL easeOut;
@property (assign, nonatomic) BOOL beginFromCurrentState;
@property (assign, nonatomic) BOOL repeat;

@property (copy, nonatomic) AISetupBlock setupBlock;
@property (copy, nonatomic) AIAnimationBlock animationBlock;
@property (copy, nonatomic) AICompletionBlock animationCompletionBlock;

+ (instancetype)animationWithDuration:(NSTimeInterval)duration block:(AIAnimationBlock)animation;
+ (instancetype)animationWithDuration:(NSTimeInterval)duration block:(AIAnimationBlock)animation completion:(AICompletionBlock)completion;

- (void)run;
- (UIViewAnimationOptions)options;

- (void)willStartAnimation;
- (void)didStartAnimation;
- (void)didAbortAnimation;
- (void)didFinishAnimation;

@end

//  Created by Alejandro Isaza on 2013-03-26.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.

#import "AIAnimation.h"


@implementation AIAnimation

+ (instancetype)animationWithDuration:(NSTimeInterval)duration block:(AIAnimationBlock)animation {
    AIAnimation* anim = [[AIAnimation alloc] init];
    anim.duration = duration;
    anim.animationBlock = animation;
    return anim;
}

+ (instancetype)animationWithDuration:(NSTimeInterval)duration block:(AIAnimationBlock)animation completion:(AICompletionBlock)completion {
    AIAnimation* anim = [[AIAnimation alloc] init];
    anim.duration = duration;
    anim.animationBlock = animation;
    anim.animationCompletionBlock = completion;
    return anim;
}

- (id)init {
    self = [super init];
    self.easeIn = YES;
    self.easeOut = YES;
    return self;
}

- (void)runWithBlock:(AICompletionBlock) block
{
    if (_setupBlock)
        _setupBlock();

    AIAnimationBlock animationWrapperBlock = ^() {
        [self willStartAnimation];
        if (_animationBlock)
            _animationBlock();
        [self didStartAnimation];
    };

    AICompletionBlock completionWrapperBlock = ^(BOOL finished) {
        if (_animationCompletionBlock)
            _animationCompletionBlock(finished);
        if (finished)
            [self didFinishAnimation];
        else
            [self didAbortAnimation];
        if (block)
            block(finished);
    };

    [UIView animateWithDuration:_duration
                          delay:_delay
                        options:[self options]
                     animations:animationWrapperBlock
                     completion:completionWrapperBlock];
}

- (void)run {
    [self runWithBlock:nil];
}

- (UIViewAnimationOptions)options {
    UIViewAnimationOptions options = (UIViewAnimationOptions) 0;
    if (_easeIn && _easeOut)
        options |= UIViewAnimationOptionCurveEaseInOut;
    else if (_easeIn)
        options |= UIViewAnimationOptionCurveEaseIn;
    else if (_easeOut)
        options |= UIViewAnimationOptionCurveEaseOut;
    else
        options |= UIViewAnimationOptionCurveLinear;
    
    if (_beginFromCurrentState)
        options |= UIViewAnimationOptionBeginFromCurrentState;
    
    if (_repeat)
        options |= UIViewAnimationOptionRepeat;
    
    return options;
}


#pragma mark Animation status methods

- (void)willStartAnimation {
}

- (void)didStartAnimation {
}

- (void)didAbortAnimation {
}

- (void)didFinishAnimation {
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    AIAnimation* copy = [[AIAnimation alloc] init];
    copy.duration = _duration;
    copy.delay = _delay;
    copy.easeIn = _easeIn;
    copy.easeOut = _easeOut;
    copy.beginFromCurrentState = _beginFromCurrentState;
    copy.repeat = _repeat;
    copy.animationBlock = _animationBlock;
    copy.animationCompletionBlock = _animationCompletionBlock;
    return copy;
}

#pragma mark NSOperation

- (void)main {
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [self runWithBlock:^(BOOL finished) {
        dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

@end

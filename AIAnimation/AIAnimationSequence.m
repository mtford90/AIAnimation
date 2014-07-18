//  Created by Alejandro Isaza on 2013-03-26.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.

#import "AIAnimationSequence.h"


@implementation AIAnimationSequence

+ (instancetype)animationSequenceWithAnimations:(NSArray*)animations {
    AIAnimationSequence* anim = [[AIAnimationSequence alloc] init];
    anim.animations = animations;
    return anim;
}

- (void)run {
    if (self.setupBlock)
        self.setupBlock();
    
    _currentAnimationIndex = 0;
    [self willStartAnimation];
    [self animate];
    [self didStartAnimation];
}

- (void)animate {
    if (_currentAnimationIndex >= _animations.count) {
        if (self.animationCompletionBlock)
            self.animationCompletionBlock(YES);
        [self didFinishAnimation];
        return;
    }
    
    AIAnimation* anim = [_animations objectAtIndex:_currentAnimationIndex];
    AIAnimationBlock animationWrapperBlock = ^() {
        if (anim.animationBlock)
            anim.animationBlock();
        [anim didStartAnimation];
    };
    
    AICompletionBlock completionWrapperBlock = ^(BOOL finished) {
        if (anim.animationCompletionBlock)
            anim.animationCompletionBlock(finished);
        if (finished) {
            [anim didFinishAnimation];
            [self _startNextAnimation];
        } else {
            [anim didAbortAnimation];
            if (self.animationCompletionBlock)
                self.animationCompletionBlock(NO);
            [self didAbortAnimation];
        }
    };
    
    if (anim.setupBlock)
        anim.setupBlock();
    
    [UIView animateWithDuration:anim.duration
                          delay:anim.delay
                        options:[anim options]
                     animations:animationWrapperBlock
                     completion:completionWrapperBlock];
}

- (void)_startNextAnimation {
    _currentAnimationIndex += 1;
    
    // Loop if necessary
    if (_currentAnimationIndex >= _animations.count && self.repeat)
        _currentAnimationIndex = 0;
    
    [self animate];
}

@end

//
//  GraphicalEffects.m
//  Ricette-iphone
//
//  Created by Andrea on 07/01/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "GraphicalEffects.h"

@implementation GraphicalEffects

+ (void)fadeOut:(UIView *)viewToDissolve
{
    [GraphicalEffects fadeOut:viewToDissolve withDuration:0.5 andWait:0];
}

+ (void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    
    [UIView setAnimationDelay:wait];
    
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

+ (void)fadeIn:(UIView *)viewToFadeIn
{
    [GraphicalEffects fadeIn:viewToFadeIn withDuration:0.5 andWait:0];
}

+ (void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    [UIView setAnimationDelay:wait];
    
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

@end
//
//  GraphicalEffects.h
//  Ricette-iphone
//
//  Created by Andrea on 07/01/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphicalEffects : NSObject

//Semplice fade out
+ (void)fadeOut:(UIView*)viewToDissolve;
+ (void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;

//semplice fade in
+ (void)fadeIn:(UIView*)viewToFadeIn;
+ (void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;

@end

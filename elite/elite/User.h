//
//  User.h
//  elite
//
//  Created by Andrea Barbieri on 24/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *idfacebook;
@property (strong, nonatomic) NSString *idelite;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *selected;


@end

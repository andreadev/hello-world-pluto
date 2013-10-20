//
//  UserInfoView.h
//  elite
//
//  Created by Andrea Barbieri on 20/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface UserInfoView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *altro;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

- (void)logOut;

@end

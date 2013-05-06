//
//  PreferitiView.h
//  elite
//
//  Created by Andrea Barbieri on 05/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PreferitiView : UITableViewController<FBFriendPickerDelegate>

@property (nonatomic, strong) FBSession * session;

@end

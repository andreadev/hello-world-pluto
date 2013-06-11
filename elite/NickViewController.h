//
//  NickViewController.h
//  elite
//
//  Created by Andrea Barbieri on 18/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface NickViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong) FBSession * session;
@end

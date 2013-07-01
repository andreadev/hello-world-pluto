//
//  PreferitiView.h
//  elite
//
//  Created by Andrea Barbieri on 05/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendCell.h"
#import "TTAlertView.h"
#import "MBProgressHUD.h"

@interface PreferitiView : UITableViewController{
    FriendCell *itemCell;
}

@property (nonatomic, strong) FBSession * session;
@property (strong, nonatomic) IBOutlet FriendCell *itemCell;

@end

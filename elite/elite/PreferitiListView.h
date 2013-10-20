//
//  PreferitiListView.h
//  elite
//
//  Created by Andrea Barbieri on 18/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCell.h"

@interface PreferitiListView : UITableViewController{
FriendCell *itemCell;
}

@property (strong, nonatomic) IBOutlet FriendCell *itemCell;
@property (nonatomic, strong) NSArray *preferiti;

@end

//
//  FindUserView.h
//  elite
//
//  Created by Andrea Barbieri on 28/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCell.h"
#import "TTAlertView.h"

@interface FindUserView : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>{
    
    FriendCell *itemCell;
}

@property (strong, nonatomic) IBOutlet FriendCell *itemCell;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

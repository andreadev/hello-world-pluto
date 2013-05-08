//
//  FriendCell.h
//  elite
//
//  Created by Andrea Barbieri on 07/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell{
UILabel *labelNome;
UIImageView *imageName;
UIButton *follow;
}
@property (nonatomic, strong) IBOutlet UILabel *labelNome;
@property (nonatomic, strong) IBOutlet UIImageView *imageName;
@property (nonatomic, strong) IBOutlet UIButton *follow;

@end

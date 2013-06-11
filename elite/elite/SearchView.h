//
//  SearchView.h
//  elite
//
//  Created by Andrea Barbieri on 14/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "ResultViewController.h"

@interface SearchView : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *categoryText;
@property (weak, nonatomic) IBOutlet UIButton *categoryView;
@property (weak, nonatomic) IBOutlet UIButton *searchBotton;
@property (weak, nonatomic) IBOutlet HomeViewController *rootController;

- (IBAction)search:(id)sender;
- (IBAction)valueChange:(id)sender;
- (IBAction)seeCategory:(id)sender;

@end

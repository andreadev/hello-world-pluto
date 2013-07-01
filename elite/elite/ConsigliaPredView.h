//
//  ConsigliaPredView.h
//  elite
//
//  Created by Andrea Barbieri on 29/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prodotto.h"

@interface ConsigliaPredView : UITableViewController

@property (nonatomic, strong) NSArray *preferiti;
@property (strong, nonatomic) NSString *idprodotto;
@property (strong, nonatomic) Prodotto *prod;

@end

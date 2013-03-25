//
//  ProdottoViewController.h
//  elite
//
//  Created by Andrea Barbieri on 25/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prodotto.h"

@interface ProdottoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageProd;
@property (strong, nonatomic) Prodotto *prod;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *where;
@property (weak, nonatomic) IBOutlet UILabel *prezzo;
@property (weak, nonatomic) IBOutlet UILabel *oldprezzo;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UITextView *descrizione;
@property (weak, nonatomic) IBOutlet UILabel *codice;

@end

//
//  Prodotto.h
//  elite
//
//  Created by Andrea Barbieri on 25/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prodotto : NSObject{
    NSString *name;
    NSString *where;
    NSString *prezzo;
    NSString *oldprezzo;
    NSString *codice;
    NSString *categoria;
    NSString *desc;
    NSString *urlfoto;
    NSString *consigliato;
    NSString *idprodotto;
    NSString *distance;
    NSString *address;
    NSString *privateCodeValue;
    NSString *myCodeValue;
}

@property (strong, nonatomic) NSString *idprodotto;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *where;
@property (strong, nonatomic) NSString *prezzo;
@property (strong, nonatomic) NSString *oldprezzo;
@property (strong, nonatomic) NSString *codice;
@property (strong, nonatomic) NSString *categoria;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *urlfoto;
@property (strong, nonatomic) NSString *consigliato;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *privateCodeValue;
@property (strong, nonatomic) NSString *myCodeValue;





@end

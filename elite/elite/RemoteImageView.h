//
//  RemoteImage.h
//  Ricette-iphone
//
//  Created by Andrea on 07/01/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImageView (RemoteImageView)

- (void)setImageFromUrl: (NSURL*)url;

- (void)setImageFromUrl: (NSURL*)url defaultImage: (UIImage*)defaultImage;


- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage  andId:(NSString *)idAlbum;

//imposta l'immagine da un url eseguendo ad operazione conclusa un blocco di codice. L'immagine viene
//impostata solo se il blocco ritorna TRUE
- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage completionBlock: (BOOL (^)(UIImage *image)) block;

- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage forceSize:(CGSize)size;

- (void)setAlbumFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage;

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;

- (void)setCoverFromUrl:(NSURL *)url reflectView:(UIImageView *) reflectView;

- (void)setCoverFromImage:(UIImage *)imageCover reflectView:(UIImageView *) reflectView;

//Imposta un'immagine a partire dal preview id, usando e aggiornando la cache
//- (void)setImageFromPreviewId:(NSString*)previewId defaultImage: (UIImage*)defaultImage  completionBlock: (BOOL (^)(UIImage *image)) block;

//fa apparire l'immagine con una dissolvenza
- (void)setImageWithDissolve:(UIImage*)_image;

@end
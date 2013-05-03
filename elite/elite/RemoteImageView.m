//
//  RemoteImage.m
//  Ricette-iphone
//
//  Created by Andrea on 07/01/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//
#import "RemoteImageView.h"
#import "GraphicalEffects.h"
#import <QuartzCore/QuartzCore.h>
//#import "RemoteDataPreviewImage.h"
//#import "PreviewImageCaching.h"


@implementation UIImageView (RemoteImageView)


- (id)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

- (UIImage*)imageByScaling: (UIImage*)sourceImage size:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //else NSLog(@"Image size %@ // target size %@", NSStringFromCGSize(newImage.size), NSStringFromCGSize(targetSize));
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setImageFromUrl:(NSURL *)url
{
    [self setImageFromUrl:url defaultImage:nil];
}

- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage
{
    
    /*self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    self.layer.frame = CGRectMake(5, 5, 70, 70);*/
    [self setImage: defaultImage];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@ pre", NSStringFromCGRect(self.frame));
        UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url ]];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0);
        
        if([imgData length]<50)
            return;
        
        __block UIImage *resizedImage = [self imageByScaling:image size:self.frame.size];
        
        
        //Eseguo sul thread principale
        dispatch_async( dispatch_get_main_queue(), ^{
            
            self.image = resizedImage;
            self.alpha = 0;
            
            [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
        });
        
    });
    
    
    
}

- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage forceSize:(CGSize)size
{
    
    
    //[self setImage: defaultImage];
    
    __block CGRect oldFrame = self.frame;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@ pre", NSStringFromCGRect(self.frame));
        UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url ]];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0);
        
        if([imgData length]<50)
            image = defaultImage;
        
        __block UIImage *resizedImage = [self imageByScaling:image size:size];
        
        
        //Eseguo sul thread principale
        dispatch_async( dispatch_get_main_queue(), ^{
            
            self.image = resizedImage;
            self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, size.width, size.height);
            self.alpha = 0;
            
            [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
        });
        
    });
    
    
    
}

- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage  completionBlock: (BOOL (^)(UIImage *image)) block
{
    [self setImage: defaultImage];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url ]];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0);
        
        if([imgData length]<50)
            return;
        
        __block UIImage *resizedImage = [self imageByScaling:image size:self.frame.size ];
        
        //Eseguo sul thread principale
        dispatch_async( dispatch_get_main_queue(), ^{
            
            
            
            if (block(resizedImage))
            {
                self.image = resizedImage;
                self.alpha = 0;
                [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
            }
            
            
            
        });
        
    });
    
    
    
    
}

/*- (void)setImageFromPreviewId:(NSString*)previewId defaultImage: (UIImage*)defaultImage  completionBlock: (BOOL (^)(UIImage *image)) block
{
    [self setImage: defaultImage];
    
    
     *  Controllo se è in cache
     */
    /*__block UIImage *cachedImage = nil;
    if ((cachedImage = [PreviewImageCaching previewImage:previewId]))
    {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            NSData *imgData = UIImageJPEGRepresentation(cachedImage, 0);
            
            if([imgData length]<50)
                return;
            
            __block UIImage *resizedImage = [self imageByScaling:cachedImage size:self.frame.size];
            
            //Eseguo sul thread principale
            dispatch_async( dispatch_get_main_queue(), ^{
                
                if (block(resizedImage))
                {
                    self.image = resizedImage;
                    self.alpha = 0;
                    [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
                }
                
            });
        });
        
    }
    else
    {
        
     
         *  altrimenti Eeguo il fetch
         */
      /*  dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            __block UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[RDPreviewImage imageUrlWithPreviewId:previewId] ]];
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0);
            
            if([imgData length]<50)
                return;
            
            
            __block UIImage *resizedImage = [self imageByScaling:image size:self.frame.size ];
            
            //Eseguo sul thread principale
            dispatch_async( dispatch_get_main_queue(), ^{
                
                if (block(resizedImage))
                {
                    [PreviewImageCaching storeImage:image withPreviewId:previewId];
                    self.image = resizedImage;
                    self.alpha = 0;
                    [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
                }
                
            });
            
        });
        
    }
    
}*/

- (void)setImageWithDissolve:(UIImage*)_image
{
    self.image = _image;
    self.alpha = 0;
    [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
    
}

@end
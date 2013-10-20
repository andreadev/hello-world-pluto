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
        //NSLog(@"could not scale image");
    //else //NSLog(@"Image size %@ // target size %@", NSStringFromCGSize(newImage.size), NSStringFromCGSize(targetSize));
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
    //[self setImage: defaultImage];
    //NSLog(@"%@", url);
    
    UIImage *blur1 = [UIImage imageNamed:@"girandola1"];
    UIImage *blur2 = [UIImage imageNamed:@"girandola2"];
    UIImage *blur3 = [UIImage imageNamed:@"girandola3"];
    UIImage *blur4 = [UIImage imageNamed:@"girandola4"];
    UIImage *blur5 = [UIImage imageNamed:@"girandola5"];
    UIImage *blur6 = [UIImage imageNamed:@"girandola6"];
    UIImage *blur7 = [UIImage imageNamed:@"girandola7"];
    UIImage *blur8 = [UIImage imageNamed:@"girandola8"];
    
    self.animationImages = [[NSArray alloc] initWithObjects:blur1,blur2,blur3,blur4,blur5,blur6,blur7,blur8, nil];
    self.animationRepeatCount = 5;
    self.animationDuration = 1.2;
    
    [self startAnimating];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSLog(@"%@ pre", NSStringFromCGRect(self.frame));
        UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url ]];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0);
        
        if([imgData length]<50)
            return;
        
        //__block UIImage *resizedImage = [self imageByScaling:image size:self.frame.size];
        UIImage *resizedImage = [self imageWithImage:image scaledToSize:self.frame.size];
        /*CGRect *rect = CGRectMake(rect.origin.x,
                          rect.origin.y,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], self.frame.size);*/
        // or use the UIImage wherever you like        
        //Eseguo sul thread principale
        dispatch_async( dispatch_get_main_queue(), ^{
            //NSLog(@"CENTRO");
            self.image = resizedImage;
            self.alpha = 0;
            
           self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin);
            
            [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
        });
        
    });
    
}

- (void)setCoverFromUrl:(NSURL *)url reflectView:(UIImageView *) reflectView
{
    
    /*self.layer.cornerRadius = 10.0;
     self.layer.masksToBounds = YES;
     self.layer.frame = CGRectMake(5, 5, 70, 70);*/
    //[self setImage: defaultImage];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSLog(@"%@ pre", NSStringFromCGRect(self.frame));
        UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url ]];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0);
        
        if([imgData length]<50)
            return;
        
        //__block UIImage *resizedImage = [self imageByScaling:image size:self.frame.size];
        UIImage *resizedImage = [self imageWithImage:image scaledToSize:self.frame.size];
        /*CGRect *rect = CGRectMake(rect.origin.x,
         rect.origin.y,
         rect.size.width * self.scale,
         rect.size.height * self.scale);
         
         CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], self.frame.size);*/
        // or use the UIImage wherever you like
        //Eseguo sul thread principale
        dispatch_async( dispatch_get_main_queue(), ^{
            
            self.image = resizedImage;
            
            
            
            self.alpha = 0;
            
            //self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin);
            
            [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
            
            reflectView.image = [self reflectedImage:self withHeight:230];
        });
        
    });
    
}

- (void)setCoverFromImage:(UIImage *)imageCover reflectView:(UIImageView *) reflectView
{
    
    UIImage *resizedImage = [self imageWithImage:imageCover scaledToSize:self.frame.size];

    self.image = resizedImage;
            
    self.alpha = 0.9;
            
    //self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin);
            
    //[GraphicalEffects fadeIn:self withDuration:0.0 andWait:0];
            
    reflectView.image = [self reflectedImage:self withHeight:230];
}

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height
{
    if(height == 0)
		return nil;
    
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
	CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, 0.0, height);
	CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.image.CGImage);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
	CGImageRef theCGImage = NULL;
    
	// gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
															   8, 0, colorSpace, kCGImageAlphaNone);
	
	// define the start and end grayscale values (with the alpha, even though
	// our bitmap context doesn't support alpha the gradient requires it)
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	// create the CGGradient and then release the gray color space
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	// create the start and end points for the gradient vector (straight down)
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
	
	// draw the gradient into the gray bitmap context
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// convert the context into a CGImageRef and release the context
	theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
	// return the imageref containing the gradient
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
														0, colorSpace,
														// this will give us an optimal BGRA format for the device:
														(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}


-(UIImage*)imageWithShadowForImage:(UIImage *)initialImage {
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, initialImage.size.width + 10, initialImage.size.height + 10, CGImageGetBitsPerComponent(initialImage.CGImage), 0, colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(0,0), 5, [UIColor blackColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(5, 5, initialImage.size.width, initialImage.size.height), initialImage.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

- (void)setAlbumFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage
{
    
    /*self.layer.cornerRadius = 10.0;
     self.layer.masksToBounds = YES;
     self.layer.frame = CGRectMake(5, 5, 70, 70);*/
    //[self setImage: defaultImage];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSLog(@"%@ pre", NSStringFromCGRect(self.frame));
        UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url ]];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0);
        
        if([imgData length]<50){
            
            dispatch_async( dispatch_get_main_queue(), ^{
                [self setImage: defaultImage];
                
            });
            return;
        }
        
        //__block UIImage *resizedImage = [self imageByScaling:image size:self.frame.size];
        
        /*CGRect *rect = CGRectMake(rect.origin.x,
         rect.origin.y,
         rect.size.width * self.scale,
         rect.size.height * self.scale);
         
         CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], self.frame.size);*/
        // or use the UIImage wherever you like
        //Eseguo sul thread principale
        dispatch_async( dispatch_get_main_queue(), ^{
            
            self.image = image;
            self.alpha = 0;
            
            self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin);
            
            [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
        });
        
    });
    
}


- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage  andId:(NSString *)idAlbum
{
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *jpgFilePath = [NSString stringWithFormat:@"%@/cacheProd/%@.jpg", docDir, idAlbum];
    //NSData *data1 = [[NSData alloc] initWithContentsOfFile:pngFilePath];
    
    if ([fileManager fileExistsAtPath:jpgFilePath]){
        
        self.image = [self imageWithImage:[UIImage imageWithContentsOfFile:jpgFilePath] scaledToSize:CGSizeMake(45, 45)];
    }
    else{
        [self setImage:defaultImage];
        UIImage *blur1 = [UIImage imageNamed:@"girandola1"];
        UIImage *blur2 = [UIImage imageNamed:@"girandola2"];
        UIImage *blur3 = [UIImage imageNamed:@"girandola3"];
        UIImage *blur4 = [UIImage imageNamed:@"girandola4"];
        UIImage *blur5 = [UIImage imageNamed:@"girandola5"];
        UIImage *blur6 = [UIImage imageNamed:@"girandola6"];
        UIImage *blur7 = [UIImage imageNamed:@"girandola7"];
        UIImage *blur8 = [UIImage imageNamed:@"girandola8"];
        
        self.animationImages = [[NSArray alloc] initWithObjects:blur1,blur2,blur3,blur4,blur5,blur6,blur7,blur8, nil];
        self.animationRepeatCount = 5;
        self.animationDuration = 1.2;
        
        [self startAnimating];
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //NSLog(@"%@ pre", NSStringFromCGRect(self.frame));
            UIImage* image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url ]];
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0);
            
            if([imgData length]<50){
                /*dispatch_async( dispatch_get_main_queue(), ^{
                    [self setImage:defaultImage];
                });*/
                return;
            }
            
            //NSLog(@"SCARICO IMMAGINE");
            
            //__block UIImage *resizedImage = [self imageByScaling:image size:self.frame.size];
            UIImage *resizedImage = [self imageWithImage:image scaledToSize:CGSizeMake(45, 45)];
            
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(resizedImage)];
            [data1 writeToFile:jpgFilePath atomically:YES];
            
            //Eseguo sul thread principale
            dispatch_async( dispatch_get_main_queue(), ^{
                //NSLog(@"ASSEGNO ");
                [self stopAnimating];
                self.image = resizedImage;
                self.alpha = 0;
                
                self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin);
                
                [GraphicalEffects fadeIn:self withDuration:0.2 andWait:0];
            });
            
        });
        
        
    }
   
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setImageFromUrl:(NSURL *)url defaultImage: (UIImage*)defaultImage forceSize:(CGSize)size
{
    
    
    //[self setImage: defaultImage];
    
    __block CGRect oldFrame = self.frame;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSLog(@"%@ pre", NSStringFromCGRect(self.frame));
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
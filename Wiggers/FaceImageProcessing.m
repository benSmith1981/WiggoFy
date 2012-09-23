//
//  ImageProcessing.m
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceImageProcessing.h"

@implementation FaceImageProcessing
@synthesize activeFacePart,features,doneEditing,objectMoving,activeImageView;

-(void)initialiseImages:(NSDictionary*)images withArrayOfFaceParts:(NSArray*)arrayOfFaceParts withCanvas:(UIView*)canvasParam withImageView:(UIImageView*)imageView{
    //features = [[NSArray alloc]initWithArray:featuresParam];
    doneEditing = FALSE;
    objectMoving = FALSE;
    imagesToAdd = [[NSDictionary alloc]initWithDictionary:images];
    arrayOfImagesToAdd = [[NSArray alloc]initWithArray:arrayOfFaceParts];
    canvas = canvasParam;
    activeImageView = imageView;
}

+(void)processFace:(UIImage*)faceImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        CIImage *imageToScan = [[CIImage alloc]initWithImage:faceImage];
        
        NSString *accuracy = CIDetectorAccuracyHigh;
        NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
        
        
        NSArray *features = [detector featuresInImage:imageToScan];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithObject:features forKey:@"features"]; 
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:@"featuresNotification" 
             object:self userInfo:dict];
        });
        
    });  

}


#pragma mark - DrawImage    
-(UIImageView*)drawImageAnnotatedWithFeatures{
    
    UIImage *faceImage = activeImageView.image;
    UIGraphicsBeginImageContextWithOptions(faceImage.size, YES, 0);
    [faceImage drawInRect: activeImageView.bounds];
    
    // Get image context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip Context
    CGContextTranslateCTM(context, 0, activeImageView.bounds.size.height);
//    CGCGContextTranslateCTM(context, 0, [features objectAtIndex:0].frame.size.height)
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    

    if (scale > 1.0) {
        // Loaded 2x image, scale context to 50%
        CGContextScaleCTM(context, 0.5, 0.5);
    }
    

    
    //add Face features ontop of the main image from camera
    for (CIFaceFeature *feature in features)
    {

        NSLog(@"feature.bounds.size.width %f",feature.bounds.size.width);
        NSLog(@"feature.bounds.size.height %f",feature.bounds.size.height);
        NSLog(@"feature.bounds.origin.x %f",feature.bounds.origin.x);
        NSLog(@"feature.bounds.origin.y %f",feature.bounds.origin.y);
        if (feature.hasLeftEyePosition) 
        {
            //hair.frame = CGRectMake(f.bounds.origin.x-25, f.bounds.origin.y-20, hair.image.size.width, hair.image.size.height);
            
            //            leftSB.frame = CGRectMake(feature.leftEyePosition.x, feature.leftEyePosition.y-(leftSB.image.size.height/2)-20, leftSB.image.size.width, leftSB.image.size.height);
            //leftSB.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
            
            //NSLog(@"leftSB.image.size.width %f  leftSB.image.size.height %f",leftSB.image.size.width,leftSB.image.size.height);
        }
        
        if (feature.hasRightEyePosition) 
        {
            //            rightSB.frame = CGRectMake(feature.rightEyePosition.x+20, feature.rightEyePosition.y-(rightSB.image.size.height/2)-20, rightSB.image.size.width, rightSB.image.size.height);
            
            //NSLog(@"rightSB.image.size.width %f  rightSB.image.size.height %f",rightSB.image.size.width,rightSB.image.size.height);
        }
        
        if (feature.hasMouthPosition) {
            //[self drawFeature:3 InContext:context atPoint:feature.mouthPosition];
        }
    }
    
    //Add hair
    for (CIFaceFeature *feature in features){
        CIFaceFeature *f = feature;
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2.0f * scale);
        CGContextAddRect(context, f.bounds);
        CGContextDrawPath(context, kCGPathFillStroke);

        //hair.frame = CGRectMake(f.bounds.origin.x-25, f.bounds.origin.y-20, hair.image.size.width, hair.image.size.height);

        UIImageView *hair = [imagesToAdd objectForKey:kHairKey];
        //scales image up so it is 1/6th larger than face area
        hair.image = [hair.image imageByScalingProportionallyToSize: CGSizeMake(f.bounds.size.width + f.bounds.size.width/6, f.bounds.size.height + f.bounds.size.height/6)];
        
        hair.frame = CGRectMake(f.bounds.origin.x-f.bounds.size.width/8.5, f.bounds.origin.y-f.bounds.size.height/4, hair.image.size.width,hair.image.size.height);
                                
                                //+f.bounds.size.width/6, hair.image.size.height+f.bounds.size.height/6);
//        hair.image = [hair.image imageRotatedByDegrees:45.0f];
        //CGPoint faceCentre = CGPointMake(f.bounds.size.width, f.bounds.size.height);
        //[hair setCenter:faceCentre];
//        NSLog(@"f.bounds.size.width %f",f.bounds.size.width);
//        NSLog(@"f.bounds.size.height %f",f.bounds.size.height);
//        NSLog(@"f.bounds.origin.x %f",f.bounds.origin.x);
//        NSLog(@"f.bounds.origin.y %f",f.bounds.origin.y);
        
        UIImageView *leftSB = [imagesToAdd objectForKey:kleftSBKey];
        leftSB.image = [leftSB.image imageByScalingProportionallyToSize:CGSizeMake(f.bounds.size.width/10, f.bounds.size.height/3)];
        leftSB.frame = CGRectMake(leftSB.frame.size.width, leftSB.frame.size.height, leftSB.image.size.width+f.bounds.size.width/10, leftSB.image.size.height+f.bounds.size.height/4);
        //CGPoint leftSBCentre = CGPointMake(f.bounds.origin.x+30, f.bounds.size.height/2 + f.bounds.origin.y+60);
        //[leftSB setCenter:leftSBCentre];
        
        UIImageView *rightSB = [imagesToAdd objectForKey:krightSBKey];
        rightSB.image = [rightSB.image imageByScalingProportionallyToSize:CGSizeMake(f.bounds.size.width/3, f.bounds.size.height/2)];
        rightSB.frame = CGRectMake( f.bounds.origin.x+f.bounds.size.width - rightSB.frame.size.width,  f.bounds.origin.y+f.bounds.size.height - rightSB.frame.size.height,  f.bounds.size.width/3, f.bounds.size.height/2);
        //CGRectMake(rightSB.frame.size.width, rightSB.frame.size.height, f.bounds.size.width-rightSB.image.size.width, f.bounds.size.height-rightSB.image.size.height);
        //CGPoint rightSBCentre = CGPointMake(f.bounds.size.width+f.bounds.origin.x-30, f.bounds.size.height/2 + f.bounds.origin.y+60);
        //[rightSB setCenter:rightSBCentre];
        
    }
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //jumper.frame = CGRectMake(0, canvas.frame.size.height-93, 320, 93);
    //    jumper.frame = CGRectMake(0, IMG_HEIGHT-jumper.frame.size.height, self.activeImageView.image.size.width, jumper.frame.size.height);
    //    [self.view addSubview:jumper];
//    self.activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return activeImageView;
}


//this is called when the save image button is pressed
-(void)setImage{ //View:(UIImageView*)activeImageView withFeatures:(NSArray*)features OnCanvas:(UIView*)canvas{
    UIImage *faceImage = activeImageView.image;
    
    NSString *wiggoText = @"#Wiggo'fyed!";
    CGSize theSize = [wiggoText sizeWithFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40] constrainedToSize:activeImageView.frame.size lineBreakMode:UILineBreakModeMiddleTruncation];
    faceImage = [self drawText:wiggoText inImage:faceImage atPoint:CGPointMake((activeImageView.frame.size.width-theSize.width)/2,activeImageView.image.size.height-theSize.height)];

    
    UIGraphicsBeginImageContextWithOptions(faceImage.size, YES, 0);
    [faceImage drawInRect:activeImageView.bounds];
    
    // Get image context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip Context
    CGContextTranslateCTM(context, 0, activeImageView.bounds.size.height);
    CGContextScaleCTM(context, _lastScale, _lastScale);
    
    CGFloat scale = _lastScale;
    
    if (scale > 1.0) {
        // Loaded 2x image, scale context to 50%
        CGContextScaleCTM(context, 0.5, 0.5);
    }
    
    
    //This is the important code to add the face parts to the image
    for (UIImageView *facePart in features) {
        //[self.activeImageView addSubview:facePart];
    }
    
    [activeImageView addSubview:[imagesToAdd objectForKey:kHairKey]];
    [activeImageView addSubview:[imagesToAdd objectForKey:kleftSBKey]];
    [activeImageView addSubview:[imagesToAdd objectForKey:krightSBKey]];
    //[self.activeImageView addSubview:jumper];
    
    //render it into the activeImageView then we can post or whatever
    [activeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    activeImageView.image = [self dumpOverlayViewToImage];//]:activeImageView];
    activeFacePart = nil;
    
    
}

- (void)drawFeature:(int)feature InContext:(CGContextRef)contextLocal atPoint:(CGPoint)featurePoint {
    
    UIImageView *leftSB = [imagesToAdd objectForKey:kleftSBKey];
    UIImageView *rightSB  =[imagesToAdd objectForKey:krightSBKey];
    switch (feature) {
        case 1:
            leftSB.frame = CGRectMake(featurePoint.x-50, featurePoint.y-(leftSB.image.size.height/2)-20, leftSB.image.size.width, leftSB.image.size.height);
            //[self.view addSubview:leftSB];
            break;
        case 2:
            rightSB.frame = CGRectMake(featurePoint.x+20, featurePoint.y-(rightSB.image.size.height/2)-20, rightSB.image.size.width, rightSB.image.size.height);
            //[self.view addSubview:rightSB];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    
    //    CGFloat radius = 20.0f * [UIScreen mainScreen].scale;
    //    CGContextAddArc(context, featurePoint.x, featurePoint.y, radius, 0, M_PI * 2, 1);
    //    CGContextDrawPath(context, kCGPathFillStroke);
}

/*To add an overlay image to the camera image you must specify the overlay image here
 */
- (UIImage*)dumpOverlayViewToImage{ //:(UIImageView*)activeImageView {
	CGSize imageSize = activeImageView.bounds.size;
	//CGSize imageSize = CGSizeMake(IMG_WIDTH, IMG_HEIGHT);
	UIGraphicsBeginImageContext(imageSize);
	[activeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return viewImage;
}

/*Pass in the base image from the camera here
 */
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage {
    UIImage* result;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        UIImage *overlayImageLocal = [self dumpOverlayViewToImage];
        CGPoint topCorner = CGPointMake(_firstX, _firstY);
        
        CGSize targetSize = CGSizeMake(IMG_WIDTH_NO_ADS, IMG_HEIGHT_NO_ADS);	
        CGRect scaledRect = CGRectZero;
        
        CGFloat scaledX = IMG_HEIGHT_NO_ADS * baseImage.size.width / baseImage.size.height;
        CGFloat offsetX = (scaledX - IMG_WIDTH_NO_ADS) / -2;
        
        scaledRect.origin = CGPointMake(offsetX, 0.0);
        scaledRect.size.width  = scaledX;
        scaledRect.size.height = IMG_HEIGHT_NO_ADS;
        
        UIGraphicsBeginImageContext(targetSize);	
        [baseImage drawInRect:scaledRect];	
        [overlayImageLocal drawAtPoint:topCorner];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();	
    }
    else {
        UIImage *overlayImageLocal = [self dumpOverlayViewToImage];	
        CGPoint topCorner = CGPointMake(_firstX, _firstY);
        
        CGSize targetSize = CGSizeMake(IMG_WIDTH, IMG_HEIGHT);	
        CGRect scaledRect = CGRectZero;
        
        CGFloat scaledX = IMG_HEIGHT * baseImage.size.width / baseImage.size.height;
        CGFloat offsetX = (scaledX - IMG_WIDTH) / -2;
        
        scaledRect.origin = CGPointMake(offsetX, 0.0);
        scaledRect.size.width  = scaledX;
        scaledRect.size.height = IMG_HEIGHT;
        
        UIGraphicsBeginImageContext(targetSize);	
        [baseImage drawInRect:scaledRect];	
        [overlayImageLocal drawAtPoint:topCorner];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
	
	return result;	
}

- (UIImage*) drawText:(NSString*) text 
              inImage:(UIImage*)  image 
              atPoint:(CGPoint)   point 
{
    // Get image context reference
    
    
    UIFont *font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:40];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    //CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor redColor] set];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(M_PI/ -4);
//    CGContextSaveGState(context);
//    CGContextConcatCTM(context, rotateTransform);
    [text drawAtPoint:point withFont:font];	
//    CGContextRestoreGState(context);
    //[text drawInRect:CGRectIntegral(rect) withFont:font];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //newImage = [newImage imageRotatedByDegrees:45.0f];
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

#pragma mark - Manipulate Image

-(void)showOverlayWithFrame:(CGRect)frame withMarque:(CAShapeLayer*)_marque{
    
    if (![_marque actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.5f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [_marque addAnimation:dashAnimation forKey:@"linePhase"];
    }
//    self.xCoord.text = [NSString stringWithFormat:@"%f", _firstX];
//    self.yCoord.text = [NSString stringWithFormat:@"%f", _firstY];
    
    _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    _marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    [_marque setPath:path];
    CGPathRelease(path);
    
    _marque.hidden = NO;
    
}

-(void)scale:(id)sender withView:(UIView*)view{
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = activeFacePart.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [activeFacePart setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
//    self.height.text = [NSString stringWithFormat:@"%f", activeFacePart.frame.size.height];
//    self.width.text = [NSString stringWithFormat:@"%f", activeFacePart.frame.size.width];
    
    
}

-(void)rotate:(id)sender withView:(UIView*)view{
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    //NSLog(@"rotation %f",rotation);
//    self.rotationLabel.text = [NSString stringWithFormat:@"%f", rotation];
    CGAffineTransform currentTransform = activeFacePart.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [activeFacePart setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}


-(void)move:(id)sender withView:(UIView*)view{
    
    CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:view];
    for (UIImageView *facePart in arrayOfImagesToAdd) {
        if (CGRectContainsPoint(facePart.frame, touchPoint) && !objectMoving)
        {
            activeFacePart = facePart;
        }
    }
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [activeFacePart center].x;
        _firstY = [activeFacePart center].y;
        
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [activeFacePart setCenter:translatedPoint];

}



@end

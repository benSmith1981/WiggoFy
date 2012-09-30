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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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
-(NSMutableArray*)drawFeaturesAnnotatedWithImageViews:(NSMutableArray *)imageViews{
    
    NSMutableArray *faceFeatures = [[NSMutableArray alloc]init];
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
//    for (CIFaceFeature *feature in features)
//    {
//        if (feature.hasLeftEyePosition) 
//        {
//
//        }
//        
//        if (feature.hasRightEyePosition) 
//        {
//
//        }
//        
//        if (feature.hasMouthPosition) {
//
//        }
//    }
    
    //Add hair
    //int face = 0;
    for (CIFaceFeature *feature in features){
        CIFaceFeature *f = feature;
//        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        CGContextSetLineWidth(context, 2.0f * scale);
//        CGContextAddRect(context, f.bounds);
//        CGContextDrawPath(context, kCGPathFillStroke);

        //Setup the hair and sideburns that are intially drawn onto the image
        UIImageView *hair = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[FACE_IMAGE_NAMES objectAtIndex:0]]];
        faceFeature *tempFaceFeature = [self drawFeature:f ofType:hairType withImage:hair atPoint:f.bounds.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *leftSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[FACE_IMAGE_NAMES objectAtIndex:4]]];
        tempFaceFeature = [self drawFeature:f ofType:leftSBType withImage:leftSB atPoint:f.bounds.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *rightSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[FACE_IMAGE_NAMES objectAtIndex:5]]];
        tempFaceFeature = [self drawFeature:f ofType:rightSBType withImage:rightSB atPoint:f.bounds.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];


        
    }
    
    //place holder faceFeature instances for objects not drawn that we want to show later
//    faceFeature *placeHolder1 = [[faceFeature alloc]init];
//    [placeHolder1 setType:jumperType];
//    [faceFeatures addObject:placeHolder1];
//    
//    faceFeature *placeHolder2 = [[faceFeature alloc]init];
//    [placeHolder2 setType:medalType];
//    [faceFeatures addObject:placeHolder2];
    
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return faceFeatures;
}


//this is called when the save image button is pressed
-(void)setImageWithImageViews:(NSMutableArray*)faceFeatures{ //View:(UIImageView*)activeImageView withFeatures:(NSArray*)features OnCanvas:(UIView*)canvas{
    UIImage *faceImage = activeImageView.image;
    
    NSString *wiggoText = @"#WiggoFied!";
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
    
    
    
    for (faceFeature *faceparts in faceFeatures) {
        [activeImageView addSubview:faceparts.featureImageView];
    }
//    [activeImageView addSubview:[imageViews objectAtIndex:0]];
//    [activeImageView addSubview:[imageViews objectAtIndex:1]];
//    [activeImageView addSubview:[imageViews objectAtIndex:2]];
    //[self.activeImageView addSubview:jumper];
    
    //render it into the activeImageView then we can post or whatever
    [activeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    activeImageView.image = [self dumpOverlayViewToImage];//]:activeImageView];
    activeFacePart = nil;
    
    
}


- (faceFeature*)drawFeature:(CIFaceFeature*)f ofType:(faceFeatureType)featureType withImage:(UIImageView*)imageView atPoint:(CGPoint)featurePoint {

    CGFloat leftSBScaleWidth = f.bounds.size.width*1/4;
    CGFloat leftSBScaleHeight = f.bounds.size.height*1/1.8;
    CGFloat rightSBScaleWidth = f.bounds.size.width*1/4;
    CGFloat rightSBScaleHeight = f.bounds.size.height*1/1.8;
    
    faceFeature *newFaceFeature = [[faceFeature alloc]init];
    switch (featureType) {
        case 1:// left eye

            break;
        case 2:// right eye

            break;
        case 3:// mouth
            
            break;
        case 4://hair
            imageView.image = [imageView.image imageByScalingProportionallyToSize: CGSizeMake(f.bounds.size.width + f.bounds.size.width/4, f.bounds.size.height + f.bounds.size.height/6)];
            imageView.frame = CGRectMake(f.bounds.origin.x-f.bounds.size.width/8.5, IMG_HEIGHT - (f.bounds.origin.y + f.bounds.size.height + f.bounds.size.height/2 ), imageView.image.size.width,imageView.image.size.height);
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            newFaceFeature.featureBelongsToo = f;
            //[imageView setType:featureType];
            break;
        case 5:// right sideburn
            imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(leftSBScaleWidth,leftSBScaleHeight)];
//            imageView.frame = CGRectMake(f.bounds.origin.x, IMG_HEIGHT - (f.bounds.origin.y + imageView.frame.size.height), imageView.image.size.width, imageView.image.size.height);
            imageView.frame = CGRectMake(f.bounds.origin.x, IMG_HEIGHT - (f.bounds.origin.y + imageView.image.size.height + f.bounds.size.height/4), imageView.image.size.width, imageView.image.size.height);
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            newFaceFeature.featureBelongsToo = f;

            
            break;
        case 6:// left sideburn
            imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(rightSBScaleWidth, rightSBScaleHeight)];
//            imageView.frame = CGRectMake(f.bounds.origin.x + f.bounds.size.width - imageView.frame.size.width, IMG_HEIGHT - (f.bounds.origin.y + imageView.frame.size.height),  imageView.image.size.width, imageView.image.size.height );
            imageView.frame = CGRectMake(f.bounds.origin.x + f.bounds.size.width - imageView.image.size.width, IMG_HEIGHT - (f.bounds.origin.y + imageView.image.size.height + f.bounds.size.height/4),  imageView.image.size.width, imageView.image.size.height );
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            newFaceFeature.featureBelongsToo = f;

            break;
        case 7:// yellowJumper
            imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(canvas.bounds.size.width,imageView.frame.size.height)];
            imageView.frame = CGRectMake(canvas.bounds.origin.x, IMG_HEIGHT - (canvas.bounds.origin.y + imageView.frame.size.height), imageView.image.size.width, imageView.image.size.height);
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            newFaceFeature.featureBelongsToo = f;
            break;
        case 8:// medal
            imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(imageView.frame.size.width,f.bounds.size.height)];
            imageView.frame = CGRectMake(canvas.bounds.origin.x, IMG_HEIGHT - (canvas.bounds.origin.y + imageView.frame.size.height), imageView.image.size.width, imageView.image.size.height);
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            newFaceFeature.featureBelongsToo = f;

            break;
        default:
            break;
    }
    return newFaceFeature;
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


-(void)move:(id)sender withView:(UIView*)view withEditedFaceFeatures:(NSMutableArray*)editedFaceFeatureParam{
    
    CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:view];
    for (faceFeature *facePart in editedFaceFeatureParam) {
        if (CGRectContainsPoint(facePart.featureImageView.frame, touchPoint) && !objectMoving)
        {
            activeFacePart = facePart.featureImageView;
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

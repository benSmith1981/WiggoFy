//
//  ImageProcessing.h
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Extensions.h"



@interface FaceImageProcessing :NSObject {
    NSArray *features;
    NSArray *arrayOfImagesToAdd;
    NSDictionary *imagesToAdd;
    UIImageView *activeImageView;
    UIView *canvas;
    
    
    CGFloat _lastScale;
	CGFloat _lastRotation;
	CGFloat _firstX;
	CGFloat _firstY;
    
    UIImageView *activeFacePart;
    BOOL objectMoving;
    //Marque round selected image part
    //CAShapeLayer *_marque;
    
    //Has editing been done
    BOOL doneEditing;
    

}
@property(nonatomic,strong)UIImageView *activeImageView;
@property(nonatomic,strong)UIImageView *activeFacePart;
@property(nonatomic,strong)NSArray *features;
@property(nonatomic)BOOL doneEditing;
@property(nonatomic)BOOL objectMoving;

//@property(nonatomic,strong)NSDictionary *imagesToAdd;
+(void)processFace:(UIImage*)faceImage;
-(void)initialiseImages:(NSDictionary*)images withArrayOfFaceParts:(NSArray*)arrayOfFaceParts withCanvas:(UIView*)canvasParam withImageView:(UIImageView*)imageView;
-(NSMutableArray*)drawFeaturesAnnotatedWithImageViews:(NSMutableArray *)imageViews;
- (UIImage*) drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point;
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage;
- (UIImage*)dumpOverlayViewToImage;//:(UIImageView*)activeImage;
//- (void)drawFeature:(int)feature InContext:(CGContextRef)contextLocal atPoint:(CGPoint)featurePoint;
- (UIImageView*)drawFeature:(CIFaceFeature*)f ofType:(faceFeatureType)featureType withImage:(UIImageView*)imageView InContext:(CGContextRef)contextLocal atPoint:(CGPoint)featurePoint;
//this is called when the save image button is pressed
-(void)setImageWithImageViews:(NSMutableArray*)imageViews;//View:(UIImageView*)activeImageView withFeatures:(NSArray*)features OnCanvas:(UIView*)canvas;
//- (UIImageView*)drawImage:(UIImageView*)image AnnotatedWithFeatures:(NSArray*)features;

-(void)showOverlayWithFrame:(CGRect)frame withMarque:(CAShapeLayer*)_marque;
-(void)scale:(id)sender withView:(UIView*)view;
-(void)rotate:(id)sender withView:(UIView*)view;
-(void)move:(id)sender withView:(UIView*)view withEditedImageViews:(NSMutableArray*)editedImageViewsParam;
@end

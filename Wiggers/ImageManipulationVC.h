//
//  imageManipulation.h
//  Wiggers
//
//  Created by Ben Smith on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SaveImage.h"
#import "GADBannerView.h"
#import "CameraVC.h"
#import "SHK.h"
#import "TestFlight.h"
#import "Constants.h"
#import "UIImage+Extensions.h"
#import "SHK.h"
#import "TestFlight.h"
#import "Constants.h"
#import "FaceImageProcessing.h"

@protocol failedToDetectFeature
- (void)noFeaturesDetected;
@end

@interface ImageManipulationVC : UIViewController <UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate> {
    //Image Views for body parts
    NSArray *arrayOfFaceParts;
    NSDictionary *dictOfFaceParts;
    UIImageView *rightSB;
    UIImageView *leftSB;
    UIImageView *jumper;
    UIImageView *hair;
    UIToolbar *imageControls;
    
    //Scale manipulate image
    UIView *canvas;
    NSArray *featuresLocalInstance;
    
    //Toolbar stuff
    UIToolbar *toolBar;
    UIBarButtonItem *share;
    UIBarButtonItem *saveImage;
    UIBarButtonItem *takeNewImage;
    UIBarButtonItem *ok;
    NSArray *saveToolBarItems;
    NSArray *okToolBarItems;
    
    //Save Text box
    UITextField * alertTextField;
    
    //Pan gestures
    UIPinchGestureRecognizer *pinchRecognizer;
    UIPanGestureRecognizer *panRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer;
    UITapGestureRecognizer *tapProfileImageRecognizer;
    
    //ADmobs
    GADBannerView *bannerView_;
    
    //Animate Counter
    int count;
    
    __weak id <failedToDetectFeature> delegate;
    
    FaceImageProcessing *imageProcessing;
    
    //Marque round selected image part
    CAShapeLayer *_marque;
    
}
@property (weak) id <failedToDetectFeature> delegate;
@property (nonatomic,strong) NSArray *featuresLocalInstance;
@property (weak, nonatomic) IBOutlet UITextView *Info;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingWheel;
@property (weak, nonatomic) IBOutlet UILabel *rotationLabel;
@property (nonatomic, strong) IBOutlet UILabel *height;
@property (nonatomic, strong) IBOutlet UILabel *width;
@property (nonatomic, strong) IBOutlet UILabel *xCoord;
@property (nonatomic, strong) IBOutlet UILabel *yCoord;

@property (nonatomic, strong) UIImageView *activeImageView;
@property (nonatomic, retain) CameraVC *cameraVC;
//@property (nonatomic, strong) IBOutlet UIButton *share;
//@property (nonatomic, strong) IBOutlet UIButton *saveImage;
//@property (nonatomic, strong) IBOutlet UIButton *takeNewImage;
//@property (nonatomic, strong) IBOutlet UIButton *ok;

//@property (nonatomic, strong) UIToolbar *toolBar;
//@property (nonatomic, strong) UIBarButtonItem *share;
//@property (nonatomic, strong) UIBarButtonItem *saveImage;
//@property (nonatomic, strong) UIBarButtonItem *takeNewImage;
//@property (nonatomic, strong) UIBarButtonItem *ok;

-(void)alertSaveBox;
- (void)showLoadingText;
- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize;
-(void)ImageDetectionFinished;

//-(void)setImage;
//- (void)drawImageAnnotatedWithFeatures;

//- (void)drawImageAnnotatedWithFeatures;
//- (void)drawFeature:(int)feature InContext:(CGContextRef)context atPoint:(CGPoint)featurePoint;
//- (void)buttonPressed:(id)sender;
//- (UIImage*)dumpOverlayViewToImage;
//-(void)setImage;
@end

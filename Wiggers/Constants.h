//
//  NSObject_Constants.h
//  Wiggers
//
//  Created by Ben Smith on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define IMG_HEIGHT 386.0f
#define IMG_WIDTH 320.0f
#define IMG_X 0.0f
#define IMG_Y 0.0f
#define AD_Y_POSITION 430.0f
#define AD_X_POSITION 0.0f
#define AD_HEIGHT 50.0f
#define AD_WIDTH 320.0f
#define TOOLBAR_Y_POSITION 386.0f
#define TOOLBAR_X_POSITION 0.0f
#define TOOLBAR_HEIGHT 44.0f
#define TOOLBAR_WIDTH 320.0f

#define TITLE_HEIGHT 66.0f
#define TITLE_WIDTH 320.0f
#define TITLE_FONT_SIZE 40.0f

#define IMG_HEIGHT_NO_ADS 436.0f
#define IMG_WIDTH_NO_ADS 320.0f
#define TOOLBAR_Y_POSITION_NO_ADS 436.0f
#define TOOLBAR_X_POSITION_NO_ADS 0.0f

#define OVERLAY_ALPHA 1.0f
#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1

#define productPurchase @"proUpgradeTransactionReceipt"
#define kInAppPurchaseProUpgradeProductId @"com.BenSmithInc.Wiggers"

#define kHairKey 1
#define krightSBKey 2
#define kleftSBKey 3

#define TAG_GRAYVIEW 5671263 // for overlay on selected buttons

#define IMG(name) [UIImage imageNamed:name]
#define FACE_IMAGE_NAMES [NSArray arrayWithObjects:@"hair1.png",  @"hair2.png",@"hair3.png", @"hair4.png", @"sideburnLeft1.png",@"sideburnRight1.png",@"sideburnLeft2.png",@"sideburnRight2.png",nil]
//@"yellowJumper1.png",@"yellowJumper2.png",@"medal.png", nil]

#define FACE_PARTS [NSArray arrayWithObjects:IMG(@"hair1.png"),  IMG(@"hair2.png"),IMG(@"hair3.png"), IMG(@"hair4.png"), IMG(@"sideburnLeft1.png"),IMG(@"sideburnRight1.png"),IMG(@"sideburnLeft2.png"),IMG(@"sideburnRight2.png"),nil]
//,IMG(@"yellowJumper1.png"),IMG(@"yellowJumper2.png"),IMG(@"medal.png"), nil]


//[NSArray arrayWithObjects:IMG(@"betterHairScaled.png"),  IMG(@"rightlargesideburnScaled.png"),IMG(@"leftlargesideburnScaled.png"), IMG(@"yellowJumper.png"), IMG(@"hair.png"), nil]
//
#define SELECTED_IMAGE IMG(@"Green_tick.png")
#define HAIR_PARTS [NSArray arrayWithObjects:@"hair1.png",  @"hair2.png",@"hair3.png", @"hair4.png", nil]
#define LSB_PARTS [NSArray arrayWithObjects:@"sideburnLeft1.png",@"sideburnLeft2.png", nil]
#define RSB_PARTS [NSArray arrayWithObjects:@"sideburnRight1.png", @"sideburnRight2.png", nil]
//
//#define FACE_KEYS [NSArray arrayWithObjects:@"hair",@"leftSB",@"rightSB",@"yellowJumper",@"hair", nil]

typedef enum {
    leftEyeType = 1,
    rightEyeType = 2,
    mouthType = 3,
    hairType = 4,
    leftSBType = 5,
    rightSBType = 6,
    jumperType = 7,
    medalType= 8
    
} faceFeatureType;
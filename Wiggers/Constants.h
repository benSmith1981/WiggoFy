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


#define IMG(name) [UIImage imageNamed:name]
#define FACE_IMAGE_NAMES [NSArray arrayWithObjects:@"betterHairScaled.png",  @"rightlargesideburnScaled.png",@"leftlargesideburnScaled.png", @"yellowJumper.png", @"hair.png", nil]

#define FACE_PARTS [NSArray arrayWithObjects:IMG(@"betterHairScaled.png"),  IMG(@"rightlargesideburnScaled.png"),IMG(@"leftlargesideburnScaled.png"), IMG(@"yellowJumper.png"), IMG(@"hair.png"), nil]

#define HAIR_IMAGES [NSArray arrayWithObjects:IMG(@"betterHairScaled.png"), IMG(@"hair.png"), nil]

#define FACE_KEYS [NSArray arrayWithObjects:@"hair",@"leftSB",@"rightSB",@"yellowJumper",@"hair", nil]

typedef enum {
    leftEyeType = 1,
    rightEyeType = 2,
    mouthType = 3,
    hairType = 4,
    leftSBType = 5,
    rightSBType = 6,
    jumperType = 7
    
} faceFeatureType;
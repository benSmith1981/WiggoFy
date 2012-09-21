//
//  imageManipulation.m
//  Wiggers
//
//  Created by Ben Smith on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageManipulationVC.h"


@interface ImageManipulationVC ()

@end
//#define IMG_WIDTH 320.0f
//#define IMG_HEIGHT 396.0f
@implementation ImageManipulationVC
@synthesize Info;
@synthesize loadingView;
@synthesize loadingText;
@synthesize loadingWheel;
@synthesize rotationLabel;
@synthesize activeImageView;
@synthesize xCoord,yCoord,width,height;
@synthesize featuresLocalInstance,cameraVC;
@synthesize delegate;
//@synthesize share, saveImage, takeNewImage,ok;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        hair = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"betterHairScaled.png"]];
        rightSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightlargesideburnScaled.png"]];
        leftSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftlargesideburnScaled.png"]];
        //jumper = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jerseyEnlarged.png"]];
        
        arrayOfFaceParts = [[NSArray alloc]initWithObjects:hair,rightSB,leftSB,nil];//],jumper, nil];
        dictOfFaceParts = [[NSDictionary alloc]initWithObjects:arrayOfFaceParts forKeys:[[NSArray alloc]initWithObjects:kHairKey,krightSBKey,kleftSBKey, nil]];
        
        //intialise toolbar
        if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(TOOLBAR_X_POSITION_NO_ADS, TOOLBAR_Y_POSITION_NO_ADS, TOOLBAR_WIDTH, TOOLBAR_HEIGHT)];
        }
        else {
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(TOOLBAR_X_POSITION, TOOLBAR_Y_POSITION, TOOLBAR_WIDTH, TOOLBAR_HEIGHT)];
        }
        
        toolBar.barStyle = UIBarStyleDefault;
        
        if ([toolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [toolBar setBackgroundImage:[UIImage imageNamed:@"menuBar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        } else {
            [toolBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBar"]] atIndex:0];
        }
        
        //initialise toolbar buttons
        share =  [self customAddButtonItem:@"SHARE" WithTarget:self action:@selector(buttonPressed:) andTag:1 andTextSize:25];
        saveImage =  [self customAddButtonItem:@"SAVE" WithTarget:self action:@selector(buttonPressed:) andTag:2 andTextSize:25];
        takeNewImage =  [self customAddButtonItem:@"MAIN MENU" WithTarget:self action:@selector(buttonPressed:) andTag:3 andTextSize:15];
        ok =  [self customAddButtonItem:@"OK" WithTarget:self action:@selector(buttonPressed:) andTag:4 andTextSize:25];

        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
        
        //create toolbar arrays
        saveToolBarItems = [NSArray arrayWithObjects:saveImage,flexItem, share,flexItem, takeNewImage, nil];
        okToolBarItems = [NSArray arrayWithObjects:flexItem,ok,flexItem, nil];
        //setup first toolbar
        [toolBar setItems:okToolBarItems animated:NO];
        
        [self.view addSubview:toolBar];
    

        //imageProcessing.imagesToAdd = dictOfFaceParts;
        //[Info setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:15]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:toolBar];
    toolBar.hidden = YES;
    [loadingWheel startAnimating];
    [self showLoadingText];
    

    
   // NSLog(@"height %f width %f",bannerView_.frame.size.height,bannerView_.frame.size.width);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        // Create a view of the standard size at the bottom of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.frame = CGRectMake(AD_X_POSITION,AD_Y_POSITION, AD_WIDTH, AD_HEIGHT);
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a15048c13360bc3";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        
        [self.view addSubview:bannerView_];
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }


    
    //set to false intially
    //doneEditing = FALSE;
        
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        canvas = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IMG_WIDTH_NO_ADS, IMG_HEIGHT_NO_ADS)];
    }
    else {
        canvas = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT)];
    }
    [self.view addSubview:canvas];
    
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [canvas addGestureRecognizer:panRecognizer];
    
    tapProfileImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [canvas addGestureRecognizer:tapProfileImageRecognizer];
    
    imageProcessing.activeFacePart = [arrayOfFaceParts objectAtIndex:0];
    if (!_marque) {
        _marque = [CAShapeLayer layer];
        _marque.fillColor = [[UIColor clearColor] CGColor];
        _marque.strokeColor = [[UIColor grayColor] CGColor];
        _marque.lineWidth = 1.0f;
        _marque.lineJoin = kCALineJoinRound;
        _marque.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
        _marque.bounds = CGRectMake(imageProcessing.activeFacePart.frame.origin.x, imageProcessing.activeFacePart.frame.origin.y, 0, 0);
        _marque.position = CGPointMake(imageProcessing.activeFacePart.frame.origin.x + canvas.frame.origin.x, imageProcessing.activeFacePart.frame.origin.y + canvas.frame.origin.y);
    }

    [self.view sendSubviewToBack:canvas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveImagefeatures:) name:@"featuresNotification" object:nil];
}


- (void)viewDidAppear:(BOOL)animated{ 
    //animate in toolbar when view appears
    [super viewDidAppear:animated];
//    [UIView beginAnimations:@"hideView" context:nil];
//    [UIView setAnimationDuration:0.7];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:toolBar cache:YES];
//    toolBar.frame = CGRectMake(0.0f,436.0f, 320, 44);
//    [UIView commitAnimations];
    count = 0;
}



#pragma mark - Image features Notification  
- (void) receiveImagefeatures:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    //NSDictionary *dict = notification.userInfo; 
    NSArray *features = [notification.userInfo objectForKey:@"features"];
    featuresLocalInstance = features;
}
#pragma mark - Loading Text Animations

- (void)showLoadingText{
    NSString* allStrings[] = {@"Wiggo'fying", @"Adding Sideburns", @"MODding hair", @"Gingering Up!", @"Getting your groove on!",@"Analyzing face!",@"Reticulating Splines!",@"Detecting hair",nil};
    
    
    int randomNumber = arc4random()%8;
    NSString *tempStr = allStrings[randomNumber];
    
    NSLog(@"log: %@ ", tempStr);
    [loadingText setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:25]];
    loadingText.text = tempStr;
    
    ++count;
    int numOfFeatures = 1;
    if (featuresLocalInstance != nil)
        numOfFeatures = [featuresLocalInstance count];
        
    if (count <= 8 && numOfFeatures !=0)
        [self performSelector:@selector(showLoadingText) withObject:nil afterDelay:0.8];
    else{
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1.0];
        self.loadingView.alpha = 0;
        [UIView commitAnimations];
        [self ImageDetectionFinished];
    }

    //loadingText.text = @"Wigifying you!";
}

#pragma mark - Customize Tool Bar Buttons

- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize{
    UIButton *customButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    customButtonView.frame = CGRectMake(0.0f, 0.0f, 79.0f, 38.0f);
    customButtonView.tag = tag;
    
    //Get constraint size
    CGSize constraintSize;
    constraintSize.width = customButtonView.frame.size.width;
    constraintSize.height = customButtonView.frame.size.height;
    CGSize theSize = [title sizeWithFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:textSize] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeMiddleTruncation];
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake((customButtonView.frame.size.width-theSize.width)/2, (customButtonView.frame.size.height-theSize.height)/2, theSize.width, theSize.height)];
    backLabel.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:textSize];
    backLabel.text = title;
    
    [backLabel setBackgroundColor:[UIColor clearColor]];
    [customButtonView addSubview:backLabel];
    
    [customButtonView setBackgroundImage:
     [UIImage imageNamed:@"button.png"] 
                                forState:UIControlStateNormal];
    [customButtonView setBackgroundImage:
     [UIImage imageNamed:@"buttonPressed.png"] 
                                forState:UIControlStateHighlighted];
    
    [customButtonView setImage:
     [UIImage imageNamed:@"button.png"] 
                      forState:UIControlStateNormal];
    [customButtonView setImage:
     [UIImage imageNamed:@"buttonPressed.png"] 
                      forState:UIControlStateHighlighted];
    
    [customButtonView addTarget:target action:action 
               forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customButtonItem = [[UIBarButtonItem alloc] 
                                         initWithCustomView:customButtonView];
    customButtonItem.tag = tag;
    NSLog(@"%i",customButtonItem.tag);
    [customButtonView setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    
    //customButtonItem.imageInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    
    return customButtonItem;    
}

#pragma mark - Button action
- (void)buttonPressed:(id)sender {
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSLog(@"%@",button.title);
    //SAVE
    if (button.tag == 2){
        [self alertSaveBox];
    }
    //SHARE
    else if (button.tag == 1){
        SHKItem *item = [SHKItem image:self.activeImageView.image title:@"WiggoFyed!"];
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        [SHK setRootViewController:self];
        [actionSheet showFromToolbar:toolBar];
    }
    //BACK
    else if (button.tag == 3){
        self.activeImageView = nil;
        [self.navigationController popViewControllerAnimated:YES];
        [TestFlight openFeedbackView];
        //imageControls.hidden = TRUE;
    }
    //OK
    else if (button.tag == 4){
        [imageProcessing setImage];//View:self.activeImageView withFeatures:featuresLocalInstance OnCanvas:canvas];
        [canvas removeGestureRecognizer:pinchRecognizer];
        [canvas removeGestureRecognizer:tapProfileImageRecognizer];
        [canvas removeGestureRecognizer:panRecognizer];
        [canvas removeGestureRecognizer:rotationRecognizer];
        _marque.hidden = YES;
        
        imageProcessing.doneEditing = TRUE;
        [toolBar setItems:saveToolBarItems];
    }
    
}

#pragma mark - Save Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    //NSLog(@"Entered: %@",[alertTextField text]);
    
    if ([alertView.title isEqualToString:@"Wiggo'fy!"]) {

        if([[alertTextField text] isEqualToString:@""] && buttonIndex == 1) //invalid name and OK
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name!" message:@"Please enter a name to save:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        }
        else if (buttonIndex == 1) //OK pressed
        {
            [SaveImage saveImage:activeImageView.image withFileName:[alertTextField text]];
        }
        else {
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
        }
    }
    else if ([alertView.title isEqualToString:@"No Face Detected"])
    {
        if(buttonIndex == 0) //Main Menu
        {
            self.activeImageView = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1) //New Image
        {
            self.activeImageView = nil;
            [canvas removeFromSuperview];
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
            [self.delegate noFeaturesDetected];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)alertSaveBox{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Wiggo'fy!" message:@"Please enter name to save:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"File Name";
    [alert show];
}

#pragma mark - Alert View when image detection finished
-(void)ImageDetectionFinished
{
    
    if ([featuresLocalInstance count] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Face Detected" message:@"No face was detected, please take another image" delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:@"New Image",nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"To Edit Image..." message:@"Pinch, Flick, Tap and Rotate the images, so as to fit to your face to complete Wiggification!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoadingText) object: nil];
        [loadingWheel stopAnimating];
        toolBar.hidden = NO;
        
        imageProcessing = [[FaceImageProcessing alloc]init];
        [imageProcessing initialiseImages:dictOfFaceParts withArrayOfFaceParts:arrayOfFaceParts withCanvas:canvas withImageView:self.activeImageView];
        imageProcessing.features = featuresLocalInstance;
        imageProcessing.activeImageView = self.activeImageView;
        self.activeImageView = [imageProcessing drawImageAnnotatedWithFeatures];
        
        [self.view addSubview:activeImageView];
        [self.view addSubview:hair];
        [self.view addSubview:rightSB];
        [self.view addSubview:leftSB];
        
        //add scrolling marque to indicate selected image
        [[self.view layer] addSublayer:_marque];
        //add info over canvas
        //[self.view bringSubviewToFront:Info];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
            [self.view bringSubviewToFront:bannerView_];
        }
        [self.view bringSubviewToFront:toolBar];
    }
}



#pragma mark - Manipulate Image

-(void)showOverlayWithFrame:(CGRect)frame {
    [imageProcessing showOverlayWithFrame:frame withMarque:_marque];

    
}

-(void)scale:(id)sender {
 
    [imageProcessing scale:sender withView:self.view];

}

-(void)rotate:(id)sender {
    
    [imageProcessing rotate:sender withView:self.view];
    [imageProcessing showOverlayWithFrame:imageProcessing.activeFacePart.frame withMarque:_marque];
}


-(void)move:(id)sender {
    [imageProcessing move:sender withView:self.view];
    [imageProcessing showOverlayWithFrame:imageProcessing.activeFacePart.frame withMarque:_marque];

}

#pragma mark Gesture recognizer actions

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    imageProcessing.objectMoving = TRUE;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


-(void)tapped:(id)sender {
    if(!imageProcessing.doneEditing)
    {
        CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:self.view];
        
        for (UIImageView *facePart in arrayOfFaceParts) {
            if (CGRectContainsPoint(facePart.frame, touchPoint))
            {
                imageProcessing.activeFacePart = facePart;
            }
        }
        [self showOverlayWithFrame:imageProcessing.activeFacePart.frame];
        [self.view bringSubviewToFront:imageProcessing.activeFacePart];
    }
}

#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
}
- (void)viewDidUnload {
//    [self setRotation:nil];
    [self setLoadingWheel:nil];
    [self setLoadingText:nil];
    [self setLoadingView:nil];
    //[self setInfo:nil];
    [super viewDidUnload];
}
@end

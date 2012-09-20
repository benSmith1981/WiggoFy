//
//  ViewController.m
//  Wigtastic
//
//  Created by Ben on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

//view for the image taken from camera
@synthesize adFree;
@synthesize activeImageView;
//buttons
@synthesize recentImages, takePicture,recentImagesTitle1,recentImagesTitle2,takePicTitle1,takePicTitle2,blueCog,infoButton;
@synthesize recentImageTable,mainTitle,head,cameraVC;
@synthesize imageManip;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        // Create a view of the standard size at the bottom of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        NSLog(@"height %f width %f",bannerView_.frame.size.height,bannerView_.frame.size.width);
        bannerView_.frame = CGRectMake(AD_X_POSITION, AD_Y_POSITION, AD_WIDTH, AD_HEIGHT);
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a15048c13360bc3";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }
    

    
    [recentImagesTitle1 setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:33]]; 
    [recentImagesTitle2 setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:33]]; 
    [takePicTitle1 setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:20]]; 
    [takePicTitle2 setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:20]]; 
    
    takePicture.titleLabel.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:10];
    takePicture.titleLabel.text = @"Get Wigg'd";
    
    recentImages.titleLabel.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:10];
    recentImages.titleLabel.text = @"Recent Images";
    
    //Get constraint size
    CGSize constraintSize;
    constraintSize.width = self.view.frame.size.width;
    constraintSize.height = TITLE_HEIGHT;
    mainTitle.text = @"Wiggo'fy Yourself!";
    CGSize theSize = [mainTitle.text sizeWithFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:TITLE_FONT_SIZE] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeMiddleTruncation];
    mainTitle.frame = CGRectMake((self.view.frame.size.width-theSize.width)/2,(TITLE_HEIGHT-theSize.height)/2, theSize.width,theSize.height);
    [mainTitle setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:TITLE_FONT_SIZE]]; 
    
    Animation *animateCogs = [[Animation alloc]init];
    [animateCogs spinLayer:blueCog.layer duration:3 direction:SPIN_COUNTERCLOCK_WISE];

    //setup cameraVc so this class can act as delegate to receive callbacks
    self.cameraVC = [[CameraVC alloc] initWithNibName:@"Camera" bundle:nil];
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.cameraVC.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveImagefeatures:) name:@"featuresNotification" object:nil];
    
}

- (void)viewDidUnload
{
    
    [self setTakePicture:nil];
    [self setAdFree:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - failedToDetectFeature delegate
- (void)noFeaturesDetected{
    self.activeImageView = nil;
    [self ImagePicker];
}

#pragma mark - Image features Notification  
- (void) receiveImagefeatures:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    //NSDictionary *dict = notification.userInfo; 
    NSArray *features = [notification.userInfo objectForKey:@"features"];
    imageManip.featuresLocalInstance = features;
}


#pragma mark - Action sheet Image picker
- (void)ImagePicker {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] 
                 initWithTitle:@"" delegate:self 
                 cancelButtonTitle:@"Cancel" 
                 destructiveButtonTitle:nil 
                 otherButtonTitles:@"Choose An Existing Photo", nil];
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self.view];
        sheet.tag = 0;
        //[sheet release];
    }
    
    else {
        sheet = [[UIActionSheet alloc] 
                 initWithTitle:@"" delegate:self 
                 cancelButtonTitle:@"Cancel" 
                 destructiveButtonTitle:nil 
                 otherButtonTitles:@"Choose An Existing Photo", @"Take A Photo", nil];
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self.view];
        sheet.tag = 1;
        //[sheet release];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.activeImageView = nil;
    UIImageView *imageView = [[UIImageView alloc]init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        imageView.frame = CGRectMake(IMG_X,IMG_Y, IMG_HEIGHT_NO_ADS, IMG_HEIGHT_NO_ADS);
    }
    else {
        imageView.frame = CGRectMake(IMG_X,IMG_Y, IMG_WIDTH, IMG_HEIGHT);
    }
    
    //[self.view addSubview:imageView];
    self.activeImageView = imageView;
    
    switch (sheet.tag) {
        case 0:
            if (buttonIndex == 0) {
                //Okay the UIImagePickerControllerSourceTypeSavedPhotosAlbum displays the 
                NSLog(@"Album");
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                [self presentModalViewController:picker animated:YES];
                //[picker release];
                
            }
            break;
        case 1:
            if (buttonIndex == 0) {
                //Okay the UIImagePickerControllerSourceTypeSavedPhotosAlbum displays the 
                NSLog(@"Album");
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
//                [self presentModalViewController:picker animated:YES];
                //[picker release];
                
            } else if (buttonIndex == 1) {
                NSLog(@"Camera");
                [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                picker.cameraOverlayView = [[UIImageView alloc] initWithImage:overlayImage.image];
//                [self presentModalViewController:picker animated:YES];
                //[picker release];
            }
            break;
    }
}

#pragma mark - Show Camera


- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.cameraVC setupImagePicker:sourceType];
        
        [self presentModalViewController:self.cameraVC.imagePickerController animated:YES];
    }
}

#pragma mark - Take picture

- (IBAction)buttonPressed:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"%i", [button tag]);
    if ([button tag] == 1) {

        [self ImagePicker];
    }
    else if ([button tag] == 2) {
        self.recentImageTable = [[RecentImagesTableView alloc]init];
        [self.navigationController pushViewController:recentImageTable animated:YES];
    }
    else if ([button tag] == 3) {//try to flip to info view
        InfoVC *infoView = [[InfoVC alloc]initWithNibName:@"InfoView" bundle:nil];
        
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                               forView:self.navigationController.view cache:NO];
        
        [self.navigationController pushViewController:infoView animated:YES];
        [UIView commitAnimations];
        
    }
    
}

- (IBAction)AdFreePurchase:(id)sender {
    //InAppPurchaseManager *purchase = [[InAppPurchaseManager alloc]initPrivate];
    
}



#pragma mark - OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    //Code to display overlay over camera image
    //    self.activeImageView.image = [self addOverlayToBaseImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    //    UIImageView *compositeView = [[UIImageView alloc]initWithImage:[self addOverlayToBaseImage:self.activeImageView.image]];
    //    self.activeImageView = compositeView;
    //    [self.view addSubview:compositeView];
    
    self.activeImageView.image = picture;
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    [self dismissModalViewControllerAnimated:YES];
    self.imageManip = [[imageManipulation alloc]initWithNibName:@"ImageManipulationView" bundle:nil];
    self.imageManip.delegate = self;
    imageManip.activeImageView = self.activeImageView;
    [ImageProcessing processFace:self.activeImageView.image];
    [self.navigationController pushViewController:imageManip animated:YES];

}
@end

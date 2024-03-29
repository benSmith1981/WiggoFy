//
//  SaveImageVC.m
//  Wiggers
//
//  Created by Ben Smith on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveImageVC.h"
#import "SHK.h"
#import "Constants.h"
@interface SaveImageVC ()

@end

@implementation SaveImageVC
@synthesize savedImageView,toolBar,savedImage,filename,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a view of the standard size at the bottom of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    NSLog(@"height %f width %f",bannerView_.frame.size.height,bannerView_.frame.size.width);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        bannerView_.frame = CGRectMake(0, 430, 320, 50);
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a15048c13360bc3";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        savedImageView.frame = CGRectMake(0, 0, 320, IMG_HEIGHT_NO_ADS);
    }
    else {
        savedImageView.frame = CGRectMake(0, 0, 320, IMG_HEIGHT);
    }
    savedImageView = [[UIImageView alloc]initWithImage:savedImage];
    [self.view addSubview:savedImageView];
    
    //intialise toolbar
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,IMG_HEIGHT_NO_ADS, 320, 44)];
    }
    else {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,IMG_HEIGHT, 320, 44)];
    }
    toolBar.barStyle = UIBarStyleBlackTranslucent;
//    toolBar.barStyle = UIBarStyleDefault;
//    if ([toolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
//        [toolBar setBackgroundImage:[UIImage imageNamed:@"menuBar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    } else {
//        [toolBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBar"]] atIndex:0];
//    }

    back = [self customAddButtonItem:@"BACK" WithTarget:self action:@selector(buttonPressed:) andTag:1 andTextSize:25];
    deleteImage = [self customAddButtonItem:@"DELETE" WithTarget:self action:@selector(buttonPressed:) andTag:2 andTextSize:22];
    share = [self customAddButtonItem:@"SHARE" WithTarget:self action:@selector(buttonPressed:) andTag:3 andTextSize:25];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    //create toolbar arrays
    NSArray *recentImagesToolbar = [NSArray arrayWithObjects:back,flexItem, share,flexItem, deleteImage, nil];
    [toolBar setItems:recentImagesToolbar animated:NO];
    [self.view addSubview:toolBar];
    // Do any additional setup after loading the view from its nib.
}

- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize{
    UIButton *customButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    customButtonView.frame = CGRectMake(0.0f, 0.0f, 79.0f, 38.0f);
    customButtonView.tag = tag;
    //    customButtonView.titleLabel.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:25];
    //    customButtonView.titleLabel.text = @"BACK";
    
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
    //BACK
    if (button.tag == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    //SHARE
    if (button.tag == 3){
        SHKItem *item = [SHKItem image:savedImageView.image title:@"I've been MODdofied! Vote Bradley Wiggins for BBC Sports Personality 2012"];
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        [SHK setRootViewController:self];
        [actionSheet showFromToolbar:toolBar];
    }
    //DELETE
    if (button.tag == 2){
        [SaveImage removeImage:filename];
        //Is anyone listening
        if([delegate respondsToSelector:@selector(deleteImage:)])
        {
            [delegate deleteImage:[SaveImage getListOfPNGsInDocDirectory]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end

//
//  ViewController.h
//  Wigtastic
//
//  Created by Ben on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "RecentImagesTableView.h"
#import "Animation.h"
#import "CameraVC.h"
#import "SHKItem.h"
#import "SHKActionSheet.h"
#import "ImageManipulationVC.h"
#import "SaveImage.h"
#import "InfoVC.h"
#import "Constants.h"
#import "InAppPurchaseManager.h"
#import "FaceImageProcessing.h"



@interface MainScreenVC : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate,OverlayViewControllerDelegate, failedToDetectFeature>{
//    UIImageView *rightSB;
//    UIImageView *leftSB;
//    UIImageView *nose;
//    UIImageView *hair;
    GADBannerView *bannerView_;
    UIView *parentView;
    RecentImagesTableView *recentImageTable;
    UIActionSheet *sheet;
    NSArray *imageFeatures;
    ImageManipulationVC *imageManip;
}
@property (nonatomic,strong) ImageManipulationVC *imageManip;
@property (weak, nonatomic) IBOutlet UIButton *adFree;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UILabel *mainTitle;
@property (nonatomic, strong) IBOutlet UILabel *recentImagesTitle1;
@property (nonatomic, strong) IBOutlet UILabel *recentImagesTitle2;
@property (nonatomic, strong) IBOutlet UILabel *takePicTitle1;
@property (nonatomic, strong) IBOutlet UILabel *takePicTitle2;
@property (nonatomic, strong) IBOutlet UIButton *takePicture;
@property (nonatomic, strong) IBOutlet UIImageView *blueCog;
@property (nonatomic, strong) IBOutlet UIImageView *head;
@property (nonatomic, strong) IBOutlet UIButton *recentImages;
@property (nonatomic, strong) RecentImagesTableView *recentImageTable;
@property (nonatomic, strong) UIImageView *activeImageView;

@property (nonatomic, retain) CameraVC *cameraVC;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)AdFreePurchase:(id)sender;
- (void)ImagePicker;
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType;



@end


//
//  PeekPagedScrollViewController.m
//  ScrollViews
//
//  Created by Matt Galloway on 01/03/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "PeekPagedScrollViewController.h"

@interface PeekPagedScrollViewController ()
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSMutableArray *pageViews;

//- (void)loadVisiblePages;
//- (void)loadPage:(NSInteger)page;
//- (void)purgePage:(NSInteger)page;
@end

@implementation PeekPagedScrollViewController

@synthesize scrollView = _scrollView;
//@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

#pragma mark -

//- (void)loadVisiblePages {
//    // First, determine which page is currently visible
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
//    
//    NSLog(@"%f  self.scrollView.width %f",self.view.frame.size.width,self.scrollView.frame.size.width);
//// self.scrollView.width;
//    
//    // Update the page control
//    //self.pageControl.currentPage = page;
//    
//    // Work out which pages we want to load
//    NSInteger firstPage = page - 3;
//    NSInteger lastPage = page + 3;
//    
//    // Purge anything before the first page
//    for (NSInteger i=0; i<firstPage; i++) {
//        [self purgePage:i];
//    }
//    for (NSInteger i=firstPage; i<=lastPage; i++) {
//        [self loadPage:i];
//    }
//    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
//        [self purgePage:i];
//    }
//}
//
//- (void)loadPage:(NSInteger)page {
//    if (page < 0 || page >= self.pageImages.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Load an individual page, first seeing if we've already loaded it
//    UIView *pageView = [self.pageViews objectAtIndex:page];
//    if ((NSNull*)pageView == [NSNull null]) {
//        CGRect frame = self.scrollView.bounds;
//        frame.origin.x = frame.size.width * page;
//        frame.origin.y = 0.0f;
//        frame = CGRectInset(frame, 10.0f, 0.0f);
//        
//        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
//        newPageView.contentMode = UIViewContentModeScaleAspectFit;
//        newPageView.frame = frame;
//        [self.scrollView addSubview:newPageView];
//        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
//    }
//}
//
//- (void)purgePage:(NSInteger)page {
//    if (page < 0 || page >= self.pageImages.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Remove a page from the scroll view and reset the container array
//    UIView *pageView = [self.pageViews objectAtIndex:page];
//    if ((NSNull*)pageView != [NSNull null]) {
//        [pageView removeFromSuperview];
//        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
//    }
//}


#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Paged";
    
    // Set up the image we want to scroll & zoom and add it to the scroll view
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"photo1.png"],
                       [UIImage imageNamed:@"photo2.png"],
                       [UIImage imageNamed:@"photo3.png"],
                       [UIImage imageNamed:@"photo4.png"],
                       [UIImage imageNamed:@"photo5.png"],
                       [UIImage imageNamed:@"photo1.png"],
                       [UIImage imageNamed:@"photo2.png"],
                       [UIImage imageNamed:@"photo3.png"],
                       [UIImage imageNamed:@"photo4.png"],
                       [UIImage imageNamed:@"photo5.png"],
                       [UIImage imageNamed:@"photo1.png"],
                       [UIImage imageNamed:@"photo2.png"],
                       [UIImage imageNamed:@"photo3.png"],
                       [UIImage imageNamed:@"photo4.png"],
                       [UIImage imageNamed:@"photo5.png"],
                       nil];

    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:[UIImage imageNamed:@"photo1.png"] forState:UIControlStateNormal];
    UIButton *aButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton2 setBackgroundImage:[UIImage imageNamed:@"photo2.png"] forState:UIControlStateNormal];
    UIButton *aButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton3 setBackgroundImage:[UIImage imageNamed:@"photo3.png"] forState:UIControlStateNormal];
    UIButton *aButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton4 setBackgroundImage:[UIImage imageNamed:@"photo4.png"] forState:UIControlStateNormal];
    
    UIButton *aButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton5 setBackgroundImage:[UIImage imageNamed:@"photo5.png"] forState:UIControlStateNormal];
    
    UIButton *aButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton6 setBackgroundImage:[UIImage imageNamed:@"photo1.png"] forState:UIControlStateNormal];
    
    self.buttons = [NSArray arrayWithObjects:
                       aButton,aButton2,aButton3,aButton4,aButton5,aButton6,
                       nil];

//    NSInteger pageCount = self.pageImages.count;
    
    // Set up the page control
//    self.pageControl.currentPage = 0;
//    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
//    self.pageViews = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < pageCount; ++i) {
//        [self.pageViews addObject:[NSNull null]];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.scrollView setShowsHorizontalScrollIndicator:NO];
//    // Set up the content size of the scroll view
//    CGSize pagesScrollViewSize = self.scrollView.frame.size;
//    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
//    
//    for (int page = 0; page < [self.pageImages count]; page++){
//        CGRect frame = self.scrollView.bounds;
//        frame.origin.x = frame.size.width * page;
//        frame.origin.y = 0.0f;
//        frame = CGRectInset(frame, 10.0f, 0.0f);
//        
//        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
//        newPageView.contentMode = UIViewContentModeScaleAspectFit;
//        newPageView.frame = frame;
//        [self.scrollView addSubview:newPageView];
//        
//    }
    
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    int buttonHeight = pagesScrollViewSize.height;
    int buttonWidth = pagesScrollViewSize.height;
    
    self.scrollView.contentSize = CGSizeMake((buttonHeight + 10) * self.buttons.count, pagesScrollViewSize.height);
    
    for (int page = 0; page < [self.buttons count]; page++){
        CGRect frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        frame.origin.x = (buttonWidth + 10) * page ;
        frame.origin.y = 0.0f;
        //frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIButton *currentButton = [self.buttons objectAtIndex:page];
        currentButton.frame = frame;
        [self.scrollView addSubview:currentButton];
    }
    
    
    // Load the initial set of pages that are on screen
    //[self loadVisiblePages];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.scrollView = nil;
    //self.pageControl = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    //[self loadVisiblePages];
}

@end

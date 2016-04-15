//
//  QiuBaiNewPostViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/4/13.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "QiuBaiNewPostViewController.h"

@interface QiuBaiNewPostViewController ()<UITextViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic)   IBOutlet    UITextView* textView;
@property (strong, nonatomic)   IBOutlet    UIToolbar* toolBar;
@property (strong, nonatomic)   IBOutlet    UIButton* locationButton;
@property (strong, nonatomic)   IBOutlet    UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic)   CLLocationManager* locationManager;
@end

@implementation QiuBaiNewPostViewController
- (instancetype)initWithViewFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        CGFloat toolbarHeight = 44.0;
        CGRect textViewRect = CGRectMake(frame.origin.x, frame.origin.y,
                                         frame.size.width, frame.size.height - toolbarHeight);
        self.textView = [[UITextView alloc] initWithFrame:textViewRect];
        self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.textView.delegate = self;
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height - toolbarHeight + frame.origin.y,
                                                                   frame.size.width, toolbarHeight)];
        UIBarButtonItem* photoLibButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gallery"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(selectPhoto:)];
        UIBarButtonItem* cameraButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"]
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(takePhoto:)];
        UIBarButtonItem* videoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"video"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(recordVideo:)];
        self.toolBar.items = @[photoLibButton, cameraButton, videoButton];

        CGSize locationButtonSize = CGSizeMake(100, 20);
        CGRect locationButtonFrame = CGRectZero;
        locationButtonFrame.origin = CGPointMake(5, textViewRect.size.height -  locationButtonSize.height - 2);
        locationButtonFrame.size = locationButtonSize;
        self.locationButton = [[UIButton alloc] initWithFrame:locationButtonFrame];
        self.locationButton.alpha = 0.7;
        self.locationButton.backgroundColor = [UIColor lightGrayColor];
        self.locationButton.layer.cornerRadius = 5.0;
        self.locationButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.locationButton setTitle:@"Attach location" forState:UIControlStateNormal];
        [self.locationButton addTarget:self
                                action:@selector(toggleLocationEnabled:)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.textView addSubview:self.locationButton];
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(70, 0, 30, 30)];
        self.activityIndicator.hidesWhenStopped = YES;
        [self.locationButton addSubview:self.activityIndicator];

        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(cancelPost:)];
        UIBarButtonItem* postButton = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(post:)];

        self.navigationItem.title = @"new Post";
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem = postButton;

        [self.view addSubview:self.textView];
        [self.view addSubview:self.toolBar];
        self.tabBarItem = nil;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShown:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

- (IBAction)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)post:(id)sender {

}

- (IBAction)selectPhoto:(id)sender {

}

- (IBAction)takePhoto:(id)sender {

}

- (IBAction)recordVideo:(id)sender {

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Next 2 lines are here to fix the API bug: can't snap the textViewContainer frame to the textView
    [self.textView setContentOffset:CGPointZero animated:NO];
    [self.textView setScrollEnabled:NO];
}

- (void)keyboardDidShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect textViewRect = self.textView.frame;
    CGRect toolbarRect = self.toolBar.frame;
    CGRect addLocationRect = self.locationButton.frame;
    if (CGRectContainsRect([UIScreen mainScreen].bounds, keyboardRect)) {
        textViewRect.size.height -= keyboardRect.size.height;
        toolbarRect.origin.y -= keyboardRect.size.height;
        addLocationRect.origin.y -= keyboardRect.size.height;
    } else {

    }

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.textView.frame = textViewRect;
                         self.toolBar.frame = toolbarRect;
                         self.locationButton.frame = addLocationRect;
                     }];

}

- (IBAction)toggleLocationEnabled:(id)sender {
    BOOL isEnabledLocation = [CLLocationManager locationServicesEnabled];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = CLLocationDistanceMax;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self.activityIndicator startAnimating];
    [self.locationButton setNeedsDisplay];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [locations lastObject];
    [geocoder reverseGeocodeLocation:location
completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    
        CLPlacemark* placemark = [placemarks lastObject];
        [self.locationButton setTitle:placemark.name forState:UIControlStateNormal];
        self.locationButton.backgroundColor = [UIColor blueColor];
        [self.locationButton sizeToFit];
        [self.activityIndicator stopAnimating];
}];
}
@end

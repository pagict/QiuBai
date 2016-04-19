//
//  QiuBaiNewPostViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/4/13.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "QiuBaiNewPostViewController.h"
#import "../customViews/AnonymousSwitch.h"
#import "QiuBaiImageEditorViewController.h"
#import "QiuBaiImageSelectionController.h"

@interface QiuBaiNewPostViewController ()<UITextViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic)   IBOutlet    UITextView* textView;
@property (strong, nonatomic)   IBOutlet    UIToolbar* toolBar;
@property (strong, nonatomic)   IBOutlet    UIView* locationView;
@property (strong, nonatomic)   IBOutlet    UIButton* locationButton;
@property (strong, nonatomic)   IBOutlet    UIButton* cancelLocationButton;
@property (strong, nonatomic)   IBOutlet    AnonymousSwitch *anonymousSwitch;

@property (strong, nonatomic)   CLLocationManager* locationManager;
@property (strong, nonatomic)   CLPlacemark* placemark;

@property (strong, nonatomic)   UIImage*    attachedImage;
@end

@implementation QiuBaiNewPostViewController
- (instancetype)initWithViewFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        /***************  Text View **************/
        CGFloat toolbarHeight = 44.0;
        CGRect textViewRect = CGRectMake(frame.origin.x, frame.origin.y,
                                         frame.size.width, frame.size.height - toolbarHeight);
        self.textView = [[UITextView alloc] initWithFrame:textViewRect];
        self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.textView.delegate = self;
        /***************  Tool Bar **************/
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

        /***************  Location View **************/
        self.locationView = [[UIView alloc] init];
        self.locationView.layer.masksToBounds = YES;
        self.locationView.contentMode = UIViewContentModeLeft;

        /***************  location Button **************/
        self.locationButton = [[UIButton alloc] init];
        self.locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.locationButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.locationButton addTarget:self
                                action:@selector(toggleLocationEnabled:)
                      forControlEvents:UIControlEventTouchUpInside];
        /***************  Image View and title in locationButton **************/
        [self.locationButton setImage:[UIImage imageNamed:@"latitude"] forState:UIControlStateNormal];
        CGRect latitudeImageFrame = self.locationButton.imageView.frame;
        latitudeImageFrame.origin.x = 0;
        self.locationButton.imageView.frame = latitudeImageFrame;
        [self.locationView addSubview:self.locationButton];

        /***************  cancel Location Button **************/
        self.cancelLocationButton = [[UIButton alloc] init];
        [self.cancelLocationButton setImage:[UIImage imageNamed:@"cancel_x"] forState:UIControlStateNormal];
        [self.cancelLocationButton addTarget:self
                                      action:@selector(cancelLocation:)
                            forControlEvents:UIControlEventTouchUpInside];

        [self changeAppearanceAsNotLocated];
        [self placeButtonsAsNotLocated];

        [self.textView addSubview:self.locationView];


        /***************  navigation bar Buttons **************/
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(cancelPost:)];
        UIBarButtonItem* postButton = [[UIBarButtonItem alloc] initWithTitle:@"投稿"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(post:)];
        [postButton setTintColor:[UIColor yellowColor]];

        /***************  navigation bar TitleView **************/
        self.anonymousSwitch = [[AnonymousSwitch alloc] initWithFrame:CGRectMake(0, 0, 200, 31)];
        self.navigationItem.titleView = self.anonymousSwitch;

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
    BOOL isPhotoLibAvailable = [UIImagePickerController isSourceTypeAvailable:
                                UIImagePickerControllerSourceTypePhotoLibrary];
    if (! isPhotoLibAvailable) {
        return;
    }

    QiuBaiImageSelectionController* pickImageController = [[QiuBaiImageSelectionController alloc] init];
    pickImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickImageController.allowsEditing = NO;
    pickImageController.delegate = self;
    [self presentViewController:pickImageController animated:NO completion:nil];
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
    CGRect addLocationRect = self.locationView.frame;
    if (CGRectContainsRect([UIScreen mainScreen].bounds, keyboardRect)) {
//    if (CGRectContainsPoint([UIScreen mainScreen].bounds, keyboardRect.origin)) {
        textViewRect.size.height -= keyboardRect.size.height;
        toolbarRect.origin.y -= keyboardRect.size.height;
        addLocationRect.origin.y -= keyboardRect.size.height;
    } else {

    }

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.textView.frame = textViewRect;
                         self.toolBar.frame = toolbarRect;
                         self.locationView.frame = addLocationRect;
                     }];

}

- (IBAction)toggleLocationEnabled:(id)sender {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusDenied: {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"打开定位"
                                                                           message:@"请在[设置]-[隐私]-[定位] 中将定位打开"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* dismissAction = [UIAlertAction actionWithTitle:@"confirm"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * _Nonnull action) {

                                                                  }];
            [alert addAction:dismissAction];

            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:
            [self startUpdateLocation];
            break;
    }
}

- (void)     locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusNotDetermined && status != kCLAuthorizationStatusDenied) {
        [self startUpdateLocation];
    }
}

- (void)startUpdateLocation {
    [self.locationButton setTitle:@"定位中..." forState:UIControlStateNormal];
    [self.locationButton sizeToFit];
    CGRect locationViewFrame = self.locationView.frame;
    locationViewFrame.size.width = self.locationButton.frame.size.width;
    self.locationView.frame = locationViewFrame;
    [self.locationManager startUpdatingLocation];
    [self.locationButton setNeedsDisplay];
}

- (CLLocationManager*)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = CLLocationDistanceMax;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {

    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [locations lastObject];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {

                       CLPlacemark* placemark = [placemarks lastObject];
                       if (!placemark) {
                           return;
                       }
                       NSString* location = [NSString stringWithFormat:@"%@ - %@", placemark.locality, placemark.subLocality];
                       [self changeAppearanceAsLocated:location];
                       [self placeButtonsAsLocated];

                       self.placemark = placemark;
                       [self.locationManager stopUpdatingLocation];
                   }];
}

- (void)placeButtonsAsLocated {
    [self.locationButton sizeToFit];
    self.locationButton.enabled = NO;

    self.cancelLocationButton.hidden = NO;
    CGRect cancelButtonRect = self.cancelLocationButton.frame;
    cancelButtonRect.origin.x = self.locationButton.frame.size.width + 3;
    self.cancelLocationButton.frame = cancelButtonRect;
    self.cancelLocationButton.enabled = YES;

    CGRect locationViewRect = self.locationView.frame;
    locationViewRect.size.width = cancelButtonRect.origin.x + cancelButtonRect.size.width + 3;
    self.locationView.frame = locationViewRect;
    [self.locationView addSubview:self.cancelLocationButton];
    [self.locationView bringSubviewToFront:self.cancelLocationButton];
    [self.locationView setNeedsDisplay];
}

- (void)changeAppearanceAsLocated:(NSString*)locationString {
    [self.locationButton setTitle:locationString forState:UIControlStateNormal];
    self.locationButton.alpha = 1.0;
    self.locationButton.backgroundColor = [UIColor colorWithRed:0.4
                                                          green:0.46
                                                           blue:1.0
                                                          alpha:1.0];

    self.cancelLocationButton.backgroundColor = self.locationButton.backgroundColor;


    self.locationView.backgroundColor = self.cancelLocationButton.backgroundColor;
}

- (void)placeButtonsAsNotLocated {
    CGRect locationViewFrame = CGRectZero;
    locationViewFrame.size = CGSizeMake(120, 20);
    locationViewFrame.origin = CGPointMake(5, self.textView.frame.size.height -  locationViewFrame.size.height - 18);
    self.locationView.frame = locationViewFrame;
    self.locationView.layer.cornerRadius = self.locationView.frame.size.height / 2;

    CGRect locationButtonFrame = locationViewFrame;
    locationButtonFrame.origin = CGPointMake(0, 0);
    locationButtonFrame.size.width -= 20;
    self.locationButton.frame = locationButtonFrame;

    /********  set location View width ********/
    locationViewFrame.size.width = locationButtonFrame.size.width;
    self.locationView.frame = locationViewFrame;

    CGRect cancelLocationButtonFrame = locationButtonFrame;
    cancelLocationButtonFrame.size.width = 15;
    cancelLocationButtonFrame.size.height = 15;
    cancelLocationButtonFrame.origin.x = locationButtonFrame.size.width + 6;
    cancelLocationButtonFrame.origin.y = locationViewFrame.size.height / 2 - cancelLocationButtonFrame.size.height / 2;
    self.cancelLocationButton.frame = cancelLocationButtonFrame;
    self.cancelLocationButton.hidden = YES;
}

- (void)changeAppearanceAsNotLocated {
    [self.locationButton setTitle:@"添加地理位置信息" forState:UIControlStateNormal];
    self.locationButton.backgroundColor = [UIColor lightGrayColor];
    self.locationButton.alpha = 0.7;
    self.locationButton.enabled = YES;

    self.locationView.backgroundColor = [UIColor clearColor];
}

- (IBAction)cancelLocation:(id)sender {

    self.placemark = nil;
    [self.cancelLocationButton removeFromSuperview];
    [self changeAppearanceAsNotLocated];
    [self placeButtonsAsNotLocated];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage* selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    QiuBaiImageEditorViewController* addImageVC = [[QiuBaiImageEditorViewController alloc] initWithImage:selectedImage];
    [picker presentViewController:addImageVC animated:NO completion:nil];

//    [self dismissViewControllerAnimated:NO completion:^{
//        //Update
//        NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
//        attachment.image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        NSAttributedString* as = [NSAttributedString attributedStringWithAttachment:attachment];
//        [self.textView setAttributedText: as];
//    }];
}


#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.presentedViewController isKindOfClass:[QiuBaiImageSelectionController class]]) {
        QiuBaiImageSelectionController* isc = (QiuBaiImageSelectionController*)self.presentedViewController;
        self.attachedImage = isc.selectedImage;
        [self updateTextView];
    }
}

- (void)updateTextView {
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    attachment.image = self.attachedImage;
    [self.textView setAttributedText:[NSAttributedString attributedStringWithAttachment:attachment]];
}

@end

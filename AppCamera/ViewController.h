//
//  ViewController.h
//  AppCamera
//
//  Created by Yibin Liao on 10/10/17.
//  Copyright © 2017 AppCamera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)uploadPhoto;

@end


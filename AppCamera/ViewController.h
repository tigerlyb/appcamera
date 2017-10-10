//
//  ViewController.h
//  AppCamera
//
//  Created by sisi ye on 10/10/17.
//  Copyright © 2017 AppCamera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    //IBOutlet UIButton *selectPhote;
    //IBOutlet UIButton *takePhoto;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)uploadPhoto;

@end


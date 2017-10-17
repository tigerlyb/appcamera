//
//  ViewController.m
//  AppCamera
//
//  Created by Yibin Liao on 10/10/17.
//  Copyright © 2017 AppCamera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(chosenImage, self, NULL, NULL);
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)selectPhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)uploadPhoto {
    @try {
        // convert image to base64 encoded data
        UIImage *image = self.imageView.image;
        NSData *dataImage = UIImagePNGRepresentation(image);
        NSString *base64Image = [dataImage base64EncodedStringWithOptions:0];
        NSArray *imageArray = [NSArray arrayWithObjects:base64Image, nil];;
    
        // create json data format
        NSMutableDictionary *input = [[NSMutableDictionary alloc] init];
        [input setObject:@224 forKey:@"width"];
        [input setObject:@224 forKey:@"height"];
        
        NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
        [output setObject:@3 forKey:@"best"];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:input forKey:@"input"];
        [parameters setObject:output forKey:@"output"];
        
        NSMutableDictionary *inputData = [[NSMutableDictionary alloc] init];
        [inputData setObject:@"imageserv" forKey:@"service"];
        [inputData setObject:parameters forKey:@"parameters"];
        [inputData setObject:imageArray forKey:@"data"];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:inputData options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSASCIIStringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%d", [jsonInputString length]];
        
        // setup http post
        NSURL *url = [NSURL URLWithString:@"http://willamete.cs.uga.edu:8080/predict"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[jsonInputString dataUsingEncoding:NSASCIIStringEncoding]];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        if (err) {
            NSLog(@"Response Error: %@", err);
        } else {
            // Parse response
            NSError *responseError;
            NSDictionary *jsonResponseData = nil;
            jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&responseError];
            
            if (responseError) {
                NSLog(@"Response Parse Error: %@", responseError);
            } else {
                NSString *responseString = [NSString stringWithFormat:@"%@", jsonResponseData];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Predictions" message:responseString preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    
    @catch(NSException *e) {
        NSLog(@"Upload Error: %@", e.reason);
    }
}

@end

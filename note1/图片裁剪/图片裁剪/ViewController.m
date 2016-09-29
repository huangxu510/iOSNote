//
//  ViewController.m
//  图片裁剪
//
//  Created by huangxu on 15/9/18.
//  Copyright (c) 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
- (IBAction)takePicture:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //    image = [self imageWithImage:image scaledToSize:imagesize];
    

    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imageDirectory = [document stringByAppendingString:@"/images"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    
    
    
#if 0
    //对图片大小进行压缩--
    NSData *imageData = UIImageJPEGRepresentation(image,0.1);
    UIImage *scaledImage = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(scaledImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
#endif
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return ;
    
}

@end

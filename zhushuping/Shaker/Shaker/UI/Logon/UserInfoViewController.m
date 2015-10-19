//
//  UserInfoViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-19.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ColorHandler.h"
#import "HomeViewController.h"
#import "Contants.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController {
    UIImageView *picImageView;
    UITextField *nicknameTextField;
    UIGestureRecognizer *tapGestureRecognizer;
    UIActionSheet *myActionSheet;
    NavigationBar *navigationBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    if (navigationBar) {
        [navigationBar removeFromSuperview];
        navigationBar = nil;
    }
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    
    [navigationBar setRightBtnWithString:@"完成" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"个人信息"];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];
    
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    [self buildView];
}

- (void)buildView {
    UIImage *changeUserPicImage = [UIImage imageNamed:@"changeUserPic"];
    UIImageView *changeUserPicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-85-changeUserPicImage.size.width, 108, changeUserPicImage.size.width, changeUserPicImage.size.height)];
    changeUserPicImageView.image = changeUserPicImage;
    [self.view addSubview:changeUserPicImageView];
    
    picImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-89)/2, 137, 89, 89)];
    picImageView.layer.borderColor = [ColorHandler colorWithHexString:@"#00d8a5"].CGColor;
    picImageView.layer.borderWidth = 1;
    picImageView.image = [self getDefaultUserPic];
    [self.view addSubview:picImageView];
    
    UIControl *picImageCtl = [[UIControl alloc] initWithFrame:CGRectMake(picImageView.frame.origin.x-10, picImageView.frame.origin.y-10, picImageView.bounds.size.width+20, picImageView.bounds.size.height+20)];
    [picImageCtl addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:picImageCtl];
    
    nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth-263)/2, 262, 263, 40)];
    nicknameTextField.textAlignment = NSTextAlignmentCenter;
    nicknameTextField.font = [UIFont systemFontOfSize:15];
    nicknameTextField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    nicknameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的昵称" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#c7c7c7"]}];
    nicknameTextField.delegate = self;
    [self.view addSubview:nicknameTextField];
    
}

- (void)resignKeyBoard {
    [nicknameTextField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

- (void)done {
    _user.photo = UIImagePNGRepresentation(picImageView.image);
    _user.name = nicknameTextField.text?nicknameTextField.text:@"";
    _user.desc = @"";
    if ([_database updateUser:_user]) {//update by user_id?uuid?
        [self updateAccountOnServer];
        [self uploadProfileOnServer];
    }
    HomeViewController *homeViewController = [HomeViewController new];
    homeViewController.database = _database;
    homeViewController.user = _user;
    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//    [self presentViewController:navigationController animated:YES completion:nil];
    
    // fix the bug -- will jump to logon view when choose pic.
    [self.navigationController pushViewController:homeViewController animated:YES];
    // fix the bug -- will jump to logon view when choose pic.
}

- (UIImage *)getDefaultUserPic {
    int x = arc4random()%100;
    if (x >= 0 && x <= 10) {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"1"]];
    } else if (x >= 11 && x <= 20) {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"2"]];
    } else if (x >= 21 && x <= 30) {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"3"]];
    } else if (x >= 31 && x <= 40) {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"4"]];
    } else if (x >= 41 && x <= 50) {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"5"]];
    } else if (x >= 51 && x <= 60) {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"6"]];
    } else if (x >= 61 && x <= 70) {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"7"]];
    } else {
        return [UIImage imageNamed:[[NSString alloc] initWithFormat:@"defaultUserPic%@",@"8"]];
    }
}

- (void)updateAccountOnServer {
    //TODO
    NSString *updateAccountService = @"/services/user/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST_4,updateAccountService,_user.ID];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:nicknameTextField.text forKey:@"nickname"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
    }];
    
    [sessionDataTask resume];
}

- (void)uploadProfileOnServer {
    NSData *imgData = UIImageJPEGRepresentation(picImageView.image, 0.5);
    
    NSString *uploadProfileService = @"/services/user/upload/profile";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,uploadProfileService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
    NSMutableData *body = [NSMutableData new];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_user.ID dataUsingEncoding:NSUTF8StringEncoding]];
    if (imgData) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", @"profile",_user.name] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imgData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // set request HTTPHeader
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            NSLog(@"%@",[dataDic valueForKey:@"status"]);
            NSLog(@"%@",[[dataDic valueForKey:@"data"] valueForKey:@"nickname"]);
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"同步失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
        
    }];
    [sessionDataTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

#pragma ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self locolPhoto];
                break;
            default:
                break;
        }
    }    
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"You don't have a camera!");
    }
}

- (void)locolPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    // [self presentModalViewController:picker animated:YES];
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^(){
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [self imageByScalingToMaxSize:image];
        // 裁剪
        ImageCropperViewController *imgEditorVC = [[ImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width)];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark ImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [picImageView setImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}


- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark NavigationBarDelegate
- (void)rightBtnClicked {
    [self done];
}



@end

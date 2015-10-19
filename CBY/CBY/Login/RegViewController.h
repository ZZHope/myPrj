//
//  RegViewController.h
//

#import <UIKit/UIKit.h>

@protocol SecondViewControllerDelegate;

@interface RegViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITextField* areaCodeField;
@property(nonatomic,strong) UITextField* telField;
@property(nonatomic,strong) UIWindow* window;
@property(nonatomic,strong) UIButton* next;

@property(nonatomic,strong) NSString* resetFlag;//重置密码的标志位

-(void)nextStep;

@end

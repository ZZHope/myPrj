//
//  CarBareViewController.m
//  51CBY
//
//  Created by SJB on 14/12/29.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "CarBareViewController.h"
#import "HomeServiceController.h"
#import "CarBareTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNCommon.h"
#import "AFNetworking.h"
#import "CbyUserSingleton.h"

#define kImage @"image"
#define kText  @"text"
#define kCarID @"car_id"

#define width self.view.bounds.size.width

@interface CarBareViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>//UIImagePickerControllerDelegate,UINavigationControllerDelegate
@property(strong, nonatomic) UITableView *tableView;

@property(strong, nonatomic) NSMutableArray *addModelArr;
@property(strong, nonatomic) NSDictionary *detailDic ;
@property(strong, nonatomic) NSMutableDictionary *tempDic;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) CbyUserSingleton *userCar;

@end
static NSString *identifier = @"cellID";
int tagFlag = 0;
int deleFlag = 0;

@implementation CarBareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"我的车型库";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;

    //右视图
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-100, 5, 80, 30)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addModel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //user
    _userCar = [CbyUserSingleton shareUserSingleton];
    
    /*数据源*/
    _addModelArr = [NSMutableArray array];
    _detailDic = [NSDictionary dictionary];
    _tempDic = [NSMutableDictionary dictionary];
    
    //请求
 
    [self getCarBareFromService];

    
    
}
#pragma mark -- 获取车型库
-(void)getCarBareFromService
{
    [MBProgressHUD showMessage:@"正在加载。。。" toView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"manageusercar",
                                kUserID:self.userCar.userID,
                                @"operation":@"get"};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject  objectForKey:@"status"] isEqualToString:@"ok"]) {
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                //从本地获取图片
//                UIImageView *imgView = [[UIImageView alloc]init];
//                [imgView sd_setImageWithURL:[dic objectForKey:@"car_photo"] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
                NSDictionary *dicT = @{kImage:[UIImage imageNamed:[dic objectForKey:@"car_photo"]],
                                       kText:[NSString stringWithFormat:@"%@ %@ %@ %@",[dic objectForKey:@"car_brand"],[dic objectForKey:@"car_type"],[dic objectForKey:@"car_engines"],[dic objectForKey:@"car_builddate"]],
                                       kCarID:[dic objectForKey:@"car_id"]};
                [self.addModelArr addObject:dicT];
            }
            [self.tableView reloadData];
           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    

}

#pragma mark -- tableView delegate/data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarBareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:@"CarBareTableViewCell" owner:self options:nil];
        cell = cellArr[0];
        
    }

    
    cell.carImageView.image =[self.addModelArr[indexPath.row] objectForKey:kImage] ;
    
    NSString *str = [self.addModelArr[indexPath.row] objectForKey:kText];
    cell.carDetailLabel.text = [ NSString stringWithFormat:@"%@",str];
    
    //拍照更换（决定不做了）
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCarImage:)];
//    cell.carImageView.userInteractionEnabled = YES;
//    [cell.carImageView addGestureRecognizer:tapGesture];

    cell.deleteBtn.tag = indexPath.row+1;
    [cell.deleteBtn addTarget:self action:@selector(deleteModel:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.needReturnInfo == 1) {
        if (self.carBareInfo) {
            
            NSString *str = [NSString stringWithFormat:@"%@",[self.addModelArr[indexPath.row] objectForKey:kText]];
            NSDictionary *dic = @{@"text":str,
                                  @"carId":[self.addModelArr[indexPath.row] objectForKey:kCarID]};
            
            self.carBareInfo(dic);
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//返回
-(void)returnCareBareInfo:(CarBareReturn)carBareInfo
{
    self.carBareInfo = carBareInfo;
}

#pragma mark -- target - action
-(void)deleteModel:(UIButton *)sender
{
    deleFlag = (int)(sender.tag-1);
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除车型" message:@"是否确定删除车型" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 102;
    [alertView show];
    
}

-(void)addModel:(UIButton *)sender
{
    
    HomeServiceController *homeService = [[HomeServiceController alloc]init];
   
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"添加车型";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    homeService.navigationItem.titleView = textlabel;
    homeService.labelText = textlabel.text;
    [homeService returnCarModelData:^(NSDictionary *carModel) {
    [self.addModelArr addObject:carModel];
    [self.tableView reloadData];

    }];
    
    
    [self.navigationController pushViewController:homeService animated:YES];
    
   
}


//点击更换图片
//-(void)changeCarImage:(UIGestureRecognizer *)gesture
//{
//   CGPoint point =  [gesture locationInView:self.tableView];
//    
//    tagFlag = (int)(point.y-45)/50;
//    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"更换爱车图片" message:@"可以将图片更换为自己爱车的图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照上传",@"去图片库",nil];
//    alertView.delegate = self;
//    alertView.tag = 101;
//    [alertView show];
//}


#pragma mark -- alertView 更换图片

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

        switch (buttonIndex) {
            case 0:
                
                break;
                
            case 1:{

                if (self.addModelArr.count) {
                   [self deleteCarFromServiceWithCarID];
                }
                
            }
                
                break;
                
            default:
                break;
        }
    }



#pragma mark -- 数据
/* 添加车型在选择车型页面
 此处为删除车型
 */
-(void)deleteCarFromServiceWithCarID
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"manageusercar",
                                kUserID:self.userCar.userID,
                                @"operation":@"delete",
                                @"car_id":[self.addModelArr[deleFlag] objectForKey:@"car_id"]};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            [self.addModelArr removeObjectAtIndex:deleFlag];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"carDel error:%@",error);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

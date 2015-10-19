//
//  CommonseDetailController.m
//  51CBY
//
//  Created by SJB on 15/3/31.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "CommonseDetailController.h"
#import "AFNCommon.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#define  kWidth   self.view.bounds.size.width
#define  kHeight  self.view.bounds.size.height

@interface CommonseDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataDetailArr;
@property(nonatomic,strong) UITableView *tableView;


@end

@implementation CommonseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    //titleLabel
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = titleLabel;
    
    //数据源
    _dataDetailArr = [NSMutableArray array];
    
    [self loadDetailInfo];
    
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-50) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
 
}

#pragma mark -- load data
-(void)loadDetailInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_knowledge.php"];
    NSDictionary *parameter = @{@"operation":@"9",
                                @"infoId":self.commonInfoId};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.dataDetailArr removeAllObjects];

            [self.dataDetailArr addObject:[responseObject objectForKey:@"data"]];
           
            [self.tableView reloadData];
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"common care error:%@",error);
    }];

}


#pragma mark -- table delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2*self.dataDetailArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataDetailArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellId";
    static NSString *identify2 = @"cell2";
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        
     
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n ", [self.dataDetailArr[indexPath.section] objectForKey:@"title"]];
            cell.textLabel.numberOfLines = 3;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
            cell.detailTextLabel.text = [self.dataDetailArr[0] objectForKey:@"time"];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
       
    }else{
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify2];
        }
        
        cell.textLabel.text = [self.dataDetailArr[indexPath.section] objectForKey:@"content"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textAlignment = NSTextAlignmentJustified;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    [imgView sd_setImageWithURL:[self.dataDetailArr[section] objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
  
    return imgView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100.0f;
    }else{
        
        NSString *str = [self.dataDetailArr[indexPath.section] objectForKey:@"content"];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(kWidth-10, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
        return ceil(rect.size.height+130.0f);//考虑其中换行空格的余量

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 200.0f;
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

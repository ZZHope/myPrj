//
//  CarModelsView.m
//  51CBY
//
//  Created by SJB on 14/12/17.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "CarModelsView.h"
#import "CollectionCell.h"
#import "ModelViewController.h"

#import "CbyDataBaseManager.h"
#import "DBCommon.h"
#import "UIImageView+WebCache.h"

#define MIN_CHAR 'A'
#define MAX_CHAR 'Z'

@interface CarModelsView ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySC;
- (IBAction)changeAction:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray* dataSource;


@property(nonatomic,strong)NSDictionary* dic1;
@property(nonatomic,strong)NSDictionary* dic2;

@property(nonatomic,strong)NSArray* hotCarArr;
@property(nonatomic,strong)NSArray* allCarArr;

@property (strong, nonatomic) NSString *string;


@end

@implementation CarModelsView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"车型库";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = textlabel;

    }
    return self;
}

- (void)viewDidLoad {
    
    self.collectionView.frame = CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height-41);
    self.tableView.frame = CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height-41);
    
    [super viewDidLoad];
    
    [self mySegmented];
    
    [self collection];
    
    _hotCarArr = [NSArray array];
    _allCarArr = [NSArray array];
    CbyDataBaseManager * cbyCar = [CbyDataBaseManager shareInstance];
    
    self.allCarArr = [cbyCar carBrandQueryFromDB:kCarTable];

    self.hotCarArr = [cbyCar carPopularQueryFromDB:kCarTable];

    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.allCarArr.count; i++) {
        [array addObject:[self.allCarArr[i] objectForKey:@"n"]];
    }
    
    NSMutableArray *hotArr = [NSMutableArray array];
    for (int i = 0; i <  self.hotCarArr.count; i++) {
        [hotArr addObject:[self.hotCarArr[i] objectForKey:@"n"]];
    }

}

#pragma mark ========设置Segmented样式=========
-(void)mySegmented
{
    
    [self.mySC setBackgroundImage:[UIImage imageNamed:@"浅蓝.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mySC setBackgroundImage:[UIImage imageNamed:@"深蓝.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    NSDictionary *selectedAtt  = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    
    [self.mySC setTitleTextAttributes:selectedAtt forState:UIControlStateSelected];
}


//collectionViewController的方法，不写将会不显示或者崩溃，
-(void)collection{
    
    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    //collectionView的背景色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)changeAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex==0) {
        [self.view bringSubviewToFront:self.collectionView];
        self.collectionView.hidden = NO;
    }else
        self.collectionView.hidden = YES;
    
}


//——————————————————————————————————————————————————————————————————————————————————————————

#pragma mark ===========热门车型==============


//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.hotCarArr.count;
}


//设置Cell的图片内容和文本

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    //设置label文字
    cell.label.text = [self.hotCarArr[indexPath.row] objectForKey:@"n"];
    cell.imageView.image = [UIImage imageNamed:[self.hotCarArr[indexPath.row] objectForKey:@"img"]];
    
    return cell;
}

//点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModelViewController* mc = [[ModelViewController alloc]init];

    self.string = [self.hotCarArr[indexPath.row] objectForKey:@"i"];
    
    mc.string = self.string;
    mc.carName = [self.hotCarArr[indexPath.row] objectForKey:@"n"];
    mc.dic = self.dic;
    [self.navigationController pushViewController:mc animated:YES];

}



//----------------------------全部车型----------------------------

#pragma mark ===========全部车型===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.allCarArr.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    cell.textLabel.text = [self.allCarArr[indexPath.row] objectForKey:@"n"];
    cell.imageView.image = [UIImage imageNamed:[self.allCarArr[indexPath.row] objectForKey:@"img"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}


#pragma mark ==========Cell点击触发的事件===========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelViewController* mc = [[ModelViewController alloc]init];
    
    mc.carName = [self.allCarArr[indexPath.row] objectForKey:@"n"];
    
    self.string = [self.allCarArr[indexPath.row] objectForKey:@"i"];
    mc.string = self.string;
    mc.dic = self.dic;
    [self.navigationController pushViewController:mc animated:YES];
    
}


//设置每一个区域（分段）的名称
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%c",(char)(section + 65)];
//}

#pragma mark ===========添加索引条===========
//-(NSArray  *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    //表单视图的右侧 A~Z这样的小字母  第一项 放大镜
//    NSMutableArray * titles = [[NSMutableArray alloc] init];
//    //把索引的数据添加到titles数组里
//    [titles addObject:UITableViewIndexSearch];
//    //创建索引提示的内容 A~Z
//    for(int i = MIN_CHAR;i <= MAX_CHAR;i++)
//    {
//        [titles addObject:[NSString stringWithFormat:@"%c",i]];
//    }
//    
//    return titles;
//}

//设置索引条的对应关系
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if(0 == index)
//    {
//        //让TableView滚动到某一个frame位置
//        return -1;
//    }
//    else
//    {
//        //-1减去前面的搜索
//        return index - 1;
//    }
//}

@end

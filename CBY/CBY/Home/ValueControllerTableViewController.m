//
//  ValueControllerTableViewController.m
//  51CBY
//
//  Created by SJB on 14/12/18.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "ValueControllerTableViewController.h"
#import "Score.h"
#import "HomeViewController.h"
#import "CbyUserSingleton.h"

#define kTitle  @"title"
#define kContrain @"constrain"
#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height
#define windowHeight [[UIApplication sharedApplication].delegate window].bounds.size.height
#define kMarginHeight 50
@interface ValueControllerTableViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) NSMutableArray *evaluateArr;
@property(nonatomic,strong) NSArray *accessoryArr;
@property(nonatomic,strong) UIPickerView *timePickerView;
@property(nonatomic,strong) NSMutableArray *pickerDataArr;
@property(nonatomic,strong) NSMutableDictionary *scoreArr;
@property(nonatomic,strong) UIView *pickBackgroundView;
@property(nonatomic,strong) UIButton *tempButton;
@property(nonatomic,strong) NSMutableArray *tempArr;

//保存历史数据
@property(nonatomic,strong) NSArray *historyDataArr;
@property(nonatomic,strong) CbyUserSingleton *carInfo;


@end

static NSString *evaluteIdentifier = @"evaluteID";
 BOOL  isLineYes = NO;
 BOOL  isEgineRepair = NO;
@implementation ValueControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    self.evaluateArr = [NSMutableArray array];
     [self.evaluateArr addObject:@{kTitle:@"车龄",kContrain:@"建议上限：10年"}];
     [self.evaluateArr addObject:@{kTitle:@"公里数",kContrain:@"建议上限：30万公里"}];
     [self.evaluateArr addObject:@{kTitle:@"保养",kContrain:@"建议频率：半年/次"}];
     [self.evaluateArr addObject:@{kTitle:@"防冻液",kContrain:@"建议频率：1年/次"}];
     [self.evaluateArr addObject:@{kTitle:@"电瓶更换",kContrain:@"建议频率：3年/次"}];
     [self.evaluateArr addObject:@{kTitle:@"线路老化保养",kContrain:@"建议频率：终身/次"}];
     [self.evaluateArr addObject:@{kTitle:@"轮胎保养",kContrain:@"建议频率：6万公里/次"}];
     [self.evaluateArr addObject:@{kTitle:@"雨刷更换",kContrain:@"建议频率：半年/次"}];
     [self.evaluateArr addObject:@{kTitle:@"发动机清洗",kContrain:@"建议频率：半年/次"}];
     [self.evaluateArr addObject:@{kTitle:@"发动机大修",kContrain:@"是否大修过"}];
    
    self.accessoryArr = [NSArray array];
    self.accessoryArr = @[@"xx年",@"xx万公里",@"xx月前保养",@"xx月前更换",@"xx年前更换",@"是否已经保养",@"已经行驶xx万公里",@"xx月前更换",@"xx月前清洗",@"是否大修过"];
    
    //历史数据
    
    _historyDataArr = [NSArray array];
    
    //单例
    
    _carInfo = [CbyUserSingleton shareUserSingleton];
    //
    
    _tempArr = [NSMutableArray arrayWithArray:self.accessoryArr];
    

    /*picker 数据源*/
    
    self.pickerDataArr = [NSMutableArray array];
    for (int i=1; i<40; i++) {
        [self.pickerDataArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.scoreArr = [NSMutableDictionary dictionary];
    [self.scoreArr setObject:@NO forKey:@"line"];
    [self.scoreArr setObject:@NO forKey:@"hugeRepaire"];
    
    /*timePickerView*/
    //backgroundView
    _pickBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, windowHeight, Width, 216)];
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width-100, 5,80, 30)];
    [sureBtn setTitle:@"确定" forState: UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor lightGrayColor];
    [sureBtn addTarget:self action:@selector(makeSureTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickBackgroundView addSubview:sureBtn];
    _timePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(100,40, Width-200, 80)];
    self.timePickerView.delegate = self;
    self.timePickerView.dataSource = self;
    self.timePickerView.backgroundColor = [UIColor lightGrayColor];
    [self.pickBackgroundView addSubview:self.timePickerView];
    self.pickBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate  window];
    [window addSubview:self.pickBackgroundView];
    //[self.view addSubview:self.pickBackgroundView];

    //右视图
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [settingBtn setTitle:@"确定" forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [settingBtn addTarget:self action:@selector(evalueResult:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.evaluateArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.historyDataArr = @[self.carInfo.carAge,self.carInfo.carJurney,self.carInfo.carCare,self.carInfo.carUnfrozen,self.carInfo.carPower,self.carInfo.carLine,self.carInfo.carTire,self.carInfo.carRain,self.carInfo.carEngin,self.carInfo.carRepair];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:evaluteIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:evaluteIdentifier];
    }
    
    cell.textLabel.text = [self.evaluateArr[indexPath.row]objectForKey:kTitle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"  %@",[self.evaluateArr[indexPath.row]objectForKey:kContrain]];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    if ([self.historyDataArr[indexPath.row] length]) {
         _tempButton = [self buttonWithTitle:self.historyDataArr[indexPath.row]];
    }else{
        _tempButton = [self buttonWithTitle:self.accessoryArr[indexPath.row]];
    }
    cell.accessoryView = self.tempButton;
    
    cell.accessoryView.tag = indexPath.row+1001;

    return cell;
}

//delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -- customBtn
-(UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 100, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btn setImage:[UIImage imageNamed:@"text"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 3.0f;
    
    return btn;
}




#pragma mark -- pickerView dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
    return self.pickerDataArr.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerDataArr[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
 
    if (self.tempButton.tag == 1001) {
         [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"age"];
      
        [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@年",self.pickerDataArr[row]]];
        self.carInfo.carAge = [NSString stringWithFormat:@"%@年",self.pickerDataArr[row]];
        
    }else if (self.tempButton.tag == 1002){
        
        [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"jurney"];
        [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@万公里",self.pickerDataArr[row]]];
        self.carInfo.carJurney = [NSString stringWithFormat:@"%@万公里",self.pickerDataArr[row]];
        
    }else if (self.tempButton.tag == 1003){
        [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"care"];
        
         [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]]];
        self.carInfo.carCare = [NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]];
        
    }else if (self.tempButton.tag == 1004){
        [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"unFrozen"];
        
        [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]]];
        self.carInfo.carUnfrozen = [NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]];
        
        
    }else if (self.tempButton.tag == 1005){
        [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"changePower"];
        
        [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]]];
        
        self.carInfo.carPower = [NSString stringWithFormat:@"%@年前",self.pickerDataArr[row]];
        
    }else if (self.tempButton.tag == 1007){
        [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"tire"];
        [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@万公里",self.pickerDataArr[row]]];
        self.carInfo.carTire = [NSString stringWithFormat:@"%@万公里",self.pickerDataArr[row]];
        
    }else if (self.tempButton.tag == 1008){
         [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"rain"];
        [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]]];
        self.carInfo.carRain = [NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]];
        
    }else if (self.tempButton.tag == 1009){
        
        [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"engin"];

         [self.tempArr replaceObjectAtIndex:(self.tempButton.tag-1001) withObject:[NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]]];
        self.carInfo.carEngin = [NSString stringWithFormat:@"%@个月前",self.pickerDataArr[row]];
    }
    
    self.accessoryArr = self.tempArr;

    [self.tableView reloadData];
    [self.scoreArr setObject:self.pickerDataArr[row] forKey:@"age"];

}


#pragma mark -- target -action
-(void)makeSureTime:(UIButton *)sender
{
    
    [self.timePickerView selectRow:0 inComponent:0 animated:YES];
    [self animationShowPicker];

    
}


-(void)showPickerView:(UIButton *)sender
{

    self.tempButton = sender;
    if (sender.tag != 1006 &&sender.tag != 1010) {
        self.pickBackgroundView.frame = CGRectMake(0, windowHeight-216, Width, 216);
    }else if (sender.tag == 1006){

        [self animationShowPicker];
        isLineYes = !isLineYes;
        if (isLineYes) {
            
            [sender setTitle:@"是" forState:UIControlStateNormal];
            [self.tempArr replaceObjectAtIndex:(sender.tag-1001) withObject:@"是"];
            self.accessoryArr = self.tempArr;
            [self.scoreArr setObject:@YES forKey:@"line"];
            self.carInfo.carLine = @"是";
            
        }else{
            [sender setTitle:@"否" forState:UIControlStateNormal];
            [self.tempArr replaceObjectAtIndex:(sender.tag-1001) withObject:@"否"];
            self.accessoryArr = self.tempArr;
             [self.scoreArr setObject:@NO forKey:@"line"];
            self.carInfo.carLine = @"否";
           
        }

    }else if (sender.tag == 1010){
        [self animationShowPicker];
        isEgineRepair = !isEgineRepair;
        if (isEgineRepair) {
            [sender setTitle:@"是" forState:UIControlStateNormal];
            [self.tempArr replaceObjectAtIndex:(sender.tag-1001) withObject:@"是"];
            self.accessoryArr = self.tempArr;
            [self.scoreArr setObject:@YES forKey:@"hugeRepaire"];
            self.carInfo.carRepair = @"是";
        }else{
        
            [sender setTitle:@"否" forState:UIControlStateNormal];
            [self.tempArr replaceObjectAtIndex:(sender.tag-1001) withObject:@"否"];
            self.accessoryArr = self.tempArr;
            [self.scoreArr setObject:@NO forKey:@"hugeRepaire"];
            self.carInfo.carRepair = @"否";
        }

    }
   
}

-(void)animationShowPicker
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
     self.pickBackgroundView.frame =  CGRectMake(0,windowHeight, Width, 216);
    [UIView commitAnimations];
}

//评分返回
-(void)evalueResult:(UIBarButtonItem *)item
{
    Score *scoreModal = [[Score alloc]init];
    scoreModal.age = [self.scoreArr objectForKey:@"age"];
    scoreModal.care = [self.scoreArr objectForKey:@"care"];
    scoreModal.jurney = [self.scoreArr objectForKey:@"jurney"];
    scoreModal.unFrozen = [self.scoreArr objectForKey:@"unFrozen"];
    scoreModal.changePower = [self.scoreArr objectForKey:@"changePower"];
    scoreModal.tire = [self.scoreArr objectForKey:@"tire"];
    scoreModal.rain = [self.scoreArr objectForKey:@"rain"];
    scoreModal.engin = [self.scoreArr objectForKey:@"engin"];
    scoreModal.hugeRepaire = [[self.scoreArr objectForKey :@"hugeRepaire"] boolValue] ;
    scoreModal.line = [[self.scoreArr objectForKey:@"line"] boolValue];
    

    self.estimateScore = [scoreModal scoreValue];
     HomeViewController *homeVC =  self.navigationController.viewControllers[0];
    homeVC.valueDic = self.scoreArr;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark -- bolck传递回去评分值
-(void)returnScore:(ReturnScoreBlock)block
{
    self.returnScoreBlock = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self animationShowPicker];
    if (self.returnScoreBlock != nil) {
        self.returnScoreBlock(self.estimateScore);
    }
}





@end

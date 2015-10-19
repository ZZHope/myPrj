//
//  CreateNewPostViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "CreateNewPostViewController.h"
#import "Contants.h"
#import "ColorHandler.h"
#import "UIImage+Common.h"
#import "ShareViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "ProgressHUD.h"

@interface CreateNewPostViewController ()

@end

@implementation CreateNewPostViewController {
    NavigationBar *navigationBar;
    UIView *contentView;
    UIView *bottomBar;
    UIImageView *cardImageView;
    UITextView *cardContentView;
    UITapGestureRecognizer *tapGesture;
    UITapGestureRecognizer *tap;
    UIActionSheet *myActionSheet;
    NSMutableAttributedString *contentPlaceholder;
    NSMutableArray *layoutContentArray;
    NSInteger currentLayoutIndex;
    NSInteger currentCardIndex;
    Card *card;
    UIWebView *createPostWebView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)setCurrentCard:(Card *)currentCard {
    if ((int)currentCard.layoutIndex == 1) {
        [self buildLayout1];
        currentLayoutIndex = 1;
    } else if ((int)currentCard.layoutIndex == 2) {
        [self buildLayout2];
        currentLayoutIndex = 2;
    } else if ((int)currentCard.layoutIndex == 3) {
        [self buildLayout3];
        currentLayoutIndex = 3;
    } else if ((int)currentCard.layoutIndex == 4) {
        [self buildLayout4];
        currentLayoutIndex = 4;
    } else if ((int)currentCard.layoutIndex == 5) {
        [self buildLayout5];
        currentLayoutIndex = 5;
    } else if ((int)currentCard.layoutIndex == 6) {
        [self buildLayout6];
        currentLayoutIndex = 6;
    }
    
    cardImageView.image = currentCard.image;
    cardContentView.text = currentCard.content;
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"returnIcon"]];
//    [navigationBar setRightBtnWithString:@"发布" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_topic.title];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];
    [navigationBar setBackColor:[UIColor whiteColor]];
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)createNewPost {
    _post = [Post new];
    _post.creatorID =_user.userID;
    _post.creatorName = _user.name;
    _post.creatorImage = [UIImage imageWithData:_user.photo];
    //TODO
}

- (void)createNewCard {
    card = [Card new];
    //TODO
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildCreatePostWebView];
}

- (void)buildCreatePostWebView {
    createPostWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-40)];
    createPostWebView.scrollView.bounces = NO;
    createPostWebView.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    NSString *createPostURLString = [[NSString alloc] initWithFormat:@"%@/entity/%@/join?_username=%@&_password=%@",HOST_4,_topic.UUID,_user.userID,[self md5HexDigest:_user.password]];
    [createPostWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:createPostURLString]]];
    [self.view addSubview:createPostWebView];
}

- (NSString *)md5HexDigest:(NSString*)input {
    if (!input) {
        return @"";
    }
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (void)buildView {
    [self buildContentView];
    [self buildBottomBar];
}

- (void)buildContentView {
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight-44-64)];
    [self.view addSubview:contentView];
    [self buildLayout1];
}

- (void)buildBottomBar {
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-44, viewWidth, 44)];
    [self.view addSubview:bottomBar];
    [self.view bringSubviewToFront:bottomBar];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5f)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    [bottomBar addSubview:line];
    
    UIImage *postAdded = [UIImage imageNamed:@"postAdded"];
    UIImage *postNew = [UIImage imageNamed:@"postNew"];
    UIImage *layout = [UIImage imageNamed:@"topic_layout"];
    
    UIButton *postAddedBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, (bottomBar.bounds.size.height-postAdded.size.height)/2, postAdded.size.width, postAdded.size.height)];
    postAddedBtn.tag = 1;
    [postAddedBtn addTarget:self action:@selector(clickOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [postAddedBtn setImage:postAdded forState:UIControlStateNormal];
    [bottomBar addSubview:postAddedBtn];
    
    UIButton *postNewBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, (bottomBar.bounds.size.height-postNew.size.height)/2, postNew.size.width, postNew.size.height)];
    postNewBtn.tag = 2;
    [postNewBtn addTarget:self action:@selector(clickOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [postNewBtn setImage:postNew forState:UIControlStateNormal];
    [bottomBar addSubview:postNewBtn];
    
    UIButton *layoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(274, (bottomBar.bounds.size.height-layout.size.height)/2, layout.size.width, layout.size.height)];
    layoutBtn.tag = 3;
    [layoutBtn addTarget:self action:@selector(clickOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [layoutBtn setImage:layout forState:UIControlStateNormal];
    [bottomBar addSubview:layoutBtn];
}

- (void)generateTopicLayoutArray {
    if (layoutContentArray) {
        [layoutContentArray removeAllObjects];
        layoutContentArray = nil;
    }
    UIImage *layoutContentImage1 = [UIImage imageNamed:@"layout1_285440"];
    UIImage *layoutContentImage2 = [UIImage imageNamed:@"layout2_285440"];
    UIImage *layoutContentImage3 = [UIImage imageNamed:@"layout3_285440"];
    UIImage *layoutContentImage4 = [UIImage imageNamed:@"layout4_285440"];
    UIImage *layoutContentImage5 = [UIImage imageNamed:@"layout5_285440"];
    UIImage *layoutContentImage6 = [UIImage imageNamed:@"layout6_285440"];
    
    [layoutContentArray addObject:layoutContentImage1];
    [layoutContentArray addObject:layoutContentImage2];
    [layoutContentArray addObject:layoutContentImage3];
    [layoutContentArray addObject:layoutContentImage4];
    [layoutContentArray addObject:layoutContentImage5];
    [layoutContentArray addObject:layoutContentImage6];
}

#pragma mark build layout
- (void)buildLayout1 {
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-44-64)];
    [cardImageView setUserInteractionEnabled:YES];
    [cardImageView addGestureRecognizer:tap];
    //set image
    if (card.image) {
        cardImageView.image = card.image;
    } else {
        cardImageView.image = [UIImage imageNamed:@"topic_bg"];
    }
    [contentView addSubview:cardImageView];
    
    //set content
    cardContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-270)/2, 312, 270, 30)];
    cardContentView.tag = 2;
    cardContentView.delegate = self;
    cardContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    cardContentView.layer.borderWidth = 0.8f;
    cardContentView.backgroundColor = [UIColor clearColor];
    cardContentView.textColor = [UIColor whiteColor];
    cardContentView.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
    if (card.content) {
        cardContentView.text = card.content;
    } else {
        cardContentView.attributedText = contentPlaceholder;
    }
    cardContentView.textAlignment = NSTextAlignmentCenter;
    [cardImageView addSubview:cardContentView];
    cardImageView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        cardImageView.alpha = 1;
    }];
}

- (void)buildLayout2 {
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-44-64)];
    [cardImageView setUserInteractionEnabled:YES];
    [cardImageView addGestureRecognizer:tap];
    //set image
    cardImageView.image = [UIImage imageNamed:@"topic_bg"];
    [contentView addSubview:cardImageView];
    
    cardContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-270)/2, 312, 270, 30)];
    cardContentView.tag = 2;
    cardContentView.delegate = self;
    //    cardContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    cardContentView.layer.borderWidth = 0.8f;
    cardContentView.backgroundColor = [UIColor clearColor];
    cardContentView.textColor = [UIColor whiteColor];
    cardContentView.font = [UIFont fontWithName:@"STSong" size:16];
    cardContentView.attributedText = contentPlaceholder;
    cardContentView.textAlignment = NSTextAlignmentCenter;
    [cardImageView addSubview:cardContentView];
    cardImageView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        cardImageView.alpha = 1;
    }];
}

- (void)buildLayout3 {
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-335)/2, 20, 335, 335)];
    [cardImageView setUserInteractionEnabled:YES];
    [cardImageView addGestureRecognizer:tap];
    //set image
    cardImageView.image = [UIImage imageNamed:@"topic_bg"];
    [contentView addSubview:cardImageView];
    
    cardContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-319)/2, 476, 319, 40)];
    cardContentView.tag = 2;
    cardContentView.delegate = self;
    //    cardContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    cardContentView.layer.borderWidth = 0.8f;
    cardContentView.backgroundColor = [UIColor clearColor];
    cardContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    cardContentView.font = [UIFont fontWithName:@"STSong" size:16];
    cardContentView.attributedText = contentPlaceholder;
    [contentView addSubview:cardContentView];
    cardImageView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        cardImageView.alpha = 1;
    }];
    
}

- (void)buildLayout4 {
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-288)/2, 78, 288, 288)];
    [cardImageView setUserInteractionEnabled:YES];
    cardImageView.layer.cornerRadius = cardImageView.bounds.size.width/2;
    cardImageView.layer.masksToBounds = YES;
    [cardImageView addGestureRecognizer:tap];
    //set image
    cardImageView.image = [UIImage imageNamed:@"topic_bg"];
    [contentView addSubview:cardImageView];
    
    cardContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-275)/2, 470, 275, 40)];
    cardContentView.tag = 2;
    cardContentView.delegate = self;
    //    cardContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    cardContentView.layer.borderWidth = 0.8f;
    cardContentView.backgroundColor = [UIColor clearColor];
    cardContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    cardContentView.font = [UIFont fontWithName:@"STSong" size:16];
    cardContentView.attributedText = contentPlaceholder;
    cardContentView.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:cardContentView];
    cardImageView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        cardImageView.alpha = 1;
    }];
    
}

- (void)buildLayout5 {
    cardContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-275)/2, 305, 275, 40)];
    cardContentView.tag = 2;
    cardContentView.delegate = self;
    //    cardContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    cardContentView.layer.borderWidth = 0.8f;
    cardContentView.backgroundColor = [UIColor clearColor];
    cardContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    cardContentView.font = [UIFont fontWithName:@"STSong" size:16];
    cardContentView.attributedText = contentPlaceholder;
    //    cardContentView.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:cardContentView];
}

- (void)buildLayout6 {
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(42, 150, 292, 0.5)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    [contentView addSubview:line1];
    
    cardContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-275)/2, 305, 275, 40)];
    cardContentView.tag = 2;
    cardContentView.delegate = self;
    //    cardContentView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    cardContentView.layer.borderWidth = 0.8f;
    cardContentView.backgroundColor = [UIColor clearColor];
    cardContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    cardContentView.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
    cardContentView.attributedText = contentPlaceholder;
    //    cardContentView.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:cardContentView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(42, 429, 292, 0.5)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    [contentView addSubview:line2];
    
}

- (void)resetLayout {
    if (cardImageView) {
        [cardImageView removeFromSuperview];
        cardImageView = nil;
    }
    if (cardContentView) {
        [cardContentView removeFromSuperview];
        cardContentView = nil;
    }
    if (currentLayoutIndex == 0) {
        [self buildLayout1];
    } else if (currentLayoutIndex == 1) {
        [self buildLayout2];
    } else if (currentLayoutIndex == 2) {
        [self buildLayout3];
    } else if (currentLayoutIndex == 3) {
        [self buildLayout4];
    } else if (currentLayoutIndex == 4) {
        [self buildLayout5];
    } else if (currentLayoutIndex == 5) {
        [self buildLayout6];
    } else {
        [self buildLayout1];
    }
}

- (void)resetCard {
    [self createNewCard];
    [self resetLayout];
}

- (void)clickOnBtn:(UIButton *)btn {
    if (btn.tag == 1) {
        [self addCard];
        AddedPostViewController *addedPostController = [AddedPostViewController new];
        addedPostController.addedCardArray = _post.cards;
        addedPostController.delegate = self;
        addedPostController.user = _user;
        addedPostController.database = _database;
        [self.navigationController pushViewController:addedPostController animated:YES];
    } else if (btn.tag == 2) {
        //save post to Array
        [self addCard];
        currentCardIndex ++;
        //Create New card
        [self resetCard];
        
    } else if (btn.tag == 3) {
        ChooseTopicLayoutViewController *chooseLayoutController = [ChooseTopicLayoutViewController new];
        chooseLayoutController.delegate =self;
        chooseLayoutController.user = _user;
        chooseLayoutController.database = _database;
        if (layoutContentArray.count > currentLayoutIndex) {
            chooseLayoutController.contentImage = [layoutContentArray objectAtIndex:currentLayoutIndex];
        } else {
            chooseLayoutController.contentImage = [UIImage imageNamed:@"layout1_285440"];
        }
        [self.navigationController pushViewController:chooseLayoutController animated:YES];
    }
    
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

- (void)resignKeyBoard {
    [cardContentView resignFirstResponder];
    [cardImageView removeGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    float offset;
    if (currentLayoutIndex == 0 || currentLayoutIndex == 1) {
        offset = -30;
    } else if (currentLayoutIndex == 2 || currentLayoutIndex == 3) {
        offset = -viewHeight/2;
    }
    [contentView setFrame:CGRectMake(0, offset, contentView.bounds.size.width, contentView.bounds.size.height)];
    [contentView addGestureRecognizer:tapGesture];
    [textView becomeFirstResponder];
    if ([textView.text isEqualToString:contentPlaceholder.string]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.attributedText = contentPlaceholder;
        card.content = @"";
    } else {
        card.content = textView.text;
    }
    
    [contentView setFrame:CGRectMake(0, 64, contentView.bounds.size.width, contentView.bounds.size.height)];
    [self resignKeyBoard];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.length+range.location > textView.text.length) {
        return NO;
    }
    NSInteger newLength = [textView.text length] + [text length] - range.length;
    NSString *newString = [[NSString alloc] initWithFormat:@"%@%@",textView.text,text];
    CGSize size = [newString sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    if (newLength <= 208) {
        if (cardContentView.bounds.size.height < 317) {
            float h = ceilf(size.width)*ceilf(newLength/16) + 30;
            [cardContentView setFrame:CGRectMake(cardContentView.frame.origin.x, (cardImageView.bounds.size.height-h)/2, 270, h)];
        }
        return YES;
    }
    return NO;
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
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(){
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        cardImageView.image = image;
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark ChooseTopicLayoutDelegate
- (void)didChooseLayout:(NSInteger)layoutIndex {
    currentLayoutIndex = layoutIndex;
    [self resetLayout];
}

#pragma mark AddedPostViewControllerDelegate
- (void)didEditCardArray:(NSMutableArray *)cardArray atIndex:(NSInteger)index {
    _post.cards = cardArray;
    currentCardIndex = index;
    if ([_post.cards count] == 0) {
        return;
    }
    [self setCurrentCard:[_post.cards objectAtIndex:currentCardIndex]];
}


#pragma 返回按钮修改
#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    [self addCard];
    [self savePost];
    ShareViewController *share = [ShareViewController new];
    share.user = _user;
    share.database = _database;
    share.post = _post;
}

- (void)addCard {
    card.content = cardContentView.text;
    card.image = cardImageView.image;
    card.cardImage = [UIImage imageCapture:cardImageView];
    [_post.cards addObject:card];
}

- (void)savePost {
    [_database createNewPost:_post];
}

- (void)savePostOnServer {
    
}

#pragma mark Share Button Actions
- (void)wechatSessionShare {
    NSString *theme = _topic.title;
    UIImage *image = _topic.topicImage;
    NSString *content = [[_topic.content substringToIndex:10] stringByAppendingString:@"..."];
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/services/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneSession :theme :content :image :[NSURL URLWithString:URLString]];
}

- (void)wechatTimelineShare {
    NSString *theme = _topic.title;
    UIImage *image = _topic.topicImage;
    NSString *content = [[_topic.content substringToIndex:10] stringByAppendingString:@"..."];
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/services/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneTimeline :theme :content :image :[NSURL URLWithString:URLString]];
}

- (void)sinaWeiboShare {
    NSString *theme = _topic.title;
    UIImage *image = _topic.topicImage;
    NSString *content = [[_topic.content substringToIndex:10] stringByAppendingString:@"..."];
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/services/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendWBLinkeContent:content :theme :image :[NSURL URLWithString:URLString]];
}


#pragma mark ShareViewControllerDelegate
- (void)share:(NSInteger)type {
    if (type == WXTimeLine) {
        [self wechatTimelineShare];
    } else if (type == WXSession) {
        [self wechatSessionShare];
    } else if (type == SinaWB) {
        [self sinaWeiboShare];
    }
}

@end

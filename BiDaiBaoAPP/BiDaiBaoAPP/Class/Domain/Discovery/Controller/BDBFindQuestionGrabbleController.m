//
//  ViewController.m
//  BDB_FindQuestionGrabble
//
//  Created by moon on 15/6/11.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import "BDBFindQuestionGrabbleController.h"
#import "BDBHotTopicsResponseModel.h"
#import "BDBHotTopicsModel.h"

#import "BDBQuestionListTableViewController.h"

typedef enum{
    
     returnTimeUp,
    returnTimeDown,
    ReturnTimeEqual
    
}ReturnTimeUpOrDown;


@interface BDBFindQuestionGrabbleController () <UITextFieldDelegate>

@property (nonatomic,assign) ReturnTimeUpOrDown returnUpOrDown;
@property (nonatomic,assign) NSInteger gap;
@property (nonatomic,assign) NSInteger returnTime;
@property (nonatomic,assign) NSInteger titleStringWidth;
@property (nonatomic,assign) NSInteger titleStringWidthBefore;
@property (nonatomic,assign) NSInteger screenWidth;
@property (nonatomic,assign) NSInteger overflowToScreen;
@property (nonatomic,assign) NSInteger buttonTag;


@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIView *View2_2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *hotSearchView;


@end

@implementation BDBFindQuestionGrabbleController
//初始化当前return的次数为1
//初始化前后两次return的title内容的长度为相等
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        self.returnTime = 1;
        self.returnUpOrDown = ReturnTimeEqual;
        CGRect rect = [[UIScreen mainScreen] bounds];
           self.screenWidth = rect.size.width;
       
        self.overflowToScreen = 0 ;
        self.buttonTag = 2;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    热门搜索button
    BDBFindQuestionButton *hotButton_1 = [[BDBFindQuestionButton alloc] init];
    BDBFindQuestionButton *hotButton_2 = [[BDBFindQuestionButton alloc] init];
    BDBFindQuestionButton *hotButton_3 = [[BDBFindQuestionButton alloc] init];
    BDBFindQuestionButton *hotButton_4 = [[BDBFindQuestionButton alloc] init];
    [self.View2_2 addSubview:hotButton_1];
    [self.View2_2 addSubview:hotButton_2];
    [self.View2_2 addSubview:hotButton_3];
    [self.View2_2 addSubview:hotButton_4];
    
    NSString *hVFL = @"H:|-10-[hotButton_1(==hotButton_2)]-10-[hotButton_2(==hotButton_3)]-10-[hotButton_3(==hotButton_4)]-10-[hotButton_4(==hotButton_1)]-0-|";
    NSArray *buttonOfRowOne =[NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"hotButton_1":hotButton_1,@"hotButton_2":hotButton_2,@"hotButton_3":hotButton_3,@"hotButton_4":hotButton_4}];
    [self.view addConstraints:buttonOfRowOne];
    
    
    
    NSLayoutConstraint *buttonGapOfRowOne = [NSLayoutConstraint constraintWithItem:hotButton_1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hotSearchView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20];
    

    [self.view addConstraint:buttonGapOfRowOne];

    _textField.returnKeyType = UIReturnKeySearch;
    _textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.delegate = self;
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
//    用这个方法把搜索框里的值传到BDBQuestionListTableViewController中
    BDBQuestionListTableViewController *controller = (BDBQuestionListTableViewController *) segue.destinationViewController;
    
    controller.TitleKey = _textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    

 
    
    if (self.textField.text.length == 0) {
     
    }else {
        
           [self performSegueWithIdentifier:@"toBDBQuestionListTableViewController" sender:self];
        
        self.textFieldText = self.textField.text;
       
        
        
    BDBFindQuestionButton *button = [[BDBFindQuestionButton alloc] init];
        
        button.tag = _buttonTag;
        if (button.tag == 2) {
//            按钮点击触发事件
               [button addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
        }
     
//    用户输入的内容的长度
    NSString *titleString = self.textField.text;
    self.titleStringWidth = titleString.length;
    
    [button setTitle:titleString forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:button];
        self.buttonTag++;
        
//        如果button超出屏幕 换行生成
        
//        前一个button的左边距到父视图的距离 + (前一个button内容的字数 * 单个button的点数 + 两边留白) + 当前button内容的字数 * 单个button的点数 + 两边留白 + 父视图右边距留白 >= 屏幕宽度
        if (_gap + (_titleStringWidthBefore * 17 + 20) + _titleStringWidth * 17 + 20 + 20>= self.screenWidth) {
         
            
            self.returnTime = 1;
            self.gap = 0;
            self.overflowToScreen ++;
        }

        
            //    顶部约束   constant: button的上下间距 * (超出屏幕的次数 + 1) + 单个button的高度 * (超出屏幕的次数)
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.scrollView
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f
                                                                              constant:13 * (_overflowToScreen + 1) +(80 / 3) * _overflowToScreen];
            [self.view addConstraint:topConstraint];
            
        

        
        
        
//    在第一次return的时候设置上一次输入内容的长度和当前输入一直
    if (self.returnTime == 1) {
        self.titleStringWidthBefore = self.textField.text.length;
        
        NSLayoutConstraint *buttonGapToFristReturn = [NSLayoutConstraint constraintWithItem:button
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.scrollView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1.0f constant:10];

        [self.view addConstraint:buttonGapToFristReturn];
        
    
    }
   //    从第2次return开始  判断两次return内容长度的 > or <关系
    if (self.returnTime > 1) {
        
        if (_titleStringWidthBefore - _titleStringWidth > 0) {
            self.returnUpOrDown = returnTimeDown;
            
        }else if(_titleStringWidthBefore - _titleStringWidth < 0){
            self.returnUpOrDown = returnTimeUp;
            
        }
        
    }



    

 
//    return的次数从第二次开始执行 设置button的间隔
    if (self.returnTime > 1) {

        
        if (self.returnUpOrDown == returnTimeUp) {
            self.gap = _gap - (_titleStringWidth - _titleStringWidthBefore) * 17;
            self.titleStringWidthBefore = _titleStringWidth;
        }else if(self.returnUpOrDown == returnTimeDown){
            self.gap = _gap + (_titleStringWidthBefore - _titleStringWidth) * 17;
            self.titleStringWidthBefore = _titleStringWidth;
        }
        self.returnUpOrDown = ReturnTimeEqual;
        
        
             
             self.gap = _gap + (_titleStringWidth * 17 + 20);
//        两个button的间距为10
             self.gap = _gap +10;
        
        
     

       
        NSLayoutConstraint *buttonToGap = [NSLayoutConstraint constraintWithItem:button
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.scrollView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0f constant:self.gap + 10];

        [self.view addConstraint:buttonToGap];
       
    }
     self.returnTime ++;
   
    
    //    button宽度 字符串个数 * 17 + 20
    NSLayoutConstraint *buttonWidth = [NSLayoutConstraint constraintWithItem:button
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:_titleStringWidth * 17 + 20];
    [button addConstraint:buttonWidth];
        
      
        
        
    }
    
//    设置scrollView的contentSize的大小 =  所有button的高度 + 30
    CGSize size = CGSizeMake(_screenWidth, 13 * (_overflowToScreen + 1) +(80 / 3) * _overflowToScreen + 30);
    self.scrollView.contentSize = size;
    

//    按搜索后收起键盘
//    [self.textField resignFirstResponder];
    
    
    
    return YES;
  
}


- (IBAction)delete:(UIButton *)sender {
//    遍历父视图拿到所有的button  remove所有的button
    for (id subView in self.scrollView.subviews) {
        if([subView isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)subView;
            [button removeFromSuperview];
            
        }
    }
    self.returnTime = 1;
    self.gap = 0;
    self.overflowToScreen = 0;
    self.buttonTag = 2;
}


- (void)button {
    ZXLLOG(@"最近搜索Button");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}


@end

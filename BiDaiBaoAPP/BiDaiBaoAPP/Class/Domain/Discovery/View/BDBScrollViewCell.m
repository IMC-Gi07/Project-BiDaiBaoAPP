//
//  BDBScrollViewCell.m
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/12.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBScrollViewCell.h"
@interface BDBScrollViewCell()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) NSUInteger pageCount;
@end
@implementation BDBScrollViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = _imagesArray.count;
        self.pageCount = 0;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.width = self.frame.size.width;
    self.height = self.frame.size.height;
    _scrollView.delegate = self;
    
    
    if (_imagesArray.count == 0) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, _width,_height);
        imageView.image = [UIImage imageNamed:@"discovery_advPic_failedPic"];
        [_scrollView addSubview:imageView];
    }else {
        
        //生成n个UIImageView
        for (int i = 0;i < [_imagesArray count];i ++){
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake((_width * i) + _width, 0,_width, _height);
            imageView.image = _imagesArray[i];
            [_scrollView addSubview:imageView];
        }
        //再生成前后两个UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, _width,_height);
        imageView.image = _imagesArray.lastObject;
        [_scrollView addSubview:imageView];
        
        UIImageView *imageView_2 = [[UIImageView alloc] init];
        imageView_2.frame = CGRectMake((_width * ([_imagesArray count] + 1)) , 0, _width,_height);
        imageView_2.image = _imagesArray[0];
        [_scrollView addSubview:imageView_2];
        
        [_scrollView setContentSize:CGSizeMake(_width * ([_imagesArray count] + 2),_height)];
        
        [_scrollView setContentOffset:CGPointMake(_width+200, 0) animated:NO];

        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(switchToNextPage) userInfo:nil repeats:YES];
        [timer fire];
    }

    
}
- (void)awakeFromNib {
    
    
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updataCurrentPageNo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)switchToNextPage {
    
    [_scrollView setContentOffset:CGPointMake(_width + _width * _pageCount, 0) animated:YES];
    [self updataCurrentPageNo];
    _pageCount ++;
    if (_pageCount == _imagesArray.count) {
        _pageCount = 0;
    }
}

- (void)updataCurrentPageNo {
    NSInteger currentPage = 1;
    NSInteger tempPage = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    switch (tempPage) {
        case 1:
            currentPage = 0;
            break;
        case 2:
            currentPage = 1;
            break;
        case 3:
            currentPage = 2;
            break;
        case 4:
            currentPage = 3;
            break;
        case 5:
            currentPage = 0;
            break;
        case 0:
            currentPage = 3;
            break;
            
        default:
            break;
    }
    self.pageControl.currentPage = currentPage;
    if (currentPage == 0) {
        [_scrollView scrollRectToVisible:CGRectMake(_width, 0, _width, _height) animated:NO];
    }else if (currentPage == 3){
        [_scrollView scrollRectToVisible:CGRectMake(_width * 4, 0, _width, _height) animated:NO];
    }

}
@end

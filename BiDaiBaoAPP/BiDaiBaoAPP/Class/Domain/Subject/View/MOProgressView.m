//
//  MOProgressView.m
//  testProgressBar
//
//  Created by notedit on 5/15/13.
//  Copyright (c) 2013 motiky. All rights reserved.
//

#import "MOProgressView.h"

@implementation MOProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        
        UIEdgeInsets insets = {0,5,0,5};
        
        UIImage *backgroundImage = [[UIImage imageNamed:@"subject_cell_progress_track_img"] resizableImageWithCapInsets:insets];        
        
        UIImage *foregroundImage = [[UIImage imageNamed:@"subject_cell_progress_img"] resizableImageWithCapInsets:insets];       
        
        _trackView = [[UIImageView alloc] init];
        _trackView.image = backgroundImage;
        _progressbgView = [[UIImageView alloc] init];
        _progressbgView.image = foregroundImage;
        _progressView = [[UIView alloc] init];
        _progressView.clipsToBounds = YES;
        [_progressView addSubview:_progressbgView];
    
        [self addSubview:_trackView];
        
        [self addSubview:_progressView];
    }
    return self;
}

- (void)layoutSubviews{
    _trackView.frame = self.bounds;
    _progressbgView.frame = self.bounds;
    
    CGSize size = self.frame.size;
    _progressView.frame = CGRectMake(0, 0, size.width * _progress, size.height);
    
}


-(void)setProgress:(double)progress{
    
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    CGSize size = self.frame.size;
    _progressView.frame = CGRectMake(0, 0, size.width * progress, size.height);

}

/*
 -(id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage
 {
 self = [super initWithFrame:frame];
 if (self) {
 _trackView = [[UIImageView alloc] initWithFrame:self.bounds];
 _trackView.image = backgroundImage;
 _progressbgView = [[UIImageView alloc] initWithFrame:self.bounds];
 _progressbgView.image = foregroundImage;
 _progressView = [[UIView alloc] initWithFrame:self.bounds];
 _progressView.clipsToBounds = YES;
 [_progressView addSubview:_progressbgView];
 [self addSubview:_trackView];
 
 [self addSubview:_progressView];
 }
 
 return self;
 }
 
 */

@end

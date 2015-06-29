//
//  BDBTableViewCell.m
//  Subject_verson1
//
//  Created by Imcore.olddog.cn on 15/6/8.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBTableViewCell.h"
#import "MOProgressView.h"

@interface BDBTableViewCell()


@property (weak, nonatomic) IBOutlet MOProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *refleshButton;

@end



@implementation BDBTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
    }
    return self;
}

+ (BDBTableViewCell *)cellWithModel:(BDBSujectModel *) model{
    
    BDBTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBTableViewCell" owner:nil options:nil][0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.BidNameLabel.text = model.BidName;
    
    cell.PlatformNameLabel.text = model.PlatformName;
    
    cell.AnnualEarningsLabel.text = [NSString stringWithFormat:@"%g",[model.AnnualEarnings floatValue] * 100];
    
    cell.TermLabel.text = model.Term;
    
    CGFloat amountNumber = [model.Amount floatValue];
    
    amountNumber /= 10000.0f;
    
    cell.AmountLabel.text = [NSString stringWithFormat:@"%g",amountNumber];
    
    CGFloat progressPercent = [model.ProgressPercent floatValue];
    
    cell.ProgressPercentLabel.text = [NSString stringWithFormat:@"%g%%",progressPercent * 100];
    
    [cell.progressView setProgress:progressPercent];
    
    
    return cell;
    
}

- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

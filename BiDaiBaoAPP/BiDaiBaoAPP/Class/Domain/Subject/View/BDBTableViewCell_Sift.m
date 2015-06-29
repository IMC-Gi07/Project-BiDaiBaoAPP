//
//  BDBTableViewCell_Sift.m
//  Subject_verson1
//
//  Created by Imcore.olddog.cn on 15/6/10.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBTableViewCell_Sift.h"
#import "BDBSiftButtonInfoModel.h"

@interface BDBTableViewCell_Sift ()


@property(weak, nonatomic) IBOutlet UILabel *sectionTitle;

@property(nonatomic,strong) BDBSiftButtonInfoModel *info;


@end

@implementation BDBTableViewCell_Sift

+ (BDBTableViewCell_Sift *)cell{

    BDBTableViewCell_Sift *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBTableViewCell_Sift" owner:nil options:nil][0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createContentsAccordingSection: (NSUInteger)section {
    
    switch (section) {
        case 0:
        
            self.sectionTitle.text = @"选择平台:";
            
            break;
        
        case 1:
            self.sectionTitle.text = @"年化收益率:";
            break;
            
        case 2:
            self.sectionTitle.text = @"投资期限:";
            break;
            
        case 3:
            self.sectionTitle.text = @"投标进度:";
            break;
            
        default:
            break;
    }
    
}

- (void)createButtonForCellWithSecton: (NSUInteger)section infos:(NSArray *)aInfos{
    
    if(section == 0){
        
        for (NSDictionary *dic in aInfos[section]) {
            
            __weak typeof(self) thisInstance = self;
            
            [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                
                [thisInstance.info setValue:obj forKey:key];
                
                //NSLog(@"%@ + %@",key,obj);
                
                
            }];
            
            NSLog(@"%@ + %i",_info.title,_info.isSelected);
        }
    
    }
    else{
    
        
    }
    
}

@end

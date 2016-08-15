//
//  TimeCollectViewCell.m
//  CalendarDemo
//
//  Created by zoulin on 15/12/29.
//  Copyright © 2015年 miki. All rights reserved.
//

#import "TimeCollectViewCell.h"

@implementation TimeCollectViewCell


#pragma mark--getter
-(UILabel *)labelCell
{
    if(!_labelCell)
    {
        _labelCell = [[UILabel alloc]initWithFrame:self.bounds];
        _labelCell.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelCell];
    }
    return _labelCell;
}
@end

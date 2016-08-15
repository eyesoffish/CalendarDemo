//
//  CalenderView.m
//  CalendarDemo
//
//  Created by zoulin on 15/12/29.
//  Copyright © 2015年 miki. All rights reserved.
//

#import "CalenderView.h"
#import "TimeCollectViewCell.h"
#define MY_COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface CalenderView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSDate *MyDate;
@property (nonatomic,strong) UICollectionView *collectView;
@property (nonatomic,strong) UILabel *labelTime;
@property (nonatomic,strong) NSArray *arrayWeek;
@property (nonatomic,strong) UISwipeGestureRecognizer *leftSwipe;//左滑动手势
@property (nonatomic,strong) UISwipeGestureRecognizer *rightSwipe;//右滑动手势
@end

@implementation CalenderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self MyAdd];
    }
    return self;
}
- (void) MyAdd
{
    self.MyDate = [NSDate dateWithTimeIntervalSinceNow:3600*8];
    [self addSubview:self.collectView];
    [self addSubview:self.labelTime];
    [self addGestureRecognizer:self.leftSwipe];
    [self addGestureRecognizer:self.rightSwipe];
}
//获得当月的第一天是星期几
- (NSInteger) firstWeekDayInMonth:(NSDate *) currentDate
{
    NSInteger firstWeekDay = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1:sunday 2:mondy...
    
    NSDateComponents *component = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    component.day = 1;//设置为1号
    
    NSDate *newDate = [calendar dateFromComponents:component];//根据组件获取日期返回2015-12-1;
    firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
    return firstWeekDay-1;
}
//获得一个月有多少天
- (NSInteger) totalDayInMonth:(NSDate *) currentDate
{
    NSRange totalDays = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    return totalDays.length;
}
//滑动手势实现月份翻页
- (void) action_leftMonth
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
    } completion:^(BOOL finished) {
        self.MyDate = [self nextMonth:self.MyDate];
    }];
}
- (void) action_rightMonth
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        
    } completion:^(BOOL finished) {
        self.MyDate = [self lastMonth:self.MyDate];
    }];
}
//获得下一个月的日期
- (NSDate *) nextMonth:(NSDate *) senderDate
{
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.month = +1;
    NSDate *lastDate = [[NSCalendar currentCalendar]dateByAddingComponents:components toDate:senderDate options:0];
    return lastDate;
}
- (NSDate *) lastMonth:(NSDate *) senderDate
{
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.month = -1;
    NSDate *lastDate = [[NSCalendar currentCalendar]dateByAddingComponents:components toDate:senderDate options:0];
    return lastDate;
}
#pragma mark---代理
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.arrayWeek.count;
    }
    return 42;
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TimeCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"data" forIndexPath:indexPath];
    cell.labelCell.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.section==0)
    {
        cell.labelCell.text = self.arrayWeek[indexPath.item];
        cell.backgroundColor = MY_COLOR(38, 166, 154);
    }
    else
    {
        NSInteger firstDay = [self firstWeekDayInMonth:self.MyDate];
        NSInteger AllDays = [self totalDayInMonth:self.MyDate];
        NSInteger day = indexPath.item - firstDay +1;
        NSInteger lastMothday = [self totalDayInMonth:[self lastMonth:self.MyDate]];
        if(day<=0)
        {
            day = lastMothday + day;
        }
        else if(day > AllDays)
        {
            day = day - AllDays;
        }
        if(indexPath.row>AllDays+firstDay-1 || indexPath.row<firstDay)
        {
            cell.labelCell.textColor = [UIColor grayColor];
            cell.labelCell.text = [NSString stringWithFormat:@"%ld",day];
        }
        else
        {
            
            cell.labelCell.text = [NSString stringWithFormat:@"%ld",day];
            cell.backgroundColor = [UIColor whiteColor];
            
            //判断是否是星期天
            NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.MyDate];
            component.day = day;
            NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:component];
            BOOL isWeeded = [[NSCalendar currentCalendar] isDateInWeekend:newDate];
            if(isWeeded)
            {
                cell.labelCell.textColor = [UIColor redColor];
            }
        }
    }
    return cell;
}
#pragma mark--getter
- (void)setMyDate:(NSDate *)MyDate
{
    _MyDate = MyDate;
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat = @"yyyy-MM-dd";
    self.labelTime.text = [matter stringFromDate:_MyDate];
    [self.collectView reloadData];
}
- (UISwipeGestureRecognizer *)leftSwipe
{
    if(!_leftSwipe)
    {
        _leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(action_leftMonth)];
        _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _leftSwipe;
}
- (UISwipeGestureRecognizer *)rightSwipe
{
    if(!_rightSwipe)
    {
        _rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(action_rightMonth)];
        _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _rightSwipe;
}
- (NSArray *)arrayWeek
{
    if(!_arrayWeek)
    {
        _arrayWeek = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    return _arrayWeek;
}
- (UILabel *)labelTime
{
    if(!_labelTime)
    {
        _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40)];
        _labelTime.textAlignment = NSTextAlignmentCenter;
    }
    return _labelTime;
}
- (UICollectionView *)collectView
{
    if(!_collectView)
    {
        CGFloat width = CGRectGetWidth(self.bounds)/7.0;
        CGFloat height = (CGRectGetHeight(self.bounds)-40)/7.0;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0;//间距
        flowLayout.minimumLineSpacing = 0;//行间距
        flowLayout.sectionInset = UIEdgeInsetsZero;//组间距
        flowLayout.itemSize = CGSizeMake(width, height);
        
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-40) collectionViewLayout:flowLayout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        
        //注册
        [_collectView registerClass:[TimeCollectViewCell class] forCellWithReuseIdentifier:@"data"];
    }
    return _collectView;
}

@end

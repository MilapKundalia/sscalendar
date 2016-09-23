//
//  SSCalendarAnnualViewController.m
//  Pods
//
//  Created by Steven Preston on 7/19/13.
//  Copyright (c) 2013 Stellar16. All rights reserved.
//

#import "SSCalendarAnnualViewController.h"
#import "SSCalendarMonthlyViewController.h"
#import "SSCalendarYearViewController.h"
#import "SSYearNode.h"
#import "SSMonthNode.h"
#import "SSCalendarUtils.h"

@implementation SSCalendarAnnualViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.yearViewController = [[SSCalendarYearViewController alloc] initWithView:_yearView];
    _yearView.dataSource = _yearViewController;
    _yearView.delegate = self;
    
    _yearViewController.years = [SSDataController shared].calendarYears;
}


- (void)refresh
{
    SSCalendarCountCache *calendarCounts = [[SSDataController shared] cachedCalendarCount];
    if (calendarCounts == nil)
    {
        SSYearNode *firstYear = [_yearViewController.years objectAtIndex:0];
        SSYearNode *lastYear = [_yearViewController.years lastObject];
        
        //[self showLoading:YES animated:NO];
        //[[SSDataController shared] requestEventCountWithStartYear:firstYear.value StartMonth:1 EndYear:lastYear.value EndMonth:lastYear.months.count];
    }
    else
    {
        [[SSDataController shared] updateCalendarYears];
        [_yearView reloadData];
    }
}


#pragma mark - UICollectionViewDelegateMethods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSYearNode *year = [_yearViewController.years objectAtIndex:indexPath.section];
    
    SSCalendarMonthlyViewController *viewController = [[SSCalendarMonthlyViewController alloc] initWithNibName:@"SSCalendarMonthlyViewController" bundle:nil];
    
    NSInteger section = indexPath.section * year.months.count + indexPath.row;
    NSIndexPath *startingIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    viewController.startingIndexPath = startingIndexPath;
    viewController.years = _yearViewController.years;

    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - NotificationObserver Methods

/*- (void)notificationReceived:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    if ([notification.name isEqualToString:NOTIFICATION_REQUEST])
    {
        id request = [userInfo objectForKey:NOTIFICATION_REQUEST];
        int result = [[userInfo objectForKey:NOTIFICATION_RESULT] intValue];
        
        if ([request isKindOfClass:[SSGetEventCountRequest class]])
        {
            SSGetEventCountRequest *getEventCountRequest = request;
            [self showLoading:NO animated:YES];
            
            NSArray *dates = [self handleRequest:getEventCountRequest Result:result];
            
            if (dates != nil)
            {
                [_yearView reloadData];
            }
        }
    }
}*/

@end

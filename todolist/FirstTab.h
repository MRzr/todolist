//
//  FirstTab.h
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTab : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *label;


@property (strong, nonatomic) IBOutlet UITableView *table;
-(void) setTitles;
-(NSInteger) taskCount;
- (IBAction)editTable:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
-(void) check:(UIGestureRecognizer *)sender ;
-(void) TabSwitch:(UIGestureRecognizer *)sender ;
@end

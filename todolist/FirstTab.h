//
//  FirstTab.h
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTab : UIViewController {
     UIPopoverController *popoverController;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *label;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UITableView *table;
-(void) setTitles;

-(NSInteger) taskCount: (NSString*) sectionIndex;
- (IBAction)editTable:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
-(void) check:(UIGestureRecognizer *)sender ;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
-(void) TabSwitch:(UIGestureRecognizer *)sender ;
-(void)showPopover: (NSString *) identifier fromButton: (UIBarButtonItem *) button;

- (IBAction)addTask:(id)sender;
@end

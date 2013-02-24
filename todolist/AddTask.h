//
//  AddTask.h
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTask : UIViewController
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *TaskName;


@end

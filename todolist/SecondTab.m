//
//  SecondTab.m
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import "SecondTab.h"

@interface SecondTab (){
    NSManagedObjectContext *context;
}

@end

@implementation SecondTab
@synthesize SecondTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

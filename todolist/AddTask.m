//
//  AddTask.m
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import "AddTask.h"
#import "AppDelegate.h"
@interface AddTask (){
    NSManagedObjectContext *context;
        NSMutableArray *priorityArray;
}

@end

@implementation AddTask 
@synthesize TaskName, pickerView;
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
	// Do any additional setup after loading the view.
    [TaskName becomeFirstResponder];
    priorityArray = [NSMutableArray new];
    [priorityArray addObject:@"High priority"];
    [priorityArray addObject:@"Normal priority"];
    [priorityArray addObject:@"Low priority"];
    [pickerView selectRow:1 inComponent:0 animated:NO];
    

    

    
    
}
-(void) viewDidAppear:(BOOL)animated {
    TaskName.text = @"";

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"contentFooViewControllerDone" object:self];
    
}

- (IBAction)done:(id)sender {
    if (![TaskName.text isEqualToString:@""]) {
       
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
        NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
        
        NSEntityDescription *entitydesc = [NSEntityDescription entityForName:[defaults objectForKey:@"tab"] inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",TaskName.text];
        [request setPredicate:predicate];
        
    [request setEntity:entitydesc];
    NSError *error;
        NSArray *matchingData = [context executeFetchRequest:request error:&error];
        if (matchingData.count == 0) {
            NSManagedObject *new =[[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
          
            
            [new setValue:[NSString stringWithFormat:@"%ld", (long) [pickerView selectedRowInComponent:0]] forKey:@"priority"];
            [new setValue:TaskName.text forKey:@"name"];
            [new setValue:false forKey:@"complete"];
         
            [context save:&error];

        } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task exists" message:@"Your task already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"contentFooViewControllerDone" object:self];
       
    }
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [priorityArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [priorityArray objectAtIndex:row];
}
@end

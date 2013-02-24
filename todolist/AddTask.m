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
}

@end

@implementation AddTask
@synthesize TaskName;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)done:(id)sender {
    if (![TaskName.text isEqualToString:@""]) {
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",TaskName.text];
        [request setPredicate:predicate];
        
    [request setEntity:entitydesc];
    NSError *error;
        NSArray *matchingData = [context executeFetchRequest:request error:&error];
        if (matchingData.count == 0) {
            NSManagedObject *new =[[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
            [new setValue:TaskName.text forKey:@"name"];
            [new setValue:false forKey:@"complete"];
            [context save:&error];

        } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task exists" message:@"Your task already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
  [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end

//
//  ClearTask.m
//  todolist
//
//  Created by Matt Razor on 24.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import "ClearTask.h"
#import "AppDelegate.h"
@interface ClearTask (){
    NSManagedObjectContext *context;
    
}


@end

@implementation ClearTask

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)all:(id)sender {
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:[defaults objectForKey:@"tab"] inManagedObjectContext:context];

    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
   
    [request setEntity:entitydesc];
    
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in matchingData) {
        
        [context deleteObject:obj];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"contentFooViewControllerDone" object:self];

}

- (IBAction)done:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:[defaults objectForKey:@"tab"] inManagedObjectContext:context];

    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"complete like 'true'"];
    [request setPredicate:predicate];
    [request setEntity:entitydesc];
    
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in matchingData) {
        [context deleteObject:obj];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"contentFooViewControllerDone" object:self];
}
@end

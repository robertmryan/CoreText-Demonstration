//
//  ViewController.m
//  CoreText Demonstration
//
//  Created by Robert Ryan on 4/17/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "ViewController.h"
#import "CustomLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CustomLabel *customLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 100.0)];
    customLabel.text = @"bigcat";
    customLabel.fillColor = [UIColor redColor];     // red font
    customLabel.borderColor = [UIColor whiteColor]; // white border around font
    customLabel.center = CGPointMake(80.0, 60.0);   // put in in the top-left corner
    customLabel.angle = -M_PI * 30.0 / 180.0;       // rotate it 30 degrees counter-clockwise
    [self.view addSubview:customLabel];
    
    // you wouldn't generally do this (programmatically change it after
    // two seconds pass), but I'm just demonstrating that you can change
    // the color or font size, and the view is automatically updated.
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        customLabel.fillColor = [UIColor blueColor]; // change font to blue
        customLabel.fontSize += 12;                  // increase font size
    });
}

@end

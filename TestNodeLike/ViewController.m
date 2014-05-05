//
//  ViewController.m
//  TestNodeLike
//
//  Created by Rafael on 5/05/14.
//  Copyright (c) 2014 Iswe. All rights reserved.
//

#import "ViewController.h"
#import "NLContext.h"

@interface ViewController ()

@property (nonatomic, strong) NLContext *context;

@property (nonatomic, strong) JSVirtualMachine *virtualMachine;

@property (nonatomic, strong) JSValue *testModule;

@end

@implementation ViewController

@synthesize context, testModule, virtualMachine;

- (IBAction)startNodelike:(id)sender {
    
    virtualMachine = [[JSVirtualMachine alloc] init];
    
    context = [[NLContext alloc] initWithVirtualMachine:virtualMachine];
    
    NSString *startScript = @"(function () { var testModule = require('testModule'); testModule.start(); return testModule;})();";
    testModule = [context evaluateScript:startScript];
    [NLContext runEventLoopAsyncInContext:context];
    [context runProcessAsyncQueue];
    
}
- (IBAction)testSetInterval:(id)sender {
    
    [testModule[@"testSetInterval"] callWithArguments:@[]];
    [NLContext runEventLoopAsyncInContext:context];
    
}


- (IBAction)stopNodelike:(id)sender {
    
    NSLog(@"stopNodelike -> context emitExit");
    
    //emit exit
    int result = [context emitExit];
    [NLContext runEventLoopAsyncInContext:context];
    [context runProcessAsyncQueue];
    
    NSLog(@"stopNodelike -> context emitExit result %i", result);
    
    [context stop];
    
    //[self cleanUpContext];
    
    context = nil;
    
    virtualMachine = nil;
}

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

@end

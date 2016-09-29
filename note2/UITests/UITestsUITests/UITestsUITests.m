//
//  UITestsUITests.m
//  UITestsUITests
//
//  Created by huangxu on 16/6/1.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UITestsUITests : XCTestCase

@end

@implementation UITestsUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"login"] tap];
    
    XCUIElement *element = [[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"UIView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *switch2 = [[[element childrenMatchingType:XCUIElementTypeSwitch] matchingIdentifier:@"1"] elementBoundByIndex:0];
    [switch2 tap];
    [element tap];
    [element tap];
    [element tap];
    [element tap];
    [element tap];
    [element tap];
    [element tap];
    
    XCUIElement *switch3 = app.switches[@"0"];
    [switch3 tap];
    
    XCUIElement *switch4 = [[[element childrenMatchingType:XCUIElementTypeSwitch] matchingIdentifier:@"1"] elementBoundByIndex:1];
    [switch4 tap];
    [switch3 tap];
    [switch2 tap];
    [switch3 tap];
    [switch4 tap];
    [[[[app.navigationBars[@"UIView"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    
    
}

@end

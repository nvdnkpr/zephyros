//
//  AppDelegate.m
//  Zephyros
//
//  Created by Steven on 4/13/13.
//  Copyright (c) 2013 Giant Robot Software. All rights reserved.
//

#import "AppDelegate.h"

#import "SDOpenAtLogin.h"
#import "SDConfigLauncher.h"
#import "SDAppStalker.h"

#import "SDLogWindowController.h"
#import "SDPreferencesWindowController.h"

#import "SDConfigLauncher.h"

#import "SDAlertWindowController.h"
#import "SDClientListener.h"


@interface AppDelegate ()

@property NSStatusItem* statusItem;

@end

@implementation AppDelegate

- (void) prepareStatusItem {
    [[NSNotificationCenter defaultCenter] addObserverForName:SDScriptLaunchedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      static BOOL firstTime = YES;
                                                      if (firstTime) {
                                                          firstTime = NO;
                                                      }
                                                      else {
                                                          [[SDAlerts sharedAlerts] show:@"Launched Zephyros Script"];
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SDScriptDiedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [[SDAlerts sharedAlerts] show:@"Zephyros Script Ended"];
                                                  }];
    
    [[SDClientListener sharedListener] startListening];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"statusitem"];
    self.statusItem.alternateImage = [NSImage imageNamed:@"statusitem_pressed"];
    self.statusItem.menu = self.statusItemMenu;
    self.statusItem.highlightMode = YES;
}

- (IBAction) accidentally93mb:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    NSRunAlertPanel(@"Accidentally 93mb", @"are.. are you sure? this is dangerous...", @"wat", @"😕", nil);
    
    NSArray* strs = @[@"http://i3.kym-cdn.com/photos/images/original/000/190/279/ss.jpg",
                      @"http://i3.kym-cdn.com/photos/images/original/000/239/273/553.png",
                      @"http://i1.kym-cdn.com/photos/images/original/000/363/382/602.png",
                      @"http://i2.kym-cdn.com/photos/images/original/000/343/061/254.png",
                      ];
    
    NSUInteger randomIndex = arc4random() % [strs count];
    
    NSString* str = [strs objectAtIndex:randomIndex];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:str]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"launchCommand": @"ruby ~/zephyros.rb   # or whatever"}];
    
    [self prepareStatusItem];
    
    [[SDConfigLauncher sharedConfigLauncher] launchConfigMaybe];
    [[SDAppStalker sharedAppStalker] beginStalking];
    
    [[SDAlerts sharedAlerts] show:@"Zephyros power, activate!"
                         duration:1.5];
}

- (IBAction) showPreferencesWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [[SDPreferencesWindowController sharedConfigChooserWindowController] show];
}

- (IBAction) relaunchConfig:(id)sender {
    [[SDConfigLauncher sharedConfigLauncher] launchConfigMaybe];
}

- (void) menuNeedsUpdate:(NSMenu *)menu {
    [[menu itemWithTitle:@"Open at Login"] setState:([SDOpenAtLogin opensAtLogin] ? NSOnState : NSOffState)];
}

- (IBAction) showLogWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [[SDLogWindowController sharedLogWindowController] showWindow:self];
}

- (IBAction) showAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) toggleOpensAtLogin:(id)sender {
	NSInteger changingToState = ![sender state];
	[SDOpenAtLogin setOpensAtLogin: changingToState];
}

@end

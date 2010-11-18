// Copyright (c) 2010 Tim Isted
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DirectoryWatcherAppDelegate.h"

#import "TIKQDirectoryWatcher.h"

#import <errno.h>
#import <strings.h>
#import <sys/event.h>

@implementation DirectoryWatcherAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [self startWatching:nil];
}

- (void)directoryActivityNotification:(NSNotification *)aNotification
{
    NSLog(@"Directory activity notification: %@", aNotification);
    
    NSString *directory = [[aNotification userInfo] valueForKey:kTIKQDirectory];
    
    [[self textView] insertText:[NSString stringWithFormat:@"Change noticed in %@\n", directory]];
}

- (IBAction)startWatching:(id)sender
{
    NSLog(@"Starting to watch…");
    NSArray *directoriesToWatch = [NSArray arrayWithObjects:@"/tmp", @"~/Dropbox", nil];
    
    NSError *anyError = nil;
    BOOL success = NO;
    for( NSString *eachDirectory in directoriesToWatch ) {
        success = [[self directoryWatcher] watchDirectory:[eachDirectory stringByExpandingTildeInPath] error:&anyError];
        
        if( !success ) NSLog(@"Error adding directory to watch: %@", anyError);
    }
    
    success = [[self directoryWatcher] scheduleWatcherOnMainRunLoop:&anyError];
    if( !success ) NSLog(@"Failed to schedule watcher: %@", anyError);
    
    if( !success ) return;
    
    [[self startButton] setEnabled:NO];
    [[self stopButton] setEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directoryActivityNotification:) name:kTIKQDirectoryWatcherObservedDirectoryActivityNotification object:[self directoryWatcher]];
}

- (IBAction)stopWatching:(id)sender
{
    NSLog(@"Stopping watching...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTIKQDirectoryWatcherObservedDirectoryActivityNotification object:[self directoryWatcher]];
    
    [self setDirectoryWatcher:nil];
    
    [[self stopButton] setEnabled:NO];
    [[self startButton] setEnabled:YES];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self stopWatching:nil];
}

#pragma mark -
#pragma mark Lazy Generators
- (TIKQDirectoryWatcher *)directoryWatcher
{
    if( _directoryWatcher ) return _directoryWatcher;
    
    _directoryWatcher = [[TIKQDirectoryWatcher alloc] init];
    
    return _directoryWatcher;
}

#pragma mark -
#pragma mark Initialization and Deallocation
- (void)dealloc 
{
    [_directoryWatcher release], _directoryWatcher = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Properties
@synthesize window = _window;
@synthesize textView = _textView;
@synthesize startButton = _startButton;
@synthesize stopButton = _stopButton;

@synthesize directoryWatcher = _directoryWatcher;

@end

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


#import "DirectoryWatcherViewController.h"
#import "TIKQDirectoryWatcher.h"

@implementation DirectoryWatcherViewController

#pragma mark -
#pragma mark Actions
- (IBAction)startWatching:(id)sender
{
    NSLog(@"Starting to watch...");
    NSArray *directoriesToWatch = [NSArray arrayWithObjects:[self tmpDirectoryPath], [self documentsDirectoryPath], nil];
    
    NSError *anyError = nil;
    BOOL success = NO;
    for( NSString *eachDirectory in directoriesToWatch ) {
        success = [[self directoryWatcher] watchDirectory:[eachDirectory stringByExpandingTildeInPath] error:&anyError];
        
        if( !success ) NSLog(@"Error adding directory to watch: %@", anyError);
    }
    
    success = [[self directoryWatcher] scheduleWatcherOnMainRunLoop:&anyError];
    if( !success ) NSLog(@"Failed to schedule watcher: %@", anyError);
    
    if( !success ) return;
    
    [[self startButton] setHidden:YES];
    [[self stopButton] setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directoryActivityNotification:) name:kTIKQDirectoryWatcherObservedDirectoryActivityNotification object:[self directoryWatcher]];
}

- (IBAction)stopWatching:(id)sender
{
    NSLog(@"Stopping watching...");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTIKQDirectoryWatcherObservedDirectoryActivityNotification object:[self directoryWatcher]];
    
    [self setDirectoryWatcher:nil];
    
    [[self stopButton] setHidden:YES];
    [[self startButton] setHidden:NO];
}

#pragma mark -
#pragma mark Adding Files
- (void)_addFileNumber:(int)aFileNumber toDirectory:(NSString *)aDirectory
{
    NSString *fileContents = [NSString stringWithFormat:@"This is file %i", aFileNumber];
    
    NSString *fileName = [aDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"tmpFile%i.txt", aFileNumber]];
    NSLog(@"Writing to file: %@", fileName);
    
    NSError *anyError = nil;
    BOOL success = [fileContents writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if( !success ) NSLog(@"Error writing file: %@", anyError);
}

- (IBAction)addTmpFile:(id)sender
{
    static int tmpFileNumber = 0;
    
    [self _addFileNumber:tmpFileNumber toDirectory:[self tmpDirectoryPath]];
    
    tmpFileNumber++;
}

- (IBAction)addDocumentsFile:(id)sender
{
    static int documentsFileNumber = 0;
    
    [self _addFileNumber:documentsFileNumber toDirectory:[self documentsDirectoryPath]];
    
    documentsFileNumber++;
}

#pragma mark -
#pragma mark Notifications
- (void)directoryActivityNotification:(NSNotification *)aNotification
{
    NSLog(@"Directory activity notification: %@", aNotification);
    
    NSString *directory = [[aNotification userInfo] valueForKey:kTIKQDirectory];
    
    NSString *currentText = [[self textView] text];
    
    [[self textView] setText:[currentText stringByAppendingFormat:@"Change noticed in %@\n", directory]];
}

#pragma mark -
#pragma mark View Lifecycle
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startWatching:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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

- (NSString *)documentsDirectoryPath
{
    if( _documentsDirectoryPath ) return _documentsDirectoryPath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectoryPath = [[paths objectAtIndex:0] retain];
    
    return _documentsDirectoryPath;
}

- (NSString *)tmpDirectoryPath
{
    if( _tmpDirectoryPath ) return _tmpDirectoryPath;
    
    _tmpDirectoryPath = [NSTemporaryDirectory() retain];
    
    return _tmpDirectoryPath;
}

#pragma mark -
#pragma mark Initialization and Deallocation
- (void)dealloc
{
    [_textView release], _textView = nil;
    [_startButton release], _startButton = nil;
    [_stopButton release], _stopButton = nil;
    [_directoryWatcher release], _directoryWatcher = nil;
    [_documentsDirectoryPath release], _documentsDirectoryPath = nil;
    [_tmpDirectoryPath release], _tmpDirectoryPath = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Properties
@synthesize textView = _textView;
@synthesize startButton = _startButton;
@synthesize stopButton = _stopButton;
@synthesize directoryWatcher = _directoryWatcher;
@synthesize documentsDirectoryPath = _documentsDirectoryPath;
@synthesize tmpDirectoryPath = _tmpDirectoryPath;

@end

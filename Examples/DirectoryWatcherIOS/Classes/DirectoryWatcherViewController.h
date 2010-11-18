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


#import <UIKit/UIKit.h>

@class TIKQDirectoryWatcher;

@interface DirectoryWatcherViewController : UIViewController {
    UITextView *_textView;
    
    UIButton *_startButton;
    UIButton *_stopButton;
    
    TIKQDirectoryWatcher *_directoryWatcher;
    
    NSString *_documentsDirectoryPath;
    NSString *_tmpDirectoryPath;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) TIKQDirectoryWatcher *directoryWatcher;
@property (nonatomic, retain) NSString *documentsDirectoryPath;
@property (nonatomic, retain) NSString *tmpDirectoryPath;

- (IBAction)startWatching:(id)sender;
- (IBAction)stopWatching:(id)sender;
- (IBAction)addTmpFile:(id)sender;
- (IBAction)addDocumentsFile:(id)sender;

@end

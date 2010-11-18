#TIKQDirectoryWatcher
*A class to watch one or more directories, and post notifications when changes occur to their contents*  

Tim Isted  
[http://www.timisted.net](http://www.timisted.net)  
Twitter: @[timisted](http://twitter.com/timisted)

##License
TIKQDirectoryWatcher is offered under the **MIT** license. See the `LICENSE` file for full details.

##Summary
`TIKQDirectoryWatcher` makes use of `kqueue`s to post notifications when changes occur to the contents of one or more specified directories.

##Basic Usage
Add the `TIKQDirectoryWatcher.h` and `.m` files to your project, and create an instance:

    TIKQDirectoryWatcher *directoryWatcher = [[TIKQDirectoryWatcher alloc] init];

Add one or more directories to watch:

    BOOL success = [directoryWatcher watchDirectory:[@"~/Documents" stringByExpandingTildeInPath] error:nil];

This method will return `NO` if the watcher can't find the specified directory, or if any other error occurs. At the moment, the `NSError` object is ignored, but will be configured soon. For now, errors are simply logged to the console.

###Notifications
You'll need to register to receive `kTIKQDirectoryWatcherObservedDirectoryActivityNotification` notifications when changes occur:

    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
        selector:@selector(notificationHandlerMethod:) 
            name:kTIKQDirectoryWatcherObservedDirectoryActivityNotification 
          object:directoryWatcher];

The notification's user info dictionary contains two entries:

* `kTIKQDirectory` specifies the name of the directory using a tilde (~) if appropriate, such as `~/Documents`
* `kTIKQExpandedDirectory` specifies the full name of the directory, such as `/Users/bob/Documents`

##Examples
Both a sample Mac application and a sample iOS project are included.

###Mac Example
If you do not use Dropbox, you'll need to modify the Mac application observed directories to exclude the `~/Dropbox`, otherwise you'll see an error in the console when the application tries to watch that directory. The observed directories are specified in the `startWatching:` method in `DirectoryWatcherAppDelegate.m`. 

To test for notifications, add or remove a file at the root level of `/tmp` or `~/Dropbox`.

###iOS Example
The iOS example checks for changes made in the application's `/Documents` and `/tmp` directories. Click the relevant button to add new files to these locations, and trigger the notifications as long as the watcher is enabled.

Also try adding a file to the application's `/Documents` directory through Xcode.

##Acknowledgements
Some portions of this code are based on Chapter 15, *kqueues*, of *[Advanced Mac OS X Programming (Second Edition)](http://www.amazon.com/gp/product/0974078514?ie=UTF8&tag=timist-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0974078514)* by Mark Dalrymple and Aaron Hillegass.

##To Do List
* Fill out `NSError` objects if errors occur
* Check for memory leaks if errors occur
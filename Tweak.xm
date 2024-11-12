#import <UIKit/UIKit.h>
#include <dlfcn.h>

%group UIDebug

%hook UIResponder
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.tag = 0;
        alertView.title = @"Lookin UIDebug";
        [alertView addButtonWithTitle:@"2D Inspection"];
        [alertView addButtonWithTitle:@"3D Inspection"];
        [alertView addButtonWithTitle:@"Export"];
        [alertView addButtonWithTitle:@"Cancel"];
        [alertView show];
    }
}
%new
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
        } else if (buttonIndex == 1) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
        }else if (buttonIndex == 2) {
        	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

				[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
			});
        }
    }
}
%end
%end

static NSString * const kLookinPlistJBPath = @"/var/jb/var/mobile/Library/Preferences/com.chinapyg.lookinloader.plist";
static NSString * const kLookinPlistPath = @"/var/mobile/Library/Preferences/com.chinapyg.lookinloader.plist";
static NSString * const kLookinServerJBPath = @"/var/jb/Library/Application Support/LookinLoader/LookinServer.framework/LookinServer";
static NSString * const kLookinServerPath = @"/Library/Application Support/LookinLoader/LookinServer.framework/LookinServer";

static BOOL isEnabledApp(){
    NSString*    plistPath = ([[NSFileManager defaultManager] fileExistsAtPath:kLookinPlistJBPath] ? kLookinPlistJBPath : kLookinPlistPath);
    NSString* bundleIdentifier=[[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"66661666662 plistPath %@",plistPath);
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"66661666662 prefs %@",prefs);
    return [prefs[@"apps"] containsObject:bundleIdentifier];
}
%ctor{
	@autoreleasepool {
		if (isEnabledApp()) {
			NSFileManager* fileManager = [NSFileManager defaultManager];
    		NSString*    libPath = ([[NSFileManager defaultManager] fileExistsAtPath:kLookinServerJBPath] ? kLookinServerJBPath : kLookinServerPath);
			if([fileManager fileExistsAtPath:libPath]) {
				void *lib = dlopen([libPath UTF8String], RTLD_NOW);
				if (lib) {
					%init(UIDebug)
					NSLog(@"[+]66661666662 LookinLoader loaded!");
				}else {
					char* err = dlerror();
					NSLog(@"[+] 66661666662 LookinLoader load failed:%s",err);
				}
			}
		}

	}

}

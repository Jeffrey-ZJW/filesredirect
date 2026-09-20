// Tweak.x
// 把 files.txt 的请求 URL 改成 file:// 指向本地 appfiles.txt

#import <substrate.h>
#import <Foundation/Foundation.h>

static NSString *const kLocalFile = @"/private/var/mobile/Media/Downloads/appfiles.txt";
static NSString *const kTarget = @"files.txt";

%hook NSMutableURLRequest

- (void)setURL:(NSURL *)URL {
    NSString *urlStr = URL.absoluteString;
    if (urlStr && [urlStr rangeOfString:kTarget].location != NSNotFound) {
        NSURL *localURL = [NSURL fileURLWithPath:kLocalFile];
        NSLog(@"[FilesRedirect] 替换 %@  →  %@", urlStr, localURL.absoluteString);
        %orig(localURL);
        return;
    }
    %orig;
}

%end

%hook NSURLRequest

+ (instancetype)requestWithURL:(NSURL *)URL {
    NSString *urlStr = URL.absoluteString;
    if (urlStr && [urlStr rangeOfString:kTarget].location != NSNotFound) {
        NSURL *localURL = [NSURL fileURLWithPath:kLocalFile];
        NSLog(@"[FilesRedirect] requestWithURL 替换 → %@", localURL.absoluteString);
        return %orig(localURL);
    }
    return %orig;
}

%end

%ctor {
    NSLog(@"[FilesRedirect] loaded, 目标=%@, 本地=%@", kTarget, kLocalFile);
}

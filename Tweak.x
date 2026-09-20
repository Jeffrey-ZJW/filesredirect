// Tweak.x - 优化版
#import <substrate.h>
#import <Foundation/Foundation.h>

static NSString *const kLocalFile = @"/private/var/mobile/Media/Downloads/appfiles.txt";

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSString *urlStr = request.URL.absoluteString;
    const char *cstr = urlStr.UTF8String;

    // 快速判断，没命中立即放行（strstr 比 rangeOfString 快 10-100 倍）
    if (!cstr || !strstr(cstr, "files.txt")) {
        return %orig;
    }

    // 命中，替换 URL 指向本地文件
    NSMutableURLRequest *newReq = [request mutableCopy];
    newReq.URL = [NSURL fileURLWithPath:kLocalFile];

    return %orig(newReq, completionHandler);
}

%end

%ctor {
    // 不写 NSLog，避免同步 IO
}

# PSPageControl

## Usage

First at all import library to your view controller.
```objc
#import "PSPageControl.h"
```

Then add `UIView` in your storyboard/xib (or create view programmatically), change its class to `PSPageControl` and drag and drop to create `IBOutlet`. Next add proper code to your `viewDidLoad` or another place where you need it.
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.pageControlView.backgroundPicture = [UIImage imageNamed:@"Background"];
    self.pageControlView.offsetPerPageInPixels = 50;

    // Prepare views to add
    NSMutableArray *views = [NSMutableArray new];
    for (NSUInteger i = 1; i <= 5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];

        UILabel *label = [[UILabel alloc] initWithFrame:
            CGRectMake(CGRectGetWidth(self.view.frame)/2-60, 40, 120, 30)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"View #%lu", i];

        [view addSubview:label];
        [views addObject:view];
    }

    self.pageControlView.views = views;
}
```

More complex method goes here.
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *loremIpsum = @[
        @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin nibh
            augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel lorem.
            Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac diam.
            Quisque semper justo at risus.",
        @"Donec venenatis, turpis vel hendrerit interdum, dui ligula ultricies
            purus, sed posuere libero dui id orci.",
        @"Nam congue, pede vitae dapibus aliquet, elit magna vulputate arcu,
            vel tempus metus leo non est. Etiam sit amet lectus quis est congue
            mollis. Phasellus congue lacus eget neque.",
        @"Phasellus ornare, ante vitae consectetuer consequat, purus sapien
            ultricies dolor, et mollis pede metus eget nisi. Praesent sodales
            velit quis augue.",
        @"Cras suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in
            interdum massa nibh nec erat."
    ];

    self.pageControlView.backgroundPicture = [UIImage imageNamed:@"Background"];
    self.pageControlView.offsetPerPageInPixels = 50;

    // Prepare views to add
    NSMutableArray *views = [NSMutableArray new];
    for (NSUInteger i = 1; i <= 5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];

        UILabel *label = [[UILabel alloc] initWithFrame:
            CGRectMake(CGRectGetWidth(self.view.frame)/2-60, 40, 120, 30)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"View #%lu", i];

        UILabel *description = [[UILabel alloc] initWithFrame:
            CGRectMake(30, 80, CGRectGetWidth(self.view.frame)-60,
            CGRectGetHeight(self.view.frame)-100)];
        description.lineBreakMode = NSLineBreakByWordWrapping;
        description.numberOfLines = 0;
        description.textColor = [UIColor whiteColor];
        description.font = [UIFont fontWithName:@"HelveticaNeue-Light"
                                           size:20.0];
        description.textAlignment = NSTextAlignmentCenter;
        description.text = loremIpsum[i-1];

        [view addSubview:label];
        [view addSubview:description];
        [views addObject:view];
    }

    self.pageControlView.views = views;
}
```

## Properties
**PSPagecontrol** has a few properties that let you configure the library.

* `backgroundPicture` is an image shown in the background. Remember that it should be horizontal with high resolution.
* `views` is array of `UIView`s to be shown by page control.
* `offsetPerPageInPixels` is offset used swipe by swipe from one to another view. Default is `40`.
* `pageIndicatorTintColor` is `UIColor` used by inactive page control indicator.
* `currentPageIndicatorTintColor` is `UIColor` used by active page control indicator.

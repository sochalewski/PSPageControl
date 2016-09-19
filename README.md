# PSPageControl

[![Version](https://img.shields.io/cocoapods/v/PSPageControl.svg?style=flat)](http://cocoapods.org/pods/PSPageControl)
[![License](https://img.shields.io/cocoapods/l/PSPageControl.svg?style=flat)](http://cocoapods.org/pods/PSPageControl)
[![Platform](https://img.shields.io/cocoapods/p/PSPageControl.svg?style=flat)](http://cocoapods.org/pods/PSPageControl)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 3, iOS 8+

## Installation

PSPageControl is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PSPageControl"
```

## Demo
<p align="center">
<img src="http://i.imgur.com/pERmajx.gif" alt="PSPageControl example"><br />
<a href="http://gfycat.com/IllinformedDismalEland" target="_blank">GFY here</a>
</p>

## Usage
First at all import library to your view controller.
```swift
import PSPageControl
```

Then add a `UIView` in your storyboard/xib (or create view programmatically), change its class to `PSPageControl` and drag and drop to create an `IBOutlet`. Next add proper code to your `viewDidLoad` or another place where you need it.
```swift
override func viewDidLoad() {
    super.viewDidLoad()

    pageControlView.backgroundPicture = UIImage(named: "Background")
    pageControlView.offsetPerPageInPixels = 50

    // Prepare views to add
    var views = [UIView]()
    for index in 1...5 {
        let view = UIView(frame: self.view.frame)

        let label = UILabel(frame: CGRect(x: self.view.frame.width / 2.0 - 60.0, y: 40.0, width: 120.0, height: 30.0))
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        label.textAlignment = .center
        label.text = "View #\(index)"

        view.addSubview(label)

        views.append(view)
    }

    pageControlView.views = views
}
```

More complex function goes here.
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let loremIpsum = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac diam. Quisque semper justo at risus.",
        "Donec venenatis, turpis vel hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui id orci.",
        "Nam congue, pede vitae dapibus aliquet, elit magna vulputate arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est congue mollis. Phasellus congue lacus eget neque.",
        "Phasellus ornare, ante vitae consectetuer consequat, purus sapien ultricies dolor, et mollis pede metus eget nisi. Praesent sodales velit quis augue.",
        "Cras suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum massa nibh nec erat."]

    pageControl.backgroundPicture = UIImage(named: "Background")
    pageControl.offsetPerPage = 40

    // Prepare views to add
    var views = [UIView]()

    for index in 1...5 {
        let view = UIView(frame: self.view.frame)

        let label = UILabel(frame: CGRect(x: self.view.frame.width / 2.0 - 60.0, y: 40.0, width: 120.0, height: 30.0))
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        label.textAlignment = .center
        label.text = "View #\(index)"

        let description = UILabel(frame: CGRect(x: 30.0, y: 80.0, width: self.view.frame.width - 60.0, height: self.view.frame.height - 100.0))
        description.lineBreakMode = .byWordWrapping
        description.numberOfLines = 0
        description.textColor = .white
        description.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        description.textAlignment = .center
        description.text = loremIpsum[index - 1]

        view.addSubview(label)
        view.addSubview(description)

        views.append(view)
    }

    pageControl.views = views
}
```

## Properties
**PSPageControl** has a few variables that let you configure the library.

* `backgroundPicture` is an image shown in the background. Remember that it should be horizontal with proper ratio and high resolution.
* `views` is an array of `UIView`s to be shown by page control.
* `offsetPerPage` is an offset used swipe by swipe from one to another view. Default is `40`.
* `pageIndicatorTintColor` is a `UIColor` used by inactive page control indicator.
* `currentPageIndicatorTintColor` is a `UIColor` used by active page control indicator.

## Author

Piotr Sochalewski, <a href="http://sochalewski.github.io">sochalewski.github.io</a>

## License

PSPageControl is available under the MIT license. See the LICENSE file for more info.

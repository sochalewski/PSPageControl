//
//  PSPageControl.swift
//  PSPageControl
//
//  Originaly created by Piotr Sochalewski on 14.08.2015.
//  Rewritten to Swift by Piotr Sochalewski on 05.02.2016.
//

import AVFoundation
import UIKit
import UIImageViewAlignedSwift

public class PSPageControl: UIView {
    
    /**
     The image shown in the background. It should be horizontal with proper ratio and high resolution.
     */
    public var backgroundPicture: UIImage? {
        didSet {
            guard let backgroundPicture = backgroundPicture else { return }
            
            let size = AVMakeRectWithAspectRatioInsideRect(backgroundPicture.size,
                CGRect(x: 0, y: 0, width: CGFloat.max, height: frame.height)).size
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            backgroundPicture.drawInRect(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            background.image = image
        }
    }
    
    /**
     The array of `UIView`s to be shown by page control.
     */
    public var views: [UIView]? {
        didSet {
            subviews.forEach { subview in
                if !subviewsNotAllowedToRemoveFromSuperview.contains(subview) {
                    subview.removeFromSuperview()
                }
            }
            
            for (index, view) in views!.enumerate() {
                view.frame = CGRect(x: CGFloat(index) * frame.width,
                    y: 0.0,
                    width: frame.width,
                    height: frame.height)
                addSubview(view)
            }
            
            pageControl.numberOfPages = views!.count
        }
    }
    
    /**
     Offset per page in pixels. Default is `40`.
     */
    public var offsetPerPage: UInt = 40
    
    /**
     The tint color to be used for the page indicator.
     */
    public var pageIndicatorTintColor: UIColor? {
        set {
            pageControl.pageIndicatorTintColor = newValue
        }
        get {
            return self.pageIndicatorTintColor
        }
    }
    
    /**
     The tint color to be used for the current page indicator.
     */
    public var currentPageIndicatorTintColor: UIColor? {
        set {
            pageControl.currentPageIndicatorTintColor = newValue
        }
        get {
            return self.currentPageIndicatorTintColor
        }
    }
    
    private var subviewsNotAllowedToRemoveFromSuperview = [UIView]()
    private var background = UIImageViewAligned()
    private var pageControl = UIPageControl()
    private var touchPosition: CGPoint?
    private var currentViewIndex: Int = 0
    private var backgroundLayerFrameOrigin: CGPoint?
    
    private func setup() {
        // Background image
        background.contentMode = .ScaleAspectFill
        background.alignment = .Left
        addSubview(background)
        
        // Page control
        pageControl.addTarget(self, action: "pageControlValueChanged:", forControlEvents: .ValueChanged)
        addSubview(pageControl)
        
        // Array of views not allowed to remove from superview
        subviewsNotAllowedToRemoveFromSuperview = [background, pageControl]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Background image
        background.frame = frame
        background.layer.frame = CGRect(x: -CGFloat(offsetPerPage),
            y: 0.0,
            width: background.layer.frame.width,
            height: background.layer.frame.height)
        backgroundLayerFrameOrigin = background.layer.frame.origin
        
        // Page control
        pageControl.frame = CGRect(x: 10.0, y: frame.height - 50.0, width: frame.width - 20.0, height: 40.0)
    }
    
    // MARK: - Views
    
    private func showViewWithIndex(index: Int, setCurrentPage currentPage: Bool) {
        // Background image
        if index != currentViewIndex {
            let sign: CGFloat = (index > currentViewIndex) ? -1 : 1 // plus or minus for newX
            let newX = backgroundLayerFrameOrigin!.x + sign * CGFloat(offsetPerPage)
            backgroundLayerFrameOrigin = CGPoint(x: newX, y: 0.0)
        }
        
        let duration = (index == currentViewIndex) ? 0.3 : 0.2
        UIView.animateWithDuration(duration) {
            self.background.layer.frame = CGRect(x: self.backgroundLayerFrameOrigin!.x, y: 0.0, width: self.background.layer.frame.width, height: self.background.layer.frame.height)
        }
        
        // Views
        UIView.animateWithDuration(0.2,
            animations: {
                // Center (show) view with current index
                let view = self.views![index]
                view.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
                
                // Move to the left views with index lower than >index<
                // and to the right views with index higher than >index<
                for (i, view) in self.views!.enumerate() {
                    let newX: CGFloat
                    switch i {
                    case let x where x < index:
                        newX = CGFloat(-(index - i)) * self.frame.width
                    case let x where x > index:
                        newX = CGFloat(i - index) * self.frame.width
                    default:
                        newX = 0.0
                    }
                    
                    view.frame.origin = CGPoint(x: newX, y: 0.0)
                }
            },
            completion: { _ in
                if currentPage {
                    self.pageControl.currentPage = index
                }
                self.currentViewIndex = index
            }
        )
    }
    
    // MARK: - Touches
    
    private func differenceFromTouches(touches: Set<UITouch>) -> Int {
        let movingPosition = touches.first?.locationInView(self)
        
        return Int(movingPosition!.x - touchPosition!.x)
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        touchPosition = touches.first?.locationInView(self)
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let differenceInTouchXAxis = differenceFromTouches(touches)
        
        UIView.animateWithDuration(0.1) {
            for (index, view) in self.views!.enumerate() {
                view.frame = CGRect(x: CGFloat(index - self.currentViewIndex) * view.frame.width + CGFloat(differenceInTouchXAxis),
                    y: 0.0,
                    width: self.background.layer.frame.width,
                    height: self.background.layer.frame.height)
            }
            self.background.layer.frame = CGRect(x: self.backgroundLayerFrameOrigin!.x + (CGFloat(differenceInTouchXAxis) / self.frame.width) * CGFloat(self.offsetPerPage), y: 0.0, width: self.background.layer.frame.width, height: self.background.layer.frame.height)
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let differenceInTouchXAxis = differenceFromTouches(touches)
        
        switch differenceInTouchXAxis {
        case let x where x < -100:
            showViewWithIndex(currentViewIndex+1 >= views!.count ? currentViewIndex : currentViewIndex + 1, setCurrentPage: true)
        case let x where x > 100:
            showViewWithIndex(currentViewIndex < 1 ? currentViewIndex : currentViewIndex - 1, setCurrentPage: true)
        default:
            showViewWithIndex(currentViewIndex, setCurrentPage: false)
        }
    }
    
}
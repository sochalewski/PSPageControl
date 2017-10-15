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

/**
 Event to detect when PSPageControl was changed
 */
public protocol PSPageControlProtocol {
    func didChange(index: Int)
}

open class PSPageControl: UIView {
    
    /**
     The image shown in the background. It should be horizontal with proper ratio and high resolution.
     */
    open var backgroundPicture: UIImage? {
        didSet {
            guard let backgroundPicture = backgroundPicture else { return }
            
            let size = AVMakeRect(aspectRatio: backgroundPicture.size,
                                  insideRect: CGRect(x: 0.0, y: 0.0, width: CGFloat.greatestFiniteMagnitude, height: frame.height)).size
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            backgroundPicture.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            background.image = image
        }
    }
    
    /**
     The array of `UIView`s to be shown by page control.
     */
    open var views: [UIView]? {
        didSet {
            subviews.filter( { !subviewsNotAllowedToRemoveFromSuperview.contains($0) } ).forEach {
                $0.removeFromSuperview()
            }
            
            guard let views = views else { pageControl.numberOfPages = 0; return }
            
            for (index, view) in views.enumerated() {
                view.frame = CGRect(x: CGFloat(index) * frame.width,
                    y: 0.0,
                    width: frame.width,
                    height: frame.height)
                addSubview(view)
            }
            
            pageControl.numberOfPages = views.count
        }
    }
    
    /**
     Offset per page in pixels. Default is `40`.
     */
    open var offsetPerPage: UInt = 40
    
    /**
     The tint color to be used for the page indicator.
     */
    open var pageIndicatorTintColor: UIColor? {
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
    open var currentPageIndicatorTintColor: UIColor? {
        set {
            pageControl.currentPageIndicatorTintColor = newValue
        }
        get {
            return self.currentPageIndicatorTintColor
        }
    }
    
    /**
     The frame rectangle, which describes the page indicators' location and size in its superview’s coordinate system.
     
     Changes to this property can be animated.
     */
    open var pageIndicatorFrame: CGRect {
        get {
            return pageControl.frame
        }
        set {
            pageControl.frame = newValue
        }
    }
    
    fileprivate var subviewsNotAllowedToRemoveFromSuperview = [UIView]()
    fileprivate var background = UIImageViewAligned()
    fileprivate var pageControl = UIPageControl()
    fileprivate var touchPosition: CGPoint?
    fileprivate var backgroundLayerFrameOrigin: CGPoint?
    
    /// Delegate to detect when current PSPageControl changed
    open var delegate: PSPageControlProtocol?

    /**
         Get current PSPageViewControl
     */
    open var currentViewIndex = 0 {
        didSet {
            delegate?.didChange(index: currentViewIndex)
        }
    }
    
    
    fileprivate func setup() {
        // Background image
        background.contentMode = .scaleAspectFill
        background.alignment = .left
        addSubview(background)
        
        // Page control
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Background image
        background.frame = frame
        background.layer.frame = CGRect(x: CGFloat(-currentViewIndex - 1) * CGFloat(offsetPerPage), y: 0.0, width: background.layer.frame.width, height: background.layer.frame.height)
        backgroundLayerFrameOrigin = background.layer.frame.origin
        
        // Page control
        pageControl.frame = CGRect(x: 10.0, y: frame.height - 50.0, width: frame.width - 20.0, height: 40.0)
    }
    
    // MARK: - Views
    
    /**
     Shows a view with a given index.
     
     - parameter index: The index of page that should be shown by the receiver as a white dot. The property value is an integer specifying a page shown minus one; thus a value of indicates the first page. Values outside the possible range are pinned to either 0 or numberOfPages minus 1.
     - returns: A Boolean value that determines whether the function finished with success.
     */
    public func showView(withIndex index: Int) -> Bool {
        if let views = views, index < views.count, index >= 0 {
            showView(withIndex: index, setCurrentPage: true)
            return true
        } else {
            return false
        }
    }
    
    fileprivate func showView(withIndex index: Int, setCurrentPage currentPage: Bool) {
        // Background image
        if index != currentViewIndex {
            let newX = CGFloat(-index - 1) * CGFloat(offsetPerPage)
            backgroundLayerFrameOrigin = CGPoint(x: newX, y: 0.0)
        }
        
        let duration = (index == currentViewIndex) ? 0.3 : 0.2
        currentViewIndex = index
        UIView.animate(withDuration: duration) {
            self.background.layer.frame = CGRect(x: self.backgroundLayerFrameOrigin!.x,
                                                 y: 0.0,
                                                 width: self.background.layer.frame.width,
                                                 height: self.background.layer.frame.height)
        }
        
        // Views
        UIView.animate(withDuration: 0.2, animations: {
            // Center (show) view with current index
            let view = self.views![index]
            view.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
            
            // Move to the left views with index lower than >index<
            // and to the right views with index higher than >index<
            for (i, view) in self.views!.enumerated() {
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
        }) {  _ in
            if currentPage {
                self.pageControl.currentPage = index
            }
        }
    }
    
    // MARK: - Touches
    
    fileprivate func difference(fromTouches touches: Set<UITouch>) -> Int {
        let movingPosition = touches.first?.location(in: self)
        
        return Int(movingPosition!.x - touchPosition!.x)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        touchPosition = touches.first?.location(in: self)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let differenceInTouchXAxis = difference(fromTouches: touches)
        
        UIView.animate(withDuration: 0.1) {
            for (index, view) in self.views!.enumerated() {
                view.frame = CGRect(x: CGFloat(index - self.currentViewIndex) * view.frame.width + CGFloat(differenceInTouchXAxis), y: 0.0,
                    width: self.background.layer.frame.width, height: self.background.layer.frame.height)
            }
            let x = CGFloat(-self.currentViewIndex - 1) * CGFloat(self.offsetPerPage)
            let deltaX = (CGFloat(differenceInTouchXAxis) / self.frame.width) * CGFloat(self.offsetPerPage)
            self.background.layer.frame = CGRect(x: x + deltaX, y: 0.0, width: self.background.layer.frame.width, height: self.background.layer.frame.height)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let differenceInTouchXAxis = difference(fromTouches: touches)
        
        switch differenceInTouchXAxis {
        case let x where x < -100:
            showView(withIndex: currentViewIndex + 1 >= views!.count ? currentViewIndex : currentViewIndex + 1, setCurrentPage: true)
        case let x where x > 100:
            showView(withIndex: currentViewIndex < 1 ? currentViewIndex : currentViewIndex - 1, setCurrentPage: true)
        default:
            showView(withIndex: currentViewIndex, setCurrentPage: false)
        }
    }
}

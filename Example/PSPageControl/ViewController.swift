//
//  ViewController.swift
//  PSPageControl
//
//  Created by Piotr Sochalewski on 02/08/2016.
//  Copyright (c) 2016 Piotr Sochalewski. All rights reserved.
//

import UIKit
import PSPageControl

class ViewController: UIViewController {
    
    @IBOutlet weak var pageControl: PSPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            let label = UILabel(frame: CGRect(x: self.view.frame.width / 2.0 - 60.0,
                y: 40.0,
                width: 120.0,
                height: 30.0))
            label.textColor = .whiteColor()
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
            label.textAlignment = .Center
            label.text = "View #\(index)"
            
            let description = UILabel(frame: CGRect(x: 30.0,
                y: 80.0,
                width: self.view.frame.width - 60.0,
                height: self.view.frame.height - 100.0))
            description.lineBreakMode = .ByWordWrapping
            description.numberOfLines = 0
            description.textColor = .whiteColor()
            description.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
            description.textAlignment = .Center
            description.text = loremIpsum[index - 1]
            
            view.addSubview(label)
            view.addSubview(description)
            
            views.append(view)
        }
        
        pageControl.views = views
    }

}

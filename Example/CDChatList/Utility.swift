//
//  Utility.swift
//  CDChatList_Example
//
//  Created by chdo on 2017/11/24.
//  Copyright © 2017年 chdo002. All rights reserved.
//

import UIKit

var viwer :ImageViewer?

public class ImageViewer: NSObject {
    
    var window : UIWindow?
    var vc = UIViewController()
    var imageView = UIImageView()
    
    
    public static func showImage(image:UIImage, rectInWindow rect: CGRect){
        
        viwer = ImageViewer()
        let showWd = viwer?.window
        showWd?.makeKeyAndVisible()
        viwer?.imageView.image = image
        viwer?.imageView.frame = rect
     
     
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            viwer?.imageView.frame = (viwer?.vc.view.bounds)!
            viwer?.imageView.contentMode = .scaleAspectFit
        }) { (res) in
            
        }
    }
    
    public override init() {
        super.init()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        vc.view.backgroundColor = .white
        vc.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panmoved(ges:)))
        vc.view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapges(ges:)))
        vc.view.addGestureRecognizer(tap)
    }
    
    var movBeginPoint : CGPoint!
    func panmoved(ges: UIPanGestureRecognizer) {
        
        switch ges.state {
        case .began:
            movBeginPoint = ges.location(in: ges.view)
        case .changed:
            var currentPoint = ges.location(in: ges.view)
            let deltaY = currentPoint.y - movBeginPoint.y
            if deltaY > 0 {
                let halfScr = UIScreen.main.bounds.size.height * 0.5
                let calAlpha =  1 - (deltaY / halfScr)
                let newAlpha = calAlpha >= 0 ? calAlpha : 0
                vc.view.backgroundColor = UIColor(white: 1, alpha: newAlpha)
            }
            
            let trans = ges.translation(in: ges.view)
            imageView.center = CGPoint(x: imageView.center.x + trans.x,
                                       y: imageView.center.y + trans.y)
            ges.setTranslation(CGPoint.zero, in: ges.view)
            
        default:
            tapges(ges: ges)
        }
    }
    func tapges(ges: UIPanGestureRecognizer){
        window?.resignKey()
        window = nil
    }
}

//
//  UIViewControllerExtension.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/29/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertNoResponse(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func moveToNextView(storyBoardIdentifier: String, viewIdentifier: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: storyBoardIdentifier, bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewIdentifier)
        self.present(nextViewController, animated:true, completion:nil)
    }
}

public extension UIView {
    
    func shake(count: Float = 4, for duration: TimeInterval = 0.5, withTranslation translation: Float = 5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}

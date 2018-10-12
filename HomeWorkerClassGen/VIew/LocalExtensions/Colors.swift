//
//  Colors.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

enum Colors {
    case Green, Blue, Red, Purple, Yellow, Orange, Pink, Teal
}

extension UIColor {
    
    private static let mainGreen = UIColor(red: 56/255, green: 126/255, blue: 31/255, alpha: 1.0)
    private static let mainBlue = UIColor(red: 35/255, green: 77/255, blue: 159/255, alpha: 1.0)
    private static let mainRed = UIColor(red: 164/255, green: 36/255, blue: 36/255, alpha: 1.0)
    private static let mainPurple = UIColor(red: 107/255, green: 31/255, blue: 126/255, alpha: 1.0)
    private static let mainYellow = UIColor(red: 182/255, green: 151/255, blue: 41/255, alpha: 1.0)
    private static let mainOrange = UIColor(red: 205/255, green: 111/255, blue: 0/255, alpha: 1.0)
    private static let mainPink = UIColor(red: 165/255, green: 82/255, blue: 167/255, alpha: 1.0)
    private static let mainTeal = UIColor(red: 38/255, green: 146/255, blue: 126/255, alpha: 1.0)
    
    public static let mainColorOptionCount = 8
    public static let mainColorArray = [mainGreen, mainBlue, mainRed, mainPurple, mainYellow, mainOrange, mainPink, mainTeal]
    
    public static func retrieveMainColor(withAlpha tint: CGFloat) -> UIColor {
        guard let color = UserDefaults.standard.object(forKey: "mainColor") as? UIColor else { return mainGreen.withAlphaComponent(tint) }
        return color.withAlphaComponent(tint)
    }
    
    static func setMainColor(_ colorCase: Colors) {
        
        var newMainColor: UIColor!
        
        switch colorCase {
            
        case .Green:
            newMainColor = mainGreen
        case .Blue:
            newMainColor = mainBlue
        case .Red:
            newMainColor = mainRed
        case .Purple:
            newMainColor = mainPurple
        case .Yellow:
            newMainColor = mainYellow
        case .Orange:
            newMainColor = mainOrange
        case .Pink:
            newMainColor = mainPink
        case .Teal:
            newMainColor = mainTeal
        }
        
        UserDefaults.standard.set(newMainColor, forKey: "mainColor")
    }
    
}

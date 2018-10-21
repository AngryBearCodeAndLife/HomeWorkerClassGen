//
//  Colors.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

public enum Colors {
    case Green, Blue, Red, Purple, Yellow, Orange, Pink, Teal
}

extension Colors: CaseIterable {}

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
        guard let color = UserDefaults.standard.colorForKey(key: "mainColor") else { return mainGreen.withAlphaComponent(tint) }
        return color.withAlphaComponent(tint)
    }
    
    public static func retrieveMainColorName() -> String {
        guard let color = UserDefaults.standard.string(forKey: "mainColorName") else { return "Green" }
        return color
    }
    
    public static func getColor(_ colorCase: Colors) -> UIColor {
        switch colorCase {
            
        case .Green:
            return mainGreen
        case .Blue:
            return mainBlue
        case .Red:
            return mainRed
        case .Purple:
            return mainPurple
        case .Yellow:
            return mainYellow
        case .Orange:
            return mainOrange
        case .Pink:
            return mainPink
        case .Teal:
            return mainTeal
        }
    }
    
    public static func setMainColor(_ colorCase: Colors) {
        
        var newMainColor: UIColor!
        var newMainColorName = ""
        
        switch colorCase {
            
        case .Green:
            newMainColor = mainGreen
            newMainColorName = "Green"
        case .Blue:
            newMainColor = mainBlue
            newMainColorName = "Blue"
        case .Red:
            newMainColor = mainRed
            newMainColorName = "Red"
        case .Purple:
            newMainColor = mainPurple
            newMainColorName = "Purple"
        case .Yellow:
            newMainColor = mainYellow
            newMainColorName = "Yellow"
        case .Orange:
            newMainColor = mainOrange
            newMainColorName = "Orange"
        case .Pink:
            newMainColor = mainPink
            newMainColorName = "Pink"
        case .Teal:
            newMainColor = mainTeal
            newMainColorName = "Teal"
        }
        
        UserDefaults.standard.setColor(color: newMainColor, forKey: "mainColor")
        UserDefaults.standard.set(newMainColorName, forKey: "mainColorName")
    }
    
}

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    
}

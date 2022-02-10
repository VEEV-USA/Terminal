//
//  Bundle+Extension.swift
//  chameleon
//
//  Created by Dare on 2/7/22.
//

import SwiftUI

extension Bundle {
    var apiBaseURL: String {
      return object(forInfoDictionaryKey: "apiBaseURL") as? String ?? ""
    }
    
    var releaseVersion: String {
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        return version
    }
    
    var buildVersion: String {
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleVersion"] as AnyObject
        let version = nsObject as! String
        return version
    }
}

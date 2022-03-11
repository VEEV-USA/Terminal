//
//  UIImage+JPEG.swift
//  chameleon
//
//  Created by Darren on 3/10/22.
//

import SwiftUI

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.50
        case high    = 0.75
        case highest = 1
    }
    
    ///- returns data object representing jpeg or nil if there is a problem generating jpeg and/or image has no data
    func jpeg(quality jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

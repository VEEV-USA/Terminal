//
//  View+NavBar.swift
//  chameleon
//
//  Created by Dare on 2/1/22.
//

import SwiftUI

extension View {
 
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }

}

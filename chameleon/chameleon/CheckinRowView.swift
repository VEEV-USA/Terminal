//
//  CheckinRowView.swift
//  chameleon
//
//  Created by Dare on 2/22/22.
//

import SwiftUI

struct CheckinRowView: View {
    
    let checkin: Checkin!
    
    var body: some View {
        HStack {
            Text(checkin.userHandle ?? "n/a")
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 30)
            Text(checkin.createdAt ?? "n/a")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

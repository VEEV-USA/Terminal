//
//  CheckinRowView.swift
//  chameleon
//
//  Created by Dare on 2/22/22.
//

import SwiftUI

struct CheckinRowView: View {
    
    let checkin: Checkin!
    var _timestamp: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy hh:mm a"
            let date = Persistence.dateFormatter.date(from: checkin.createdAt ?? "") ?? Date()
            return dateFormatter.string(from: date)
        }
    }
    
    var body: some View {
        HStack {
            Text(checkin.userHandle ?? "n/a")
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 30)
            Text(_timestamp)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//
//  EventListView.swift
//  chameleon
//
//  Created by Dare on 2/28/22.
//

import SwiftUI

struct EventListView: View {
    @ObservedObject var eventsViewModel: EventsViewModel = .init()
    
    let threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    private func EventsGrid() -> some View {
        return (
            LazyVGrid(columns: threeColumnGrid, spacing: 32) {
                ForEach(eventsViewModel.events, id: \.self) { event in
                                        let eventTitle = event.name
                    NavigationLink(destination: EventView(event: event)) {
                        VStack {
                            Image("calendar")
                                .resizable()
                                .frame(minWidth: 30, idealWidth: 50, maxWidth: 50, minHeight: 30, idealHeight: 50, maxHeight: 50, alignment: .center)
                                .scaledToFit()
                            Text(eventTitle ?? "n/a")
                                .foregroundColor(.black)
                                .font(.headline)
                                .padding()
                        }
                    }
                }
            }
        )
    }
    
    var body: some View {
        VStack {
            ScrollView {
                EventsGrid()
            }
            Spacer(minLength: 24)
        }
        .padding(32)
        .navigationBarColor(UIColor(named: "VEEV_RED") ?? .red)
    }
}

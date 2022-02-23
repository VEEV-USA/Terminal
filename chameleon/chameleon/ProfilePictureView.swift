//
//  ProfilePictureView.swift
//  chameleon
//
//  Created by Dare on 2/22/22.
//

import SwiftUI
import Foundation
import Combine


struct ProfilePictureView<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    @State var image: UIImage = UIImage(named: "ic_person") ?? UIImage()
    private let placeholder: Placeholder
    
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                if #available(iOS 15.0, *) {
                    Image(uiImage: loader.image!)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                        .overlay {
                            Circle().stroke(.gray, lineWidth: 4)
                        }
                        .shadow(radius: 7.0)
                        .padding()
                } else {
                    Image(uiImage: .checkmark)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .leading)
                        .shadow(radius: 7.0)
                        .padding()
                }
            } else {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                        .shadow(radius: 7.0)
                        .padding()
                    placeholder
                }
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?
    
    private var cache: ImageCache?

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        cancel()
    }
    
    func load() {
        if let image = cache?[url] {
                    self.image = image
                    return
                }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: nil)
                    .handleEvents(receiveOutput: { [weak self] in self?.cache(image: $0) })
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] in self?.image = $0 }
    }
    
    private func cache(image: UIImage?) {
        image.map { cache?[url] = $0 }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

//
//  ImageURLView.swift
//  ActorApp
//
//  Created by ADyatkov on 24.11.2021.
//

import SwiftUI

struct ImageURLView: View {
    
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    let size: CGSize
    
    init(withURL url: String, size: CGSize) {
        imageLoader = ImageLoader(urlString: url)
        self.size = size
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.width, height: size.height)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}

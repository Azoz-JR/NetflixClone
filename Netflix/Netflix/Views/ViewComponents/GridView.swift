//
//  GridView.swift
//  Netflix
//
//  Created by Azoz Salah on 03/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct GridView: View {
    
    let shows: [ItemViewModel]
    let columns = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
            ForEach(shows) { item in
                NavigationLink {
                    ShowTrailerView(show: item)
                } label: {
                    if let url = item.posterURL {
                        WebImage(url: url)
                            .resizable()
                            .frame(width: 120, height: 200)
                    }
                }
            }
            
        }
    }
}

#Preview {
    GridView(shows: [])
}

//
//  StackView.swift
//  Netflix
//
//  Created by Azoz Salah on 03/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct StackView: View {
    
    let shows: [ItemViewModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(shows) { item in
                NavigationLink {
                    ShowTrailerView(show: item)
                } label: {
                    if let url = item.posterURL {
                        HStack {
                            WebImage(url: url)
                                .resizable()
                                .frame(width: 100, height: 150)
                                .padding(.horizontal)
                            
                            Text(item.title)
                                .font(.title3.bold())
                        }
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
        }
    }
}

#Preview {
    StackView(shows: [])
}

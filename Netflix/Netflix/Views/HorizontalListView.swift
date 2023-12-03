//
//  HorizontalListView.swift
//  Netflix
//
//  Created by Azoz Salah on 02/02/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HorizontalListView: View {
    @EnvironmentObject var viewModel: NetflixViewModel
    let listTitle: String
    let items: [ItemViewModel]
    let type: ShowType
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(listTitle)
                .font(.title2.bold())
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack(spacing: 10) {
                    ForEach(items) { item in
                        NavigationLink {
                            ShowTrailerView(show: item)
                        } label: {
                            if let url = item.posterURL {
                                WebImage(url: url)
                                    .resizable()
                                    .frame(width: 140, height: 200)
                                    .contextMenu {
                                        ShowMenu(item: item)
                                    }
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

struct HorizontalListView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalListView(listTitle: "", items: [], type: .movies)
            .environmentObject(NetflixViewModel())
    }
}

//
//  ShowView.swift
//  Netflix
//
//  Created by Azoz Salah on 02/02/2023.
//

import SwiftUI

struct ShowTrailerView: View {
    
    @EnvironmentObject var viewModel: NetflixViewModel
    
    let show: ItemViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = URL(string: "https://www.youtube.com/embed/\(viewModel.selectedShowVideoElement.id.videoId)") {
                    WebView(url: url)
                        .frame(maxWidth: .infinity, idealHeight: 300)
                }
                
                
                Text(show.title)
                    .font(.title.bold())
                    .padding(.vertical)
                
                Text("Overview")
                    .font(.title2.bold())
                    .padding(.bottom, 5)
                
                Text(show.overview)
                
                Button {
                    if viewModel.isShowDownloaded(item: show) {
                        viewModel.deleteShow(item: show)
                    } else {
                        viewModel.downloadShow(item: show)
                    }
                } label: {
                    Text(viewModel.isShowDownloaded(item: show) ? "Remove" : "Download")
                        .font(.headline)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(.red))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                await viewModel.fetchTrailer(searchText: show.title + "trailer")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { }
            }
        }
    }
}

struct ShowTrailerView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTrailerView(show: ItemViewModel.example)
            .environmentObject(NetflixViewModel())
    }
}

//
//  TvTrailerView.swift
//  Netflix
//
//  Created by Azoz Salah on 06/02/2023.
//

import SwiftUI

struct TvTrailerView: View {
    @EnvironmentObject var viewModel: NetflixViewModel
    
    let tv: Tv
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let url = URL(string: "https://www.youtube.com/embed/\(viewModel.selectedShowVideoElement.id.videoId)") {
                    WebView(url: url)
                        .frame(maxWidth: .infinity, idealHeight: 300)
                }
                
                
                Text(tv.wrappedTitle)
                    .font(.title.bold())
                
                Text("Overview")
                    .font(.title2)
                
                Text(tv.wrappedOverview)
                
                Button {
                    if viewModel.downloadedTVs.contains(where: { $0 == tv}) {
                        if let index = viewModel.downloadedTVs.firstIndex(where: { $0 == tv }) {
                            viewModel.removeTv(at: index)
                        }
                    } else {
                        viewModel.downloadTv(tv: tv)
                    }
                } label: {
                    Text(viewModel.downloadedTVs.contains(where: { $0 == tv}) ? "Remove" : "Download")
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
                await viewModel.fetchTrailer(searchText: tv.wrappedTitle + "trailer")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    
                }
            }
        }
    }
}

struct TvTrailerView_Previews: PreviewProvider {
    static var previews: some View {
        TvTrailerView(tv: Tv(id: 1, media_type: "", name: "", origin_country: [""], original_language: "", original_name: "", overview: "", poster_path: "", vote_average: 1, vote_count: 1))
            .environmentObject(NetflixViewModel())
    }
}

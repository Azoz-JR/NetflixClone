//
//  TrailerView.swift
//  Netflix
//
//  Created by Azoz Salah on 02/02/2023.
//

import SwiftUI

struct MovieTrailerView: View {
    
    @EnvironmentObject var viewModel: NetflixViewModel
    
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = URL(string: "https://www.youtube.com/embed/\(viewModel.selectedShowVideoElement.id.videoId)") {
                    WebView(url: url)
                        .frame(maxWidth: .infinity, idealHeight: 300)
                }
                
                
                Text(movie.wrappedTitle)
                    .font(.title.bold())
                    .padding(.vertical)
                
                Text("Overview")
                    .font(.title2.bold())
                    .padding(.bottom, 5)
                
                Text(movie.wrappedOverview)
                
                Button {
                    if viewModel.downloadedMovies.contains(where: { $0 == movie}) {
                        if let index = viewModel.downloadedMovies.firstIndex(where: { $0 == movie }) {
                            viewModel.removeMovie(at: index)
                        }
                    } else {
                        viewModel.downloadMovie(movie: movie)
                    }
                } label: {
                    Text(viewModel.downloadedMovies.contains(where: { $0 == movie}) ? "Remove" : "Download")
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
                await viewModel.fetchTrailer(searchText: movie.wrappedTitle + "trailer")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    
                }
            }
        }
    }
}

struct MovieTrailerView_Previews: PreviewProvider {
    static var previews: some View {
        MovieTrailerView(movie: Movie(id: 1, original_language: "", original_title: "", overview: "", poster_path: "", release_date: "", title: "", vote_average: 1, vote_count: 1))
            .environmentObject(NetflixViewModel())
    }
}

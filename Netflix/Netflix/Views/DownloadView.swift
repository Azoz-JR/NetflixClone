//
//  DownloadView.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DownloadView: View {
    
    @EnvironmentObject var viewModel: NetflixViewModel
    
    @State private var type = ShowType.movies
    
    let types: [ShowType] = [.movies, .TVs]
    
    var body: some View {
        NavigationView {
            List {
                if type == .movies {
                    ForEach(viewModel.downloadedMovies) { movie in
                        NavigationLink {
                            MovieTrailerView(movie: movie)
                        } label: {
                            if let url = movie.posterURL {
                                HStack {
                                    WebImage(url: url)
                                        .resizable()
                                        .frame(width: 100, height: 150)
                                    
                                    Text(movie.wrappedTitle)
                                        .font(.title3.bold())
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.removeMovieFromList)
                } else {
                    ForEach(viewModel.downloadedTVs) { tv in
                        NavigationLink {
                            TvTrailerView(tv: tv)
                        } label: {
                            if let url = tv.posterURL {
                                HStack {
                                    WebImage(url: url)
                                        .resizable()
                                        .frame(width: 100, height: 150)
                                        .padding(.horizontal)
                                    
                                    Text(tv.wrappedTitle)
                                        .font(.title3.bold())
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.removeTvFromList)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Downloads")
            .toolbar {
                ToolbarItem(placement: .status) {
                    Picker("Pick your list", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0.rawValue)
                                .font(.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 300)
                }
            }
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
            .environmentObject(NetflixViewModel())
    }
}

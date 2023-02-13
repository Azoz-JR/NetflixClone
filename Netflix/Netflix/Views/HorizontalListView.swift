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
    let movies: [Movie]?
    let Tvs: [Tv]?
    let type: TitleType
    
    init(listTitle: String, movies: [Movie]? = nil, Tvs: [Tv]? = nil, type: TitleType) {
        self.listTitle = listTitle
        self.movies = movies
        self.Tvs = Tvs
        self.type = type
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(listTitle)
                .font(.title2.bold())
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack(spacing: 10) {
                    if let list = movies {
                        ForEach(list) { movie in
                            NavigationLink {
                                MovieTrailerView(movie: movie)
                            } label: {
                                if let url = movie.posterURL {
                                    WebImage(url: url)
                                        .resizable()
                                        .frame(width: 140, height: 200)
                                        .contextMenu {
                                            if viewModel.downloadedMovies.contains(where: { $0 == movie}) {
                                                Button(role: .destructive) {
                                                    if let index = viewModel.downloadedMovies.firstIndex(where: { $0 == movie }) {
                                                        viewModel.removeMovie(at: index)
                                                    }
                                                } label: {
                                                    Label("Remove", systemImage: "trash.fill")
                                                }
                                            } else {
                                                Button {
                                                    viewModel.downloadMovie(movie: movie)
                                                } label: {
                                                    Label("Download", systemImage: "arrow.down.to.line")
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    } else if let list = Tvs {
                        ForEach(list) { tv in
                            NavigationLink {
                                TvTrailerView(tv: tv)
                            } label: {
                                if let url = tv.posterURL {
                                    WebImage(url: url)
                                        .resizable()
                                        .frame(width: 140, height: 200)
                                        .contextMenu {
                                            if viewModel.downloadedTVs.contains(where: { $0 == tv}) {
                                                Button(role: .destructive) {
                                                    if let index = viewModel.downloadedTVs.firstIndex(where: { $0 == tv }) {
                                                        viewModel.removeTv(at: index)
                                                    }
                                                } label: {
                                                    Label("Remove", systemImage: "trash.fill")
                                                }
                                            } else {
                                                Button {
                                                    viewModel.downloadTv(tv: tv)
                                                } label: {
                                                    Label("Download", systemImage: "arrow.down.to.line")
                                                }
                                            }
                                        }
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
        HorizontalListView(listTitle: "", type: .topRatedMovies)
            .environmentObject(NetflixViewModel())
    }
}

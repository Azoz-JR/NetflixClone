//
//  HomeView.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: NetflixViewModel
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var imageManager = ImageManager()
    
    @State private var mainPosterIndex = 0
    @State private var fadeOut = false
    @State private var mainImage = Image(uiImage: UIImage())
    @State private var selectedMovie = Movie.example
    @State private var isActive = true
    @State private var showingDetailView = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(spacing: 30) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "play.square")
                                .font(.title)
                        }
                        
                        Button {
                            
                        }label: {
                            Image(systemName: "person")
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                    
                    ZStack(alignment: .bottom) {
                        if !viewModel.trendingMovies.isEmpty {
                            mainImage
                                .resizable()
                                .frame(maxWidth: .infinity, idealHeight: 500)
                                .transition(.fade(duration: 2))
                                .animation(.easeInOut(duration: 0.5), value: fadeOut)
                            HStack(spacing: 40) {
                                Button {
                                    showingDetailView = true
                                } label: {
                                    Text("Play")
                                        .font(.title3)
                                        .frame(width: 140, height: 40)
                                        .background(Rectangle().fill(.black.opacity(0.6)))
                                        .overlay(
                                            Rectangle().stroke(.white, lineWidth: 2)
                                        )
                                        .offset(y: -25)
                                }
                                
                                Button {
                                    if viewModel.downloadedMovies.contains(where: {$0 == selectedMovie}) {
                                        if let index = viewModel.downloadedMovies.firstIndex(where: { $0 == selectedMovie }) {
                                            viewModel.removeMovie(at: index)
                                        }
                                    } else {
                                        viewModel.downloadMovie(movie: selectedMovie)
                                    }
                                } label: {
                                    Text(viewModel.downloadedMovies.contains(where: {$0 == selectedMovie}) ? "Remove" : "Download")
                                        .font(.title3)
                                        .frame(width: 140, height: 40)
                                        .background(Rectangle().fill(.black.opacity(0.6)))
                                        .overlay(
                                            Rectangle().stroke(.white, lineWidth: 2)
                                        )
                                        .offset(y: -25)
                                }
                            }
                        } else {
                            ProgressView()
                                .frame(maxWidth: .infinity, idealHeight: 500)
                        }
                        
                        
                    }
                    
                    HorizontalListView(listTitle: "Trending Movies", movies: viewModel.trendingMovies, type: .trendingMovies)
                    
                    HorizontalListView(listTitle: "Trending TVs", Tvs: viewModel.trendingTvs, type: .trendingTVs)
                    
                    HorizontalListView(listTitle: "Popular Movies", movies: viewModel.popularMovies, type: .popularMovies)
                    
                    HorizontalListView(listTitle: "Upcoming Movies", movies: viewModel.upcomingMovies, type: .upcomingMovies)
                    
                    HorizontalListView(listTitle: "Top Rated Movies", movies: viewModel.topRatedMovies, type: .topRatedMovies)
                    
                    HorizontalListView(listTitle: "Top Rated TVs", movies: nil, Tvs: viewModel.topRatedTvs, type: .topRatedTVs)
                    
                }
            }
            .background(.black.opacity(0.1))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    if !viewModel.trendingMovies.isEmpty {
                        selectedMovie = viewModel.trendingMovies[0]
                        if let url = selectedMovie.posterURL {
                            imageManager.load(url: url)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                if let image = imageManager.image {
                                    mainImage = Image(uiImage: image)
                                }
                            }
                        }
                    }
                }
            }
            .onDisappear {
                imageManager.cancel()
            }
            .onReceive(timer) { _ in
                guard isActive else { return }
                if mainPosterIndex != viewModel.trendingMovies.count - 1 {
                    mainPosterIndex += 1
                    selectedMovie = viewModel.trendingMovies[mainPosterIndex]
                } else {
                    mainPosterIndex = 0
                    selectedMovie = viewModel.trendingMovies[mainPosterIndex]
                }
                fadeOut.toggle()
                if let url = selectedMovie.posterURL {
                    imageManager.load(url: url)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let image = imageManager.image {
                            mainImage = Image(uiImage: image)
                            fadeOut.toggle()
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    isActive = true
                } else {
                    isActive = false
                }
            }
            .onChange(of: showingDetailView) { newValue in
                if newValue {
                    isActive = false
                } else {
                    isActive = true
                }
            }
            .sheet(isPresented: $showingDetailView, content: {
                MovieTrailerView(movie: selectedMovie)
            })
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NetflixViewModel())
    }
}

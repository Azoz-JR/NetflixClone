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
    @State private var selectedShow = ItemViewModel.example
    @State private var isActive = true
    @State private var showingDetailView = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                                    if viewModel.isShowDownloaded(item: selectedShow) {
                                        viewModel.deleteShow(item: selectedShow)
                                    } else {
                                        viewModel.downloadShow(item: selectedShow)
                                    }
                                } label: {
                                    Text(viewModel.isShowDownloaded(item: selectedShow) ? "Remove" : "Download")
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
                    
                    HorizontalListView(listTitle: "Trending Movies", items: viewModel.trendingMovies, type: .movies)
                    
                    HorizontalListView(listTitle: "Trending TVs", items: viewModel.trendingTvs, type: .TVs)
                    
                    HorizontalListView(listTitle: "Popular Movies", items: viewModel.popularMovies, type: .movies)
                    
                    HorizontalListView(listTitle: "Upcoming Movies", items: viewModel.upcomingMovies, type: .movies)
                    
                    HorizontalListView(listTitle: "Top Rated Movies", items: viewModel.topRatedMovies, type: .movies)
                    
                    HorizontalListView(listTitle: "Top Rated TVs", items: viewModel.topRatedTvs, type: .TVs)
                    
                }
            }
            .background(.black.opacity(0.1))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    if !viewModel.trendingMovies.isEmpty {
                        selectedShow = viewModel.trendingMovies[0]
                        if let url = selectedShow.posterURL {
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
                    selectedShow = viewModel.trendingMovies[mainPosterIndex]
                } else {
                    mainPosterIndex = 0
                    selectedShow = viewModel.trendingMovies[mainPosterIndex]
                }
                fadeOut.toggle()
                if let url = selectedShow.posterURL {
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
                ShowTrailerView(show: selectedShow)
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

//
//  SearchView.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: NetflixViewModel
    @State private var searchText = ""
    @State private var type = ShowType.movies
    
    let types: [ShowType] = [.movies, .TVs]
    
    var gridLayout: Bool {
        if searchText.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    if gridLayout == true {
                        GridView(shows: viewModel.searchedShows)
                    } else {
                        StackView(shows: type == .movies ? viewModel.trendingMovies : viewModel.trendingTvs)
                    }
                }
            }
            .navigationTitle("Top Searches")
            .searchable(text: $searchText, placement: .automatic, prompt: "Search")
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty && !newValue.trimmingCharacters(in: .whitespaces).isEmpty && newValue.trimmingCharacters(in: .whitespaces).count >= 3 {
                    Task {
                        if type == .movies {
                            await viewModel.fetchSearchedMovies(searchText: newValue)
                        } else {
                            await viewModel.fetchSearchedTvs(searchText: newValue)
                        }
                    }
                }
            }
            .onChange(of: type) { newValue in
                if !searchText.isEmpty && !searchText.trimmingCharacters(in: .whitespaces).isEmpty && searchText.trimmingCharacters(in: .whitespaces).count >= 3 {
                    Task {
                        if newValue == .movies {
                            await viewModel.fetchSearchedMovies(searchText: searchText)
                        } else {
                            await viewModel.fetchSearchedTvs(searchText: searchText)
                        }
                    }
                }
            }
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(NetflixViewModel())
            .preferredColorScheme(.dark)
    }
}

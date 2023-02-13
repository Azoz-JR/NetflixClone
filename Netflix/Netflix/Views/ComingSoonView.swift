//
//  ComingSoonView.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComingSoonView: View {
    
    @EnvironmentObject var viewModel: NetflixViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.upcomingMovies) { movie in
                            NavigationLink {
                                MovieTrailerView(movie: movie)
                            } label: {
                                if let url = movie.posterURL {
                                    HStack {
                                        WebImage(url: url)
                                            .resizable()
                                            .frame(width: 100, height: 150)
                                            .padding(.horizontal)
                                        
                                        Text(movie.wrappedTitle)
                                            .font(.title2.bold())
                                    }
                                    .padding(.horizontal, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Coming Soon")
        }
        
    }
}

struct ComingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        ComingSoonView()
            .environmentObject(NetflixViewModel())
            .preferredColorScheme(.dark)
    }
}

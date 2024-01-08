//
//  MovieViewDetail.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 12/12/23.
//

import SwiftUI

struct ViewDetailMovie: View {
    @StateObject var viewModel: ViewDetailMovieViewModel
    var body: some View {
        ScrollView {
            ZStack (alignment: .center){
                AsyncImage(url: viewModel.image).cornerRadius(10)
                    .background(.black)
                    .aspectRatio(contentMode: .fill)
            }
            VStack (alignment: .leading,spacing: 5) {
                Text("Summary").font(.title).foregroundColor(.red)
                Text("\(viewModel.descripcion)").padding().foregroundColor(.white)
                Text("Cast").font(.title).foregroundColor(.red)
                Text("\(viewModel.cast ?? "")").padding().foregroundColor(.white)
                Text("Directors").font(.title).foregroundColor(.red)
                Text("\(viewModel.director ?? "")").padding().foregroundColor(.white)
                Text("Year").font(.title).foregroundColor(.red)
                Text("\(viewModel.year)").padding().foregroundColor(.white)
            }.padding()
        }
            .navigationTitle("\(viewModel.title)")
            .navigationBarTitleDisplayMode(.automatic)
            .background(Color.black)
            .task {
                await viewModel.getCreditsData()
            }
    }
}

#Preview {
    ViewDetailMovie(viewModel: .init(info: .init(adult: false, genreIds: [80,18,36], id: 466420, originalLanguage: "en", originalTitle: "Killers of the Flower Moon", overview: "When oil is discovered in 1920s Oklahoma under Osage Nation land, the Osage people are murdered one by one—until the FBI steps in to unravel the mystery.", popularity: 2057.537, posterPath: "/dB6Krk806zeqd0YNp2ngQ9zXteH.jpg", releaseDate: Date(), title: "Killers of the Flower Moon", video: false, voteAverage:  7.669, voteCount: 1338)))
}

//
//  MovieViewDetail.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 12/12/23.
//

import SwiftUI

struct ViewDetailMovie: View {
    var viewModel: ViewDetailMovieViewModel
    var body: some View {
        ScrollView {
            ZStack (alignment: .center){
                AsyncImage(url: viewModel.image).cornerRadius(10).background(.black)
                    .scaledToFill()
            }.frame(width: .infinity)
            VStack (alignment: .leading,spacing: 5) {
                Text("\(viewModel.title)").font(.title).padding()
                Text("Summary").font(.title)
                Text("\(viewModel.descripcion)").padding()
                Text("Cast").font(.title)
                Text("\(viewModel.cast)").padding()
                Text("Directors").font(.title)
                Text("\(viewModel.director)").padding()
                Text("Year").font(.title)
                Text("\(viewModel.year)").padding()
            }.padding()
        }.clipped()
    }
}

#Preview {
    ViewDetailMovie(viewModel: .init(info: .init(adult: false, genreIds: [80,18,36], id: 466420, originalLanguage: "en", originalTitle: "Killers of the Flower Moon", overview: "When oil is discovered in 1920s Oklahoma under Osage Nation land, the Osage people are murdered one by one—until the FBI steps in to unravel the mystery.", popularity: 2057.537, posterPath: "/dB6Krk806zeqd0YNp2ngQ9zXteH.jpg", releaseDate: Date(), title: "Killers of the Flower Moon", video: false, voteAverage:  7.669, voteCount: 1338)))
}

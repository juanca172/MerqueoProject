//
//  MovieViewDetail.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 12/12/23.
//

import SwiftUI

struct ViewDetailMovie: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 10) {
                Text("Summary")
                Text("description")
                Text("Cast")
                Text("Names")
                Text("Directors")
                Text("names")
                Text("Year")
            }
        }
    }
}

#Preview {
    ViewDetailMovie()
}

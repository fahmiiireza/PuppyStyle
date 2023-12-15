//
//  NoNetworkView.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 15/12/23.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
            Text("No Network Connection")
                .font(.title)
                .foregroundColor(.red)
        })
    }
}

#Preview {
    NoNetworkView()
}

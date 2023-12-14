//
//  MapView.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 12/12/23.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
   static let parking = CLLocationCoordinate2D(latitude: 40.8522, longitude: 14.2681)
}
struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var places = PlaceList()
    @State private var searchResults: [MKMapItem] = []
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
//        position.followsUserLocation == true
        Map(position: $position){
            ForEach(places.places, id: \.self) { coordinate in
                if coordinate.city == "New York" { //We suppose to change it to user location
                    Annotation("Parking", coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)) {
                        ZStack {
                            Image(coordinate.img)
                                .resizable()
                                .frame(width: 40,height: 40)
                                .padding(5)
                            
                        }
                    }.annotationTitles(.hidden)
                }
                    

            }
            
        }
    }
}

//#Preview {
//    MapView(position: positionn)
//}

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
extension MKCoordinateRegion {
    static let napoli = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.853200, longitude: 14.278025), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
}

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var places = PlaceList()
    @State private var searchResults: [MKMapItem] = []
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedResult : Int?
    @State private var counter = 1
    var body: some View {
        Map(position: $position){
            UserAnnotation()
            ForEach(places.places, id: \.self) { coordinate in
                if coordinate.city == "Napoli" { //We suppose to change it to user location
                    Annotation("Parking", coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)) {
                        ZStack {
                            Image(coordinate.img)
                                .resizable()
                                .frame(width: 40,height: 40)
                                .padding(5)
//                                .tag(counter)
                        }
//                        .onAppear {
//                            addCounter()
//                        }
                    }
//                    .annotationTitles(.hidden)
                }
                    
                
            }
        }.task {
            await viewModel.checkIfLocationServiceIsEnabled()
        }
    }
    private func addCounter() {
        counter += 1
    }
}

//#Preview {
//    MapView(position: )
//}
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager : CLLocationManager?
    
    func checkIfLocationServiceIsEnabled() async {
        print(CLLocationManager.locationServicesEnabled())
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            checkLocationAuthorization()
        } else {
            print("We need their location")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        guard let location = locationManager.location?.coordinate else {
            return
        }
        print(locationManager.location)
        print(location)
        let geoCoder = CLGeocoder()
        let locationCity = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(locationCity, completionHandler:
            {
                placemarks, error -> Void in

                // Place details
                guard let placeMark = placemarks?.first else { return }

                // Location name
                if let locationName = placeMark.location {
//                    print(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
//                    print(street)
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    print(city)
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
//                    print(zip)
                }
                // Country
                if let country = placeMark.country {
//                    print(country)
                }
        })
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("show alert they're restricted via parental control")
        case .denied:
            print("allow it man")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

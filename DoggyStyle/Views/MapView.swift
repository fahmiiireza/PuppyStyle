//
//  MapView.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 14/12/23.
//

import SwiftUI
import MapKit
import Firebase

struct MapView: View {
    @State private var dogViewPresented = false
    @StateObject private var viewModel = MapViewModel()
    @State private var user = UserDataViewModel()
    @State var users : [Usert]
    @State private var position: MapCameraPosition = .automatic
    @Environment(\.dismiss) private var dismiss

    private let db = Firestore.firestore()
    
    var body: some View {
        Map {
            if users.isEmpty == false {
                ForEach(users, id: \.self) { user in
                    if user.location!.city == "Napoli" { //We suppose to change it to user location
                        Annotation("Test", coordinate: CLLocationCoordinate2D(latitude: user.location!.latitude, longitude: user.location!.longitude)) {
                            
                            Button {
                                dogViewPresented = true
                            } label: {
                                Image(systemName: "dog.fill")
                                    .resizable()
                                    .frame(width: 40,height: 40)
                                    .padding(5)
                            }

                                
                            
                            
                        }
                        .annotationTitles(.hidden)
                    }
                    
                    
                }
            }
            else{
//
            }
                
        }
        .fullScreenCover(isPresented: $dogViewPresented, content: {
            //Replace with actual View
            Text("StrangerDogView")
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .padding(5)
                            .background(.regularMaterial)
                            .clipShape(Circle())
                            .padding(10)
                    }
                })
                
        })
        .overlay(alignment: .topTrailing, content: {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .padding(5)
                    .background(.regularMaterial)
                    .clipShape(Circle())
                    .padding(10)
            }
        })
        
        .task {
            await viewModel.checkIfLocationServiceIsEnabled()
//            fetchUserSameCity()
        }
    }
    
//    private func fetchUserSameCity () {
//        db.collection("user").whereField("city", isEqualTo: user.currentUser?.location?.city ?? "Napoli")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    users = querySnapshot!.documents as! [Usert]
//                  
//                    
//                }
//            }
//    }
}

//#Preview {
//    MapView()
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
        print(location)
        let locationCity = CLLocation(latitude: location.latitude, longitude: location.longitude)
        getCity(latitude: location.latitude, longitude: location.longitude)
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
    
    private func getCity(latitude: Double, longitude: Double) {
        let geoCoder = CLGeocoder()
        let locationCity = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(locationCity, completionHandler:
                                            {
            placemarks, error -> Void in
            
            // Place details
            guard let placeMark = placemarks?.first else { return }
            
            // City
            if let city = placeMark.subAdministrativeArea {
                print(city)
            }
        })
        
    }
}

//
//  BreedSelectionView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 18/12/23.
//

import SwiftUI

struct BreedSelectionView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @State var buttonPressed = false
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedBreeds: [String]
    @State private var breedsNamesArray: [String] = ["African Hunting Dog", "Afghan Hound", "Affenpinscher", "Akita", "Alapaha Blue Blood Bulldog", "Alaskan Husky", "Akbash Dog", "Airedale Terrier", "Alaskan Malamute", "American Bulldog", "American Eskimo Dog", "American Bully", "American Foxhound", "American Eskimo Dog (Miniature)", "American Staffordshire Terrier", "American Pit Bull Terrier", "Anatolian Shepherd Dog", "American Water Spaniel", "Australian Cattle Dog", "Appenzeller Sennenhund", "Australian Kelpie", "Australian Shepherd", "Australian Terrier", "Azawakh", "Barbet", "Basenji", "Basset Hound", "Basset Bleu de Gascogne", "Beagle", "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian Malinois", "Belgian Tervuren", "Bichon Frise", "Bernese Mountain Dog", "Black and Tan Coonhound", "Bloodhound", "Bluetick Coonhound", "Boerboel", "Border Collie", "Border Terrier", "Bouvier des Flandres", "Boston Terrier", "Bouvier des Flandres", "Boxer", "Boykin Spaniel", "Briard", "Bracco Italiano", "Brittany", "Bull Terrier", "Bull Terrier (Miniature)", "Bullmastiff", "Cairn Terrier", "Cane Corso", "Cardigan Welsh Corgi", "Catahoula Leopard Dog", "Cavalier King Charles Spaniel", "Caucasian Shepherd (Ovcharka)", "Chinese Crested", "Chesapeake Bay Retriever", "Chinook", "Chinese Shar-Pei", "Chow Chow", "Clumber Spaniel", "Cocker Spaniel (American)", "Cocker Spaniel", "Coton de Tulear", "Dalmatian", "Dogo Argentino", "Doberman Pinscher", "Dutch Shepherd", "English Setter", "English Springer Spaniel", "English Shepherd", "English Toy Terrier", "English Toy Spaniel", "Field Spaniel", "Eurasier", "Finnish Lapphund", "Finnish Spitz", "German Pinscher", "French Bulldog", "German Shepherd Dog", "German Shorthaired Pointer", "Giant Schnauzer", "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Great Pyrenees", "Great Dane", "Griffon Bruxellois", "Greyhound", "Harrier", "Havanese", "Irish Terrier", "Irish Setter", "Italian Greyhound", "Irish Wolfhound", "Japanese Spitz", "Japanese Chin"]
    
    var body: some View {
        
        List(breedsNamesArray, id: \.self){ breedName in
            Button {
                
                if buttonPressed{
                    selectedBreeds.removeAll { $0 == breedName }
                    buttonPressed = false
                }else{
                    selectedBreeds.append(breedName)
                    buttonPressed = true
                }
            }label: {
                if selectedBreeds.contains(breedName){
                    Label(breedName, systemImage: "checkmark")
                        .foregroundStyle(.accent)
                }else{
                    Label(breedName, systemImage: "")
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                }
                
            }
        }
    }
}

#Preview {
    BreedSelectionView(selectedBreeds: .constant(["Golden Retriever"]))
}

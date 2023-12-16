//
//  TinderView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 13/12/23.
//
import SwiftUI
import SwiftData
import FirebaseAuth


struct TinderView: View {
    
    var breeds = ["Golden Retriever", "Border Collie", "Boxer"]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.displayScale) private var displayScale
    
    @State private var user: User?
    @State private var scroPos: Int? = nil
    @Query private var dogs: [Dog]
    @State private var bgImage = Image(.placeholderProfile)
    @State private var scrollPosition: Dog? = nil
    @State private var dogViewPresented = false
    @State private var selectedDog: Dog?
    
//    @MainActor func render(dog: Dog){
//        let renderer = ImageRenderer(content: TinderCardView(dog: dog))
//        print("image set")
//        let uiImage = renderer.cont
//        bgImage = Image(uiImage: uiImage ?? .placeholderDog)
//            print("image set")
//        }
    
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                GeometryReader{ geometry in
                    
                    //                Image(.affenpinscher) // Replace with your actual image
                    //                    .resizable()
                    //                    .aspectRatio(contentMode: .fill)
                    //                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    //                    .overlay(VisualEffectBlur(blurStyle: .systemThinMaterialDark)) // You can change the blur style
                    
                    TinderCardView( dog: (scrollPosition ?? dogs.first) ?? Dog(imageNames: ["String"], name: "Nalu", gender: "", breed: "", age: "12", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: 50)
                        .ignoresSafeArea()
                        .scaleEffect(2)
                    ScrollViewReader{ proxy in
                    ScrollView(.horizontal) {
                        LazyHStack{
                            ForEach(dogs, id: \.self){ dog in
                                VStack(alignment: .leading, spacing: 0){
                                        Text(dog.name)
                                        .foregroundStyle(.white)
                                        .font(.title)
                                        .bold()
                                        .padding(.horizontal, 5)
                                    
                                    Button {
                                        selectedDog = dog
                                        dogViewPresented = true
                                    } label: {
                                        TinderCardView(dog: dog)
                                    }

                                
                                    Text(breeds.joined(separator: " ‧ "))
                                        .foregroundStyle(.white.opacity(0.8))
                                        .font(.headline)
                                        .padding(5)
                                    }
                                    .scrollTransition { content, phase in
                                        content.offset(y: phase.isIdentity ? 0.0 : 20)
                                            .opacity(phase.isIdentity ? 1 : 0.8)
                                        
                                    }
                                
                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 5)
                                
                            }
                        }
                        .scrollTargetLayout()
                       
                    }
                    
                    
                    //.contentMargins(16, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .toolbar{
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .padding(5)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                                    .padding(10)
                        }
                    }
                        
                    }
                    .scrollPosition(id: $scrollPosition)
                    .fullScreenCover(isPresented: $dogViewPresented, content: {
                        StrangerDogView(user: $user, dog: selectedDog ?? Dog(imageNames: ["String"], name: "Nalu", gender: "", breed: "", age: "12", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
                    })
                    }
                }
            }
        }
    }
}

#Preview {
    TinderView()
}


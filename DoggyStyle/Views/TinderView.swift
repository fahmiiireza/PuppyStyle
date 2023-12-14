//
//  TinderView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 13/12/23.
//

import UIKit
import SwiftUI
import SwiftData

struct TinderView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(BackgroundLogic.self) private var backgroundLogic
    @Query private var dogs: [Dog]
    @State private var backgroundColor = UIColor(.clear)
    
    var body: some View {
        
        ZStack{
            GeometryReader{ geometry in
                
            //                Image(.affenpinscher) // Replace with your actual image
            //                    .resizable()
            //                    .aspectRatio(contentMode: .fill)
            //                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            //                    .overlay(VisualEffectBlur(blurStyle: .systemThinMaterialDark)) // You can change the blur style
            
                backgroundLogic.backgroundImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .blur(radius: 15)
                .ignoresSafeArea()
                .scaleEffect(2)
            
            ScrollView(.horizontal) {
                LazyHStack{
                    ForEach(dogs){ dog in
                        TinderCardView(dog: dog)
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
            .overlay {
                VStack{
                    HStack{
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .padding()
                        }
                        
                        
                    }
                    Spacer()
                }
            }
        }
    }
        }
}

#Preview {
    TinderView()
        .environment(BackgroundLogic())
}




extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var averageColor: UIColor? {
        // convert our image to a Core Image Image
        guard let inputImage = CIImage(image: self) else { return nil }

        // Create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
        guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert our bitmap images of r, g, b, a to a UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

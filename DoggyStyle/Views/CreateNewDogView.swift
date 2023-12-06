//
//  CreateNewDogView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct CreateNewDogView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            
            Text("Create New Dog Here")
                .toolbar(content: {
                    
                    ToolbarItem(placement: .cancellationAction) {
                        
                        Button("Cancel") {
                            dismiss.callAsFunction()
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {}, label: {
                            Text("Done")
                                .bold()
                        })
                    }
                })
        }
        
        
    }
}

#Preview {
    CreateNewDogView()
}

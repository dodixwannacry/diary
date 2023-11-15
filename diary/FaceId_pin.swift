//
//  FaceId_pin.swift
//  diary
//
//  Created by Rodolfo Falanga on 15/11/23.
//

import SwiftUI
import LocalAuthentication

struct FaceId_pin: View {
    @State private var unlocked = false
    @State private var text = "Diary locked"
    
    // setting a state variable to define if the view is dislayed or not
    @State private var isContentViewPresented: Bool = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is for security reason"   ) {
                success, authenticationError in
                
                if success {
                    text = "Unlocked"
                } else{
                    text = "There was a problem!"
                }
                
                // setting the isContentViewPresented to the value of sucess
                isContentViewPresented = success
            }
        } else {
            text = "Phone has not biometrics"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(text)
                    .bold()
                    .padding()
                
                Button("Authenticate") {
                    // using authenticate function to set the isContentViewPresented variable to true or false depending on the FaceID authentication success
                    
                    authenticate()
                    
                }.navigationDestination(isPresented: $isContentViewPresented) {
                    ContentView()
                }
                
                Image(systemName: "faceid")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
        }
    }
}
    #Preview {
        FaceId_pin()
    }


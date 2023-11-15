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
    var body: some View {
        VStack {
            Text(text)
                .bold()
                .padding()
            
            Button("Authenticate"){
                authenticate()
                
            }
            Image(systemName: "faceid")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
    }
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is for security reason"   ){success, authenticationError in
                
                if success {
                    text = "Unlocked"
                } else{
                    text = "There was a problem!"
                }
            }
        } else {
            text = "Phone has not biometrics"
        }
    }
}
    #Preview {
        FaceId_pin()
    }

//
//  FaceId_pin.swift
//  diary
//
//  Created by Rodolfo Falanga on 15/11/23.
//

import SwiftUI
import LocalAuthentication
import Combine

struct FaceId_pin: View {
    @State private var pin = ""
    let TextLimit = 4
    @State private var wrongPin = 0
    @State private var showloginscreen = false
    @State private var unlocked = false
    @State private var text = ""
    
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
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            pin = String(pin.prefix(upper))
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.bg.ignoresSafeArea()
                VStack {
                    Text("Type in your password")
                        .foregroundColor(.GHG)
                        .bold()
                    SecureField("", text: $pin)
                        .onReceive(Just(pin)) { _ in limitText(TextLimit) }
                        .padding()
                        .frame(width:80,height: 30)
                        .border(.red, width:CGFloat(wrongPin))
                    Text(text)
                        .foregroundColor(.GHG)
                        .bold()
                        .padding()
                    
                    Button("Authenticate") {
                        // using authenticate function to set the isContentViewPresented variable to true or false depending on the FaceID authentication success
                        
                        authenticate()
                        
                    }.foregroundColor(.GHG).navigationDestination(isPresented: $isContentViewPresented) {
                        ContentView()
                    }

                    Image(systemName: "faceid")
                        .imageScale(.large)
                        .foregroundColor(.GHG)
                }
            }
        }
    }
}
    #Preview {
        FaceId_pin()
    }


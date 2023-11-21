//
//  Pin.swift
//  diary
//
//  Created by Rodolfo Falanga on 20/11/23.
//

import SwiftUI
import LocalAuthentication


struct Pin : View {
    @State private var pin = ""
    @State private var wrongPin = 0
    @State private var showloginscreen = false
    @State private var text = ""
    @State private var isContentViewPresented: Bool = false
    @State var isContentViewPresented2 : Bool = false
    @State var unLocked = false
    
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is for security reason"   ) {
                success, authenticationError in
                
                if success {
                    text = ""
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
    func presentContentViewIfUnlocked() {
        if unLocked {
            isContentViewPresented2 = true
        }
    }
    var body: some View{
        NavigationStack{
            ZStack{
                Color.bg.ignoresSafeArea()
                VStack{
                    Text(text)
                        .foregroundColor(.GHG)
                        .bold()
                        .padding()
                    
                    Button("", systemImage: "faceid") {
                        // using authenticate function to set the isContentViewPresented variable to true or false depending on the FaceID authentication success
                        
                        authenticate()
                        
                    }.foregroundColor(.GHG).navigationDestination(isPresented: $isContentViewPresented) {
                        ContentView()
                    }
                    // Lockscreen...
                    
                    if unLocked{
                       
                        Text("")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .onAppear {
                    // Call your function or update state here
                        presentContentViewIfUnlocked()
                                }
                    }
                    else{
                        
                        LockScreen(unLocked: $unLocked)
                    }
                }
            }.navigationDestination(isPresented: $isContentViewPresented2) {
                ContentView()
            }
        }
    }
}


struct LockScreen : View {
    
    @State var password = ""
    // you can change it when user clicks reset password....
    // AppStorage => UserDefaults....
    @AppStorage("lock_Password") var key = "2003"
    @Binding var unLocked : Bool
    @State var wrongPassword = false
    let height = UIScreen.main.bounds.width
    
    var body: some View{
        
        VStack{
            
            HStack{
                
                Spacer(minLength: 0)
                
                Menu(content: {
                    
                    Label(
                        title: { Text("Help") },
                        icon: { Image(systemName: "info.circle.fill") })
                        .onTapGesture(perform: {
                            // perform actions...
                        })
                    
                    Label(
                        title: { Text("Reset Password") },
                        icon: { Image(systemName: "key.fill") })
                        .onTapGesture(perform: {
                            
                        })
                    
                }) {
                    
                    Image("menu")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 19, height: 19)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .padding(.leading)
            
            Text("Type in your password")
                .font(.system(size:14))
                .foregroundColor(.GHG)
                .fontWeight(.bold)
            
            HStack(spacing: 20){
               
                // Password Circle View...
                
                ForEach(0..<4,id: \.self){index in
                    
                    PasswordView(index: index, password: $password)
                }
             
            }
            // for smaller size iphones...
            .padding(.top,height < 750 ? 20 : 30)
            
            // KeyPad....

            
            Text(wrongPassword ? "Incorrect Pin" : "")
                .foregroundColor(.red)
                .fontWeight(.heavy)
            
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3),spacing: height < 750 ? 5 : 15){
                    
                    // Password Button ....
                    
                    ForEach(1...9,id: \.self){value in
                        PasswordButton(value: "\(value)",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword)
                    }
                    
                    PasswordButton(value: "", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword)
                    
                    PasswordButton(value: "0", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword)
                    
                    PasswordButton(value: "delete.fill",password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword)
                    Spacer(minLength: 170)
                }
                .padding(.horizontal, 55)
            
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct PasswordView : View {
    
    var index : Int
    @Binding var password : String
    
    var body: some View{
        
        ZStack{
            
            Circle()
                .stroke(Color.bg,lineWidth: 2)
                .frame(width: 30, height: 30)
            
            // checking whether it is typed...
            
            if password.count > index{
                
                Circle()
                    .fill(Color.GHG)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct PasswordButton : View {
    
    var value : String
    @Binding var password : String
    @Binding var key : String
    @Binding var unlocked : Bool
    @Binding var wrongPass : Bool
    
    var body: some View{
        
        Button(action: setPassword, label: {
            
            VStack{
                
                if value.count > 1{
                    
                    // Image...
                     
                    Image(systemName: "delete.left")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.GHG)
                        
                }
                else{
                    
                    Text(value)
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .foregroundColor(.GHG)
                    
                }
            }
            .padding()
            .padding()

        })
    }
    
    func setPassword(){
        
        // checking if backspace pressed...
        
        withAnimation{
            
            if value.count > 1{
                
                if password.count != 0{
                    
                    password.removeLast()
                }
            }
            else{
                
                if password.count != 4{
                    
                    password.append(value)
                    
                    // Delay Animation...
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        
                        withAnimation{
                            
                            if password.count == 4{
                                
                                if password == key{
                                    
                                    unlocked = true
                                }
                                else{
                                    
                                    wrongPass = true
                                    password.removeAll()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Pin()
}

//
//  ContentView.swift
//  diary
//
//  Created by Rodolfo Falanga on 21/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var date = Date()
    @State private var index = 0
    var body: some View {
        
        ZStack {
            TabView(selection: $index){
                
                Text("")
                    .tabItem {
                        Image(systemName: "house");  Text("")
                        Text("11")
                            .font(.system(size:1))
                            .fontWeight(.bold)

                        
                    }.tag(0)
                
                Text("")
                    .tabItem {
                        Image(systemName: "calendar");  Text("")
                        Text(index == 1 ? "": "2023")
                     
                        
                    }
                
                Text("")
                    .tabItem { Image(systemName: "plus");  Text("")
                       
                        
                    }
                
                Text("")
                
                    .tabItem { Image(systemName: "magnifyingglass")
                            .scaleEffect(x: -1, y: 1)
                        
                    }
                
                Text("")
                    .tabItem { Image(systemName: "line.3.horizontal");
                        
                }
            }
        }
    }
}

#Preview {
    ContentView()
}


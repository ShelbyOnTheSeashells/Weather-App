//
//  CloudTransition.swift
//  WeatherProto
//
//  Created by Lexi Singson on 5/5/25.
//

import SwiftUI

struct CloudTransition: View {
    @State var clouds = true
    @State var size : CGSize = .zero
    var body: some View {
        VStack {
            ZStack {
                
                
                Image("BigCloudLeft")
                    .position(x: clouds ? 0 : -400, y: 700)
                Image("BigCloudRight")
                    .position(x: clouds ? 400 : 800, y: 700)
                Image("BigCloudLeft")
                    .position(x: clouds ? -50 : -490, y: 600)
                Image("BigCloudRight")
                    .position(x: clouds ? 300 : 800, y: 600)
                
                Image("BigCloudLeft")
                    .position(x: clouds ? 0 : -400, y: 500)
                Image("BigCloudRight")
                    .position(x: clouds ? 400 : 800, y: 500)
                Image("BigCloudLeft")
                    .position(x: clouds ? -50 : -490, y:    400)
                Image("BigCloudRight")
                    .position(x: clouds ? 300 : 800, y: 400)
                Image("BigCloudLeft")
                    .position(x: clouds ? 0 : -400, y: 200)
                Image("BigCloudRight")
                    .position(x: clouds ? 400 : 800, y: 150)
                Image("BigCloudLeft")
                    .position(x: clouds ? -50 : -490, y:    90)
                Image("BigCloudRight")
                    .position(x: clouds ? 300 : 800, y: 30)
                Image("BigCloudLeft")
                    .position(x: clouds ? 0 : -440, y:    0)
                
            }
            GeometryReader { geometry in
                VStack {
                    
                }.onAppear {
                    size = geometry.size

                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                clouds.toggle()
            }
            print("I'M HERE!!!")
        }
    }
    
}

#Preview {
    CloudTransition()
        .background(.purple)
    
}

//
//  LoadingView.swift
//  WeatherProto
//
//  Created by Lexi Singson on 4/29/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView() {
            
        }
        .progressViewStyle(CircularProgressViewStyle.init(tint: .sunnyGradient2))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

#Preview {
    LoadingView()
}

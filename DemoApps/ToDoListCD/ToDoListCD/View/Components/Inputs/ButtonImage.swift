//
//  ButtonImage.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct ButtonImage: View {
    var image : String
    var bgColor : String
    var body: some View {
        Image(systemName: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipped()
            .frame(width: 20, height: 20)
            .padding(15)
            .foregroundColor(Color("Typograghy"))
            .background(Color(bgColor))
            .cornerRadius(15)
            .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 2)
    }
}

struct ButtonImage_Previews: PreviewProvider {
    static var previews: some View {
        ButtonImage(image: "slider.horizontal.3", bgColor: "Accent")
    }
}

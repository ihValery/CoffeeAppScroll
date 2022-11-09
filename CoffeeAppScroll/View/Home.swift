//
//  Home.swift
//  CoffeeAppScroll
//
//  Created by Валерий Игнатьев on 9.11.22.
//

import SwiftUI

//MARK: - Home

struct Home: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            //Since Card Size is the size of the Screen Width
            //Since Card Size is the size of the Screen Width
            let cardSize = size.width
            
            VStack {
                ForEach(coffees) { coffee in
                    CoffeView(coffee: coffee, size: size)
                }
            }
            .frame(width: size.width)
            .padding(.top, size.height - cardSize)
        }
        .preferredColorScheme(.light)
    }
}

//MARK: - PreviewProvider

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: - Coffee View

struct CoffeView: View {
    
    var coffee: Coffee
    var size: CGSize
    
    //MARK: Body

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Image(coffee.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
        }
        .frame(height: size.width)
    }
}


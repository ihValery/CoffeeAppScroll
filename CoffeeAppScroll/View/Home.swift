//
//  Home.swift
//  CoffeeAppScroll
//
//  Created by Валерий Игнатьев on 9.11.22.
//

import SwiftUI

//MARK: - Home

struct Home: View {
    
    //MARK: Properties
    
    @State private var offsetY: CGFloat = .zero
    @State private var currentIndex: CGFloat = .zero
    
    //MARK: Body
    
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
            .offset(y: offsetY)
            .offset(y: -currentIndex * cardSize)
        }
        .coordinateSpace(name: "SCROLL")
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    //Slowing down the gesture
                    //Замедление жеста
                    offsetY = value.translation.height * 0.4
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    
                    withAnimation(.easeInOut) {
                        if translation > 0 {
                            //250 Update it for your own useage
                            //Обновите его для собственного использования
                            if currentIndex > 0 && translation > 250 {
                                currentIndex -= 1
                            }
                        } else {
                            if currentIndex < CGFloat(coffees.count - 1) && -translation > 250 {
                                currentIndex += 1
                            }
                        }
                        
                        offsetY = .zero
                    }
                })
        )
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
        let cardSize = size.width
        //Since i want to show max card on the display
        let maxCarsdDisplaySize = size.width * 3
        
        GeometryReader { proxy in
            let _size = proxy.size
            //Scalling animation
            //CurrentCardOffset
            let offset = proxy.frame(in: .named("SCROLL")).minY - (size.height - cardSize)
            let scale = offset <= 0 ? (offset / maxCarsdDisplaySize) : 0
            let reduceScale = 1 + scale
            let currentCardScale = offset / cardSize
            
            Image(coffee.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: _size.width, height: _size.height)
                //To avoid warning
                //Updating anchor based on the current card scale
                .scaleEffect(reduceScale < 0 ? 0.001 : reduceScale,
                             anchor: .init(x: 0.5, y: 1 - (currentCardScale / 2.4)))
            
            
            Text("\(offset)")
        }
        .frame(height: size.width)
    }
}


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
            
            //Gradient Background
            LinearGradient(colors: [.clear,
                                    Color("Brown").opacity(0.2),
                                    Color("Brown").opacity(0.45),
                                    Color("Brown")],
                           startPoint: .top, endPoint: .bottom)
//            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            
            HeaderText()
            
            VStack(spacing: 0) {
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
    
    @ViewBuilder func HeaderText() -> some View {
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: 0) {
                ForEach(coffees) { coffee in
                    VStack(spacing: 15) {
                        Text(coffee.title)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        
                        Text(coffee.price)
                            .font(.title)
                    }
                    .frame(width: size.width)
                }
            }
            .offset(x: currentIndex * -size.width)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8),
                       value: currentIndex)
        }
        .padding(15)
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
        //If you want to decrease the size of the image, then change it's card size
        //Если вы хотите уменьшить размер изображения, измените размер карты.
        let cardSize = size.width * 1
        //Since i want to show max card on the display
        //Since we used scalling to decrease the view size add extra on
        //Так как мы использовали скаллинг для уменьшения размера вида, добавьте еще по
        let maxCarsdDisplaySize = size.width * 4
        
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
            //When it's coming from bottom animation the scale from large to actual
            //Когда он идет от нижней анимации, масштаб от большого к реальному
                .scaleEffect(offset > 0 ? 1 + currentCardScale : 1, anchor: .top)
            //To remove the excess next view using offset to move the view in real time
            //Для удаления лишнего следующего вида с использованием смещения для перемещения вида в реальном времени
                .offset(y: offset > 0 ? currentCardScale * 200 : 0)
            //Making it more compact
                .offset(y: currentCardScale * -130)
        }
        .frame(height: cardSize)
    }
}


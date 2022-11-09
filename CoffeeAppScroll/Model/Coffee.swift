//
//  Coffee.swift
//  CoffeeAppScroll
//
//  Created by Валерий Игнатьев on 9.11.22.
//

import SwiftUI

//MARK: - Coffee

struct Coffee: Identifiable{
    
    var id: UUID = .init()
    var imageName: String
    var title: String
    var price: String
}

var coffees: [Coffee] = [
    .init(imageName: "CoffeeImage1", title: "Caramel\nCold Drink", price: "$3.90"),
    .init(imageName: "CoffeeImage2", title: "Caramel\nMacchiato", price: "$2.30"),
    .init(imageName: "CoffeeImage3", title: "Iced Coffee\nMocha", price: "$3.45"),
    .init(imageName: "CoffeeImage4", title: "Black Tea\nLatte", price: "$2.99"),
    .init(imageName: "CoffeeImage5", title: "Styled Cold\nCoffee", price: "$1.90"),
    .init(imageName: "CoffeeImage6", title: "Classic Irish\nCoffee", price: "$2.30")
]

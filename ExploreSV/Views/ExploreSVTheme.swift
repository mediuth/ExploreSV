//
//  ExploreSVTheme.swift
//  ExploreSV
//
//  Created by Wilson on 15/11/26.
//


import SwiftUI

enum ExploreSVTheme {

    static let verde = Color(
        red: 0.08,
        green: 0.48,
        blue: 0.35
    )

    static let verdeClaro = Color(
        red: 0.87,
        green: 0.95,
        blue: 0.90
    )

    static let azul = Color(
        red: 0.12,
        green: 0.43,
        blue: 0.76
    )

    static func colorCategoria(_ categoria: String) -> Color {
        switch categoria {
        case "Naturaleza":
            return .green
        case "Aventura":
            return .orange
        case "Playa":
            return .cyan
        case "Cultura":
            return .purple
        default:
            return verde
        }
    }

    static func iconoCategoria(_ categoria: String) -> String {
        switch categoria {
        case "Naturaleza":
            return "leaf.fill"
        case "Aventura":
            return "figure.hiking"
        case "Playa":
            return "water.waves"
        case "Cultura":
            return "building.columns.fill"
        default:
            return "mappin"
        }
    }
}


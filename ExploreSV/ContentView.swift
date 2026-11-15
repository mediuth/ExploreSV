//
//  ContentView.swift
//  ExploreSV
//
//  Created by Wilson on 14/11/26.
//



import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = MapViewModel()
    
    @State private var pestañaSeleccionada = 0

    var body: some View {

        TabView(selection: $pestañaSeleccionada) {

            NavigationStack {
                TouristMapView(viewModel: viewModel)
            }
            .tabItem {
                Label("Explorar", systemImage: "map")
            }
            .tag(0)

            FavoritesView(
                viewModel: viewModel,
                pestañaSeleccionada: $pestañaSeleccionada
            )
                .tabItem {
                    Label("Favoritos", systemImage: "heart.fill")
                }
                .tag(1)
        }
        .tint(ExploreSVTheme.verde)
        .task {
            await viewModel.cargarLugares()
        }
    }
}

#Preview {
    ContentView()
}





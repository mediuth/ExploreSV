//
//  PlaceDetailView.swift
//  ExploreSV
//
//  Created by Wilson on 14/11/26.
//


import SwiftUI

struct PlaceDetailView: View {

    let lugar: TouristPlace

    @ObservedObject var viewModel: MapViewModel
    
    var alSolicitarRuta: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 22) {

                    // Encabezado visual
                    ZStack {

                        RoundedRectangle(cornerRadius: 22)
                            .fill(
                                ExploreSVTheme.colorCategoria(
                                    lugar.categoria
                                )
                                .gradient
                            )

                        VStack(spacing: 12) {

                            Image(
                                systemName:
                                    ExploreSVTheme.iconoCategoria(
                                        lugar.categoria
                                    )
                            )
                            .font(.system(size: 65))
                            .foregroundStyle(.white)

                            Text(lugar.categoria)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 170)

                    // Nombre
                    Text(lugar.nombre)
                        .font(.largeTitle.bold())

                    // Departamento
                    Label(
                        lugar.departamento,
                        systemImage: "mappin.and.ellipse"
                    )
                    .foregroundStyle(.secondary)

                    Divider()

                    // Descripción
                    VStack(alignment: .leading, spacing: 10) {

                        Text("Descubrí este destino")
                            .font(.title3.bold())

                        Text(lugar.descripcion)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    // Coordenadas
                    VStack(alignment: .leading, spacing: 8) {

                        Text("Ubicación geográfica")
                            .font(.headline)

                        Label(
                            "\(lugar.latitud), \(lugar.longitud)",
                            systemImage: "location.circle"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Color.gray.opacity(0.09)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )

                    // Calcular ruta
                    Button {
                        dismiss()

                        alSolicitarRuta?()

                        Task {
                            await viewModel.calcularRuta(hacia: lugar)
                        }
                    } label: {

                        Label(
                            "Cómo llegar",
                            systemImage: "car.fill"
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(ExploreSVTheme.verde)

                    // Favoritos
                    Button {
                        viewModel.alternarFavorito(lugar)
                    } label: {

                        Label(
                            viewModel.esFavorito(lugar)
                                ? "Quitar de favoritos"
                                : "Agregar a favoritos",
                            systemImage:
                                viewModel.esFavorito(lugar)
                                ? "heart.fill"
                                : "heart"
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)

                }
                .padding()
            }
            .navigationTitle("Explorar destino")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}




//
//  MyReservationsView.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import SwiftUI

struct MyReservationsView: View {
    @ObservedObject var viewModel: CalendarViewModel

    @State private var reservationToDelete: Reservation?
    @State private var showDeleteConfirmation = false
    @State private var showSuccessMessage = false

    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.reservations) { reservation in
                    VStack(alignment: .leading) {
                        Text(reservation.description)
                            .font(.headline)
                        Text("\(reservation.room.name) — \(formatted(reservation.startTime))")
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            reservationToDelete = reservation
                            showDeleteConfirmation = true
                        } label: {
                            Label("Excluir", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Minhas Reservas")
            .onAppear {
                viewModel.loadReservations()
            }

            if showSuccessMessage {
                VStack {
                    Spacer()
                    Text("Reserva excluída com sucesso")
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: showSuccessMessage)
                }
            }
        }
        .alert("Deseja excluir esta reserva?", isPresented: $showDeleteConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Excluir", role: .destructive) {
                if let reservation = reservationToDelete {
                    viewModel.deleteReservation(reservation)
                    showSuccessMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSuccessMessage = false
                    }
                }
            }
        } message: {
            Text("Essa ação não pode ser desfeita.")
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

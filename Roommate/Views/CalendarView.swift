//
//  CalendarView.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Olá, bem-vindo 👋")
                    .font(.title2)
                    .bold()
                Text("Hoje é \(formattedFullDate(Date()))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
            .animation(.easeOut(duration: 0.6), value: animate)
            List {
                let upcomingReservations = viewModel.reservations.filter {
                    $0.startTime > Date()
                }
                
                if upcomingReservations.isEmpty {
                    Text("Nenhuma reserva futura encontrada.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(upcomingReservations) { reservation in
                        VStack(alignment: .leading) {
                            Text("Sala: \(reservation.room.name)")
                                .font(.headline)
                            Text(reservation.description)
                            Text("\(formatted(reservation.startTime)) - \(formatted(reservation.endTime))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 10)
                        .animation(.easeOut(duration: 0.5).delay(0.2), value: animate)
                    }
                }
            }
            .navigationTitle("Reservas")
            .toolbar {
                NavigationLink("Nova Reserva") {
                    ReservationFormView(
                        viewModel: ReservationFormViewModel(service: viewModel.service)
                    )
                }
            }
            .onAppear {
                viewModel.loadReservations()
                animate = true
            }
        }
    }
    
    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

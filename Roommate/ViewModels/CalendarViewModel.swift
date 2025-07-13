//
//  CalendarViewModel.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []

    let service: ReservationServiceProtocol

    init(service: ReservationServiceProtocol) {
        self.service = service
        loadReservations()
    }

    func loadReservations() {
        reservations = service.getReservations()
    }
    
    func deleteReservation(_ reservation: Reservation) {
        do {
            try service.removeReservation(reservation)
            loadReservations()
        } catch {
            print("Erro ao excluir reserva")
        }
    }

}

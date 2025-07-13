//
//  ReservationFormViewModel.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import Foundation

class ReservationFormViewModel: ObservableObject {
    @Published var selectedRoom: Room?
    @Published var selectedDate = Date()
    @Published var selectedSlot: Date?
    @Published var description = ""
    @Published var error: String?
    @Published var availableRooms: [Room] = []
    @Published var allSlots: [Date] = []
    @Published var reservedSlots: [Date] = []
    @Published var didSubmit = false

    let service: ReservationServiceProtocol

    init(service: ReservationServiceProtocol) {
        self.service = service
        self.availableRooms = service.getAvailableRooms()
        self.loadSlots()
    }

    func loadSlots() {
        guard let room = selectedRoom else {
            allSlots = []
            reservedSlots = []
            return
        }

        let calendar = Calendar.current
        let all = generateHourlySlots(for: selectedDate)
        let reservations = service.getReservations()

        let reserved = reservations.compactMap { res -> Date? in
            guard res.room == room,
                  calendar.isDate(res.startTime, inSameDayAs: selectedDate)
            else { return nil }
            return calendar.date(bySettingHour: calendar.component(.hour, from: res.startTime), minute: 0, second: 0, of: selectedDate)
        }

        self.allSlots = all
        self.reservedSlots = reserved
    }

    func submit() {
        guard let room = selectedRoom else {
            error = "Selecione uma sala"
            return
        }

        guard let startTime = selectedSlot else {
            error = "Selecione um horário"
            return
        }

        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!

        let reservation = Reservation(
            id: UUID(),
            room: room,
            startTime: startTime,
            endTime: endTime,
            description: description
        )

        do {
            try service.addReservation(reservation)
            self.error = nil
            self.didSubmit = true
        } catch {
            self.error = "Horário indisponível"
        }
    }

    private func generateHourlySlots(for date: Date) -> [Date] {
        var slots: [Date] = []
        let calendar = Calendar.current

        for hour in 8...17 {
            if let slot = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) {
                slots.append(slot)
            }
        }

        return slots
    }

    func formatHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}


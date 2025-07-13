//
//  Reservation.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import Foundation

struct Reservation: Identifiable, Equatable {
    let id: UUID
    let room: Room
    let startTime: Date
    let endTime: Date
    let description: String
}

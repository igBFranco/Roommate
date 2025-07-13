//
//  ReservationFormView.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import SwiftUI

struct ReservationFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ReservationFormViewModel

    var body: some View {
        Form {
            Section("Sala") {
                Picker("Sala", selection: $viewModel.selectedRoom) {
                    ForEach(viewModel.availableRooms, id: \.self) { room in
                        Text(room.name).tag(Optional(room))
                    }
                }
            }

            Section("Data") {
                DatePicker("Data", selection: $viewModel.selectedDate, displayedComponents: .date)
            }

            Section("Horário") {
                ForEach(viewModel.allSlots, id: \.self) { slot in
                    HourSlotView(
                        slot: slot,
                        isSelected: viewModel.selectedSlot == slot,
                        isDisabled: viewModel.reservedSlots.contains(slot),
                        onSelect: {
                            viewModel.selectedSlot = slot
                        },
                        formatter: viewModel.formatHour
                    )
                }
            }

            Section("Descrição") {
                TextField("Descrição", text: $viewModel.description)
            }

            if let error = viewModel.error {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                }
            }

            Section {
                Button("Reservar") {
                    viewModel.submit()
                }
            }
        }
        .navigationTitle("Nova Reserva")
        .onChange(of: viewModel.didSubmit) { _, newValue in
            if newValue {
                dismiss()
            }
        }
        .onChange(of: viewModel.selectedDate) { _ in
            viewModel.loadSlots()
        }
        .onChange(of: viewModel.selectedRoom) { _ in
            viewModel.loadSlots()
        }
    }
}

struct HourSlotView: View {
    let slot: Date
    let isSelected: Bool
    let isDisabled: Bool
    let onSelect: () -> Void
    let formatter: (Date) -> String

    var body: some View {
        Button(action: {
            if !isDisabled {
                onSelect()
            }
        }) {
            HStack {
                Text(formatter(slot))
                    .foregroundColor(isDisabled ? .gray : .primary)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .disabled(isDisabled)
    }
}

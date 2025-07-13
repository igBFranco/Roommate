//
//  AddRoomView.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 08/07/25.
//

import SwiftUI

struct AddRoomView: View {
    @State private var roomName = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @ObservedObject var viewModel: AddRoomViewModel

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Cadastrar Nova Sala")) {
                        TextField("Nome da sala", text: $roomName)
                        Button("Salvar") {
                            addRoom()
                        }
                    }

                    Section(header: Text("Salas Cadastradas")) {
                        if viewModel.rooms.isEmpty {
                            Text("Nenhuma sala cadastrada ainda.")
                                .foregroundColor(.gray)
                        } else {
                            List {
                                ForEach(viewModel.rooms, id: \.id) { room in
                                    Text(room.name)
                                }
                                .onDelete(perform: deleteRoom)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Gerenciar Salas")
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            .onAppear {
                viewModel.fetchRooms()
            }
        }
    }

    private func addRoom() {
        let trimmed = roomName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            alertMessage = "Informe o nome da sala."
            showAlert = true
            return
        }

        do {
            try viewModel.addRoom(name: trimmed)
            roomName = ""
            alertMessage = "Sala criada com sucesso!"
            showAlert = true
        } catch {
            alertMessage = "Erro ao salvar sala."
            showAlert = true
        }
    }

    private func deleteRoom(at offsets: IndexSet) {
        for index in offsets {
            let room = viewModel.rooms[index]
            viewModel.deleteRoom(room)
        }
    }
}

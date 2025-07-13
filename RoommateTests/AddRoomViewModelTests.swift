//
//  AddRoomViewModelTests.swift
//  RoommateTests
//
//  Created by Igor Bueno Franco on 13/07/25.
//
import XCTest
import CoreData
@testable import Roommate

final class AddRoomViewModelTests: XCTestCase {
    
    var viewModel: AddRoomViewModel!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        context = PersistenceController(inMemory: true).container.viewContext
        viewModel = AddRoomViewModel(context: context)
    }

    override func tearDown() {
        viewModel = nil
        context = nil
        super.tearDown()
    }

    // TESTE 3: Garante que uma nova sala pode ser adicionada com sucesso.
    func testAddRoom_WithValidName_ShouldUpdateRoomsList() throws {
        let initialCount = viewModel.rooms.count
        let roomName = "Sala de Teste Alpha"

        try viewModel.addRoom(name: roomName)

        XCTAssertEqual(viewModel.rooms.count, initialCount + 1, "A contagem de salas deveria aumentar em 1")
        XCTAssertTrue(viewModel.rooms.contains(where: { $0.name == roomName }), "A nova sala não foi encontrada na lista")
    }

    // TESTE 4: Garante que uma sala sem reservas pode ser deletada.
    func testDeleteRoom_WithoutReservations_ShouldBeRemoved() throws {
        let roomName = "Sala para Deletar"
        try viewModel.addRoom(name: roomName)
        guard let roomToDelete = viewModel.rooms.first(where: { $0.name == roomName }) else {
            XCTFail("Falha ao criar a sala para o teste de exclusão")
            return
        }

        let errorMessage = viewModel.deleteRoom(roomToDelete)

        XCTAssertNil(errorMessage, "Não deveria haver mensagem de erro ao deletar uma sala vazia")
        XCTAssertFalse(viewModel.rooms.contains(where: { $0.id == roomToDelete.id }), "A sala ainda existe após a exclusão")
    }
}

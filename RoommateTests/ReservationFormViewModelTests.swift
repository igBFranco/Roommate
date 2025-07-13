//
//  ReservationFormViewModelTests.swift
//  RoommateTests
//
//  Created by Igor Bueno Franco on 13/07/25.
//

import XCTest
@testable import Roommate

final class ReservationFormViewModelTests: XCTestCase {

    var viewModel: ReservationFormViewModel!
    var mockService: MockReservationService!

    override func setUp() {
        super.setUp()
        mockService = MockReservationService()
        viewModel = ReservationFormViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    // TESTE 1: Garante que a submissão funciona com dados válidos.
    func testSubmit_WithValidData_ShouldSucceed() {
        viewModel.selectedRoom = mockService.getAvailableRooms().first!
        viewModel.selectedSlot = Date()
        viewModel.description = "Reunião de Teste"

        viewModel.submit()

        XCTAssertTrue(viewModel.didSubmit, "didSubmit deveria ser true após submissão bem-sucedida")
        XCTAssertNil(viewModel.error, "O erro deveria ser nulo")
        XCTAssertEqual(mockService.reservations.count, 1, "Deveria haver uma reserva no serviço")
    }

    // TESTE 2: Garante que a submissão falha quando uma sala não é selecionada.
    func testSubmit_WithoutSelectedRoom_ShouldFail() {
        viewModel.selectedRoom = nil
        viewModel.selectedSlot = Date()

        viewModel.submit()

        XCTAssertFalse(viewModel.didSubmit, "didSubmit deveria ser false")
        XCTAssertNotNil(viewModel.error, "Deveria haver uma mensagem de erro")
        XCTAssertEqual(viewModel.error, "Selecione uma sala", "A mensagem de erro está incorreta")
        XCTAssertTrue(mockService.reservations.isEmpty, "Nenhuma reserva deveria ter sido criada")
    }
}

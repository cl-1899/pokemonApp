//
//  PokemonModulePresenterTests.swift
//  pokemonAppTests
//
//  Created by Andrei Martynenka on 25.09.23.
//

import XCTest
@testable import pokemonApp

final class PokemonModulePresenterTests: XCTestCase {

    var presenter: PokemonModulePresenter!
    var mockInteractor: MockPokemonModuleInteractor!
    var mockView: MockPokemonModuleView!

    override func setUpWithError() throws {
        mockInteractor = MockPokemonModuleInteractor()
        mockView = MockPokemonModuleView()
        presenter = PokemonModulePresenter(pokemonId: 5)
        presenter.interactor = mockInteractor
        presenter.view = mockView
    }
    
    override func tearDownWithError() throws {
        mockInteractor = nil
        mockView = nil
        presenter = nil
    }

    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.fetchPokemonDetailsCalled)
    }

    func testDidFetchPokemonDetails() {
        let pokemonDetails = PokemonDetails(id: 5, name: "Charmeleon", imageData: nil, types: "Fire", weight: "190.0 kg", height: "11.0 cm")
        presenter.didFetchPokemonDetails(pokemonDetails)
        XCTAssertTrue(mockView.displayPokemonDetailsCalled)
    }

    func testOnError() {
        presenter.onError(.loadDataError)
        XCTAssertTrue(mockView.showErrorCalled)
    }

}

class MockPokemonModuleInteractor: PokemonModuleInteractorInputProtocol {
    var presenter: PokemonModuleInteractorOutputProtocol!
    var fetchPokemonDetailsCalled = false

    func fetchPokemonDetails(with id: Int16) {
        fetchPokemonDetailsCalled = true
    }
}

class MockPokemonModuleView: PokemonModulePresenterOutputProtocol {
    var displayPokemonDetailsCalled = false
    var showErrorCalled = false

    func displayPokemonDetails(_ pokemonDetails: PokemonDetails) {
        displayPokemonDetailsCalled = true
    }

    func showError(_ alertType: AlertType) {
        showErrorCalled = true
    }
}

//
//  StackUsersDataSourceTests.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import XCTest
@testable import TopStack

class StackUsersDataSourceTests: XCTestCase {
	
	var dataSource: StackUsersDataSource!
	var mockAPIService: MockAPIService!
	
    override func setUp() {
        super.setUp()
		
		mockAPIService = MockAPIService()
		dataSource = StackUsersDataSource(apiService: self.mockAPIService,
		                                  tableView: UITableView())
    }
    
    override func tearDown() {
        super.tearDown()
    }
	

	// MARK: - Tests
	
	func test_Init_SetsAPIService() {
		XCTAssert(dataSource.apiService as? MockAPIService === mockAPIService)
	}
	
	func test_Init_SetsTableView() {
		let tableView = UITableView()
		dataSource = StackUsersDataSource(apiService: MockAPIService(), tableView: tableView)
		XCTAssert(dataSource.tableView === tableView)
	}
	
	func test_Init_SetsTableViewDelegateDataSource() {
		let tableView = UITableView()
		dataSource = StackUsersDataSource(apiService: MockAPIService(), tableView: tableView)
		XCTAssertNotNil(dataSource.tableView?.delegate)
		XCTAssertNotNil(dataSource.tableView?.dataSource)
	}
	
	func test_LoadUsers_APIServiceFetchUsersCalled() {
		XCTAssert(mockAPIService.usersFetched == false)
		dataSource.loadUsers()
		XCTAssert(mockAPIService.usersFetched)
	}
	
	func test_LoadUsers_Error_SetsErrorStateTrue() {
		let expectation = self.expectation(description: "load users should complete")
		
		mockAPIService.completionError = FakeError()
		dataSource.loadUsers(maxCount: 20) {
			XCTAssert(self.dataSource.isInErrorState)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 10, handler: nil)
	}
	
	func test_LoadUsers_NoError_SetsErrorStateFalse() {
		let expectation = self.expectation(description: "load users should complete")
		
		mockAPIService.completionError = nil
		dataSource.loadUsers(maxCount: 20) {
			XCTAssert(self.dataSource.isInErrorState == false)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 10, handler: nil)
	}
	
	func test_LoadUsers_UsersReturned_SetsUsers() {
		let expectation = self.expectation(description: "load users should complete")
		
		let users = [FakeUser(), FakeUser(), FakeUser()]
		mockAPIService.completionUsers = users
		dataSource.loadUsers(maxCount: 20) {
			XCTAssert(self.dataSource.users.count == 3)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 10, handler: nil)
	}
	
	func test_LoadUsers_UsersReturned_ReloadsTableView() {
		let expectation = self.expectation(description: "load users should complete")
		
		let users = [FakeUser()]
		mockAPIService.completionUsers = users
		
		let mocktableView = MockTableView()
		dataSource = StackUsersDataSource(apiService: MockAPIService(), tableView: mocktableView)
		dataSource.loadUsers(maxCount: 20) {
			// Tableview reload is done on main queue so assertion must also be done on main queue
			DispatchQueue.main.async {
				XCTAssert(mocktableView.dataReloaded)
				expectation.fulfill()
			}
		}
		
		waitForExpectations(timeout: 10, handler: nil)
	}
	
	
	// MARK: - Mocks
 
	class MockAPIService: UsersAPIService {
		
		var requestHandler: HTTPHandler = NetworkManager()
		var parser: DataParser = JSONParser()
		
		var usersFetched = false
		var completionError: Error? = nil
		var completionUsers: [User] = []
		
		func fetchUsers(maxCount: Int, completion: @escaping ([User]?, Error?) -> Void) {
			usersFetched = true
			completion(completionUsers, completionError)
		}
	}
	
	class MockTableView: UITableView {
		
		var dataReloaded = false
		
		override func reloadData() {
			dataReloaded = true
		}
	}
	
	struct FakeUser: User {
		var displayName: String = ""
		var reputation: Int = 1
		var profileImageURL: String = ""
		
		init() {}
		init?(json: [String : Any]) {}
	}
	
	struct FakeError: Error {}
}

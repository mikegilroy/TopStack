//
//  UsersListViewControllerTests.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import XCTest
@testable import TopStack

class UsersListViewControllerTests: XCTestCase {
	
	var controller: UsersListViewController!
	var mockController: MockUsersListVC!
	
    override func setUp() {
        super.setUp()
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		controller = storyboard.instantiateViewController(withIdentifier: "UsersListViewController") as! UsersListViewController
		_ = controller.view
		
		mockController = MockUsersListVC()
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	
	// MARK: - Tests
	
	func test_ViewDidLoad_UsersDataSourceNotNil() {
		XCTAssertNotNil(controller.usersDataSource)
	}
	
	func test_ViewDidLoad_LoadUsersCalled() {
		XCTAssert(mockController.usersLoaded == false)
		mockController.loadUsers()
		XCTAssert(mockController.usersLoaded)
	}
	
	func test_ReloadTapped_LoadUsersCalled() {
		XCTAssert(mockController.usersLoaded == false)
		mockController.reloadTapped(self)
		XCTAssert(mockController.usersLoaded)
	}
	
	func test_LoadUsers_DataSourceLoadUsersCalled() {
		let mockDataSource = MockDataSource()
		controller.usersDataSource = mockDataSource
		
		XCTAssertTrue(mockDataSource.usersLoaded == false)
		controller.loadUsers()
		XCTAssertTrue(mockDataSource.usersLoaded)
	}
	
	func test_LoadUsers_TableViewHidden() {
		controller.loadUsers()
		
		guard let tableview = controller.tableView else { XCTFail(); return }
		XCTAssert(tableview.isHidden)
	}
	
	func test_LoadUsers_ActivityIndicatorStarted() {
		controller.loadUsers()
		
		guard let activityIndicator = controller.activityIndicator else { XCTFail(); return }
		XCTAssert(activityIndicator.isAnimating)
	}
	
	func test_LoadUsersComplete_TableViewNotHidden() {
		let expectation = self.expectation(description: "expect load users to complete")
		controller.loadUsers { [weak self] in
			
			guard let tableview = self?.controller.tableView else { XCTFail(); return }
			XCTAssert(tableview.isHidden == false)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 10, handler: nil)
	}
	
	func test_LoadUsersComplete_ActivityIndicatorHidden() {
		let expectation = self.expectation(description: "expect load users to complete")
		controller.loadUsers { [weak self] in
			
			guard let activityIndicator = self?.controller.activityIndicator else { XCTFail(); return }
			XCTAssert(activityIndicator.isHidden)
			XCTAssert(activityIndicator.isAnimating == false)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 10, handler: nil)
	}
	
	// MARK: - Mocks
	
	class MockUsersListVC: UsersListViewController {
		
		var usersLoaded = false
		
		override func loadUsers(completion: (() -> Void)? = nil) {
			usersLoaded = true
		}
	}
	
	class MockDataSource: StackUsersDataSource {
		
		var usersLoaded = false
		
		init() {
			super.init(apiService: FakeAPIService(), tableView: UITableView())
		}
		
		override func loadUsers(maxCount: Int, completion: (() -> Void)?) {
			usersLoaded = true
			completion?()
		}
	}
	
	struct FakeAPIService: UsersAPIService {
		var requestHandler: HTTPHandler = NetworkManager()
		var parser: DataParser = JSONParser()
		func fetchUsers(maxCount: Int, completion: @escaping ([User]?, Error?) -> Void) {
			
		}
	}
}

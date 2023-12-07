//
//  RouteTest.swift
//  MerqueoUIKitTests
//
//  Created by Juan Camilo Fonseca Gomez on 5/12/23.
//

import XCTest
@testable import MerqueoUIKit

final class RouteTest: XCTestCase {
    //Se ejecuta primero
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    // Se ejecuta de ultimas
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    //Esto se ejecuta en orden alfabetico
    
    func testImageRoute() {
        //Given
        let urlRequest = ImageRoute.backDropPath(value: "/pD6sL4vntUOXHmuvJPPZAgvyfd9.jpg").urlRequestComplete
        //When
        let expecterURL = "https://image.tmdb.org/t/p/w200/pD6sL4vntUOXHmuvJPPZAgvyfd9.jpg"
        //Then
        XCTAssertEqual(expecterURL, urlRequest.url?.absoluteString ?? "")
    }
}

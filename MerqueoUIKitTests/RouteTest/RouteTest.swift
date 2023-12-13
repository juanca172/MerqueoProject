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
        let urlRequest = MovieResourceRoutes.posterPath(value: "/pD6sL4vntUOXHmuvJPPZAgvyfd9.jpg").urlRequestComplete
        //When
        let expecterURL = "https://image.tmdb.org/t/p/w300/pD6sL4vntUOXHmuvJPPZAgvyfd9.jpg"
        //Then
        XCTAssertEqual(expecterURL, urlRequest.url?.absoluteString ?? "")
    }
    func testPageRoute() {
        //Given
        let urlRequest = MovieResourceRoutes.pageRoute(page: 3).urlRequestComplete
        //When
        let expecterURL = "https://api.themoviedb.org/3/discover/movie?api_key=1e8867b1626434a57994c431d6d77ef9&sort_by=popularity.desc&page=3"
        //Then
        XCTAssertEqual(expecterURL, urlRequest.url?.absoluteString ?? "")
    }
    func testCreditsRoute() {
        //Given
        let urlRequest = MovieResourceRoutes.credistPath(MoviewID: 787699).urlRequestComplete
        //When
        let expecterURL = "https://api.themoviedb.org/3/movie/787699/credits?api_key=1e8867b1626434a57994c431d6d77ef9"
        //Then
        XCTAssertEqual(expecterURL, urlRequest.url?.absoluteString ?? "")
    }
}

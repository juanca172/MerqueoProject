//
//  NetworkTest.swift
//  MerqueoUIKitTests
//
//  Created by Juan Camilo Fonseca Gomez on 5/12/23.
//

import XCTest
@testable import MerqueoUIKit

final class NetworkTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    /**
     Faking: A working implementation of a class, not used in production
     Mocking: A fake response to the method call for of an object, allowing the checking of a particular method call or property
     Stubbing: A fake response to the method call for of an object
     */
    
    func testGetDataFromServer() {
        //Given
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=1e8867b1626434a57994c431d6d77ef9&sort_by=popularity.desc&page=2") else { return }
        let urlRequest = URLRequest(url: url)
        let networking = NetworkProvider()
        //When
        let responseExpected = 2
        let totalPagesExpected = 41460
        let expectation = XCTestExpectation(description: "testGetDataFromServer")
        
        Task {
            do {
                //Then
                let response: MovieModel = try await networking.fetcher(request: urlRequest)
                XCTAssertEqual(response.page, responseExpected)
                XCTAssertEqual(response.totalPages, totalPagesExpected)
                expectation.fulfill()
            } catch let error as NetworkError {
                switch error {
                case .decodingError(errorGet: let error):
                    print("\(error) decoding")
                case .networkError:
                    print("\(error) network")
                case .statusCodeError:
                    print("Estatus code error")
                }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func testGetCreditsData() {
        //Given
        let url = URL(string: "https://api.themoviedb.org/3/movie/787699/credits?api_key=1e8867b1626434a57994c431d6d77ef9")
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        let networking = NetworkProvider()
        //When
        let expectedID = 787699
        let expectedName = "Timothée Chalamet"
        let expectedNameCrew = "Roald Dahl"
        let expectation = expectation(description: "testGetCreditsData")
        Task{
            do {
                let value: CreditsModel = try await networking.fetcher(request: urlRequest)
                XCTAssertEqual(value.id, expectedID)
                XCTAssertEqual(value.cast[0].name, expectedName)
                expectation.fulfill()
            } catch let error as NetworkError {
                switch error {
                case .decodingError(errorGet: let error):
                    print("\(error) decoding")
                case .networkError:
                    print("\(error) network")
                case .statusCodeError:
                    print("Estatus code error")
                }
            }
        }
        wait(for: [expectation],timeout: 1.0)
    }
    func testMockRespond() {
        //Given
        let apiURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=1e8867b1626434a57994c431d6d77ef9&sort_by=popularity.desc&page=1")!
        let urlRequest = URLRequest(url: apiURL)
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLResponder.self]
        let urlSession = URLSession(configuration: config)
        let expectation = expectation(description: "testMockRespond")
        MockURLResponder.respond = { request in
            let arrayToEncode = ["Juan", "Castello"]
            let data = try! JSONEncoder().encode(arrayToEncode)
            let http = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (http, data)
        }
        let networkProvider = NetworkProvider(urlSession: urlSession)
        //When
        Task {
            //Then
            do {
                var data: [String] = try await networkProvider.fetcher(request: urlRequest)
                XCTAssertEqual(data[0], "Juan")
                expectation.fulfill()
            } catch {
                
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMockResponseErrorDecodingError() {
        //Given
        let apiURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=1e8867b1626434a57994c431d6d77ef9&sort_by=popularity.desc&page=1")!
        let urlRequest = URLRequest(url: apiURL)
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLResponder.self]
        let urlSession = URLSession(configuration: config)
        let expectation = expectation(description: "testMockResponseErrorDecodingError")
        MockURLResponder.respond = { request in
            var data: Data? = nil
            let dataRespond = try! JSONEncoder().encode(data)
            let http = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (http, dataRespond)
        }
        let networkProvider = NetworkProvider(urlSession: urlSession)
        //When
        Task {
            //Then
            do {
                var _: [String] = try await networkProvider.fetcher(request: urlRequest)
            } catch let error as NetworkError {
                switch error {
                case .decodingError(errorGet: let error1):
                    XCTAssertEqual(error, NetworkError.decodingError(errorGet: error1))
                case .networkError:
                    break
                case .statusCodeError:
                    break
                }
                expectation.fulfill()
            }
            
        }
        wait(for: [expectation], timeout: 2.0)
    }
    func testMockResponseErrorStatusError() {
        //Given
        let apiURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=1e8867b1626434a57994c431d6d77ef9&sort_by=popularity.desc&page=1")!
        let urlRequest = URLRequest(url: apiURL)
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLResponder.self]
        let urlSession = URLSession(configuration: config)
        let expectation = expectation(description: "testMockResponseErrorStatusError")
        MockURLResponder.respond = { request in
            let arrayToEncode = ["Juan", "Castello"]
            let data = try! JSONEncoder().encode(arrayToEncode)
            let http = HTTPURLResponse(url: apiURL, statusCode: 302, httpVersion: nil, headerFields: nil)!
            return (http, data)
        }
        let networkProvider = NetworkProvider(urlSession: urlSession)
        //When
        Task {
            //Then
            do {
                var _: [String] = try await networkProvider.fetcher(request: urlRequest)
            } catch let error as NetworkError {
                XCTAssertEqual(error  , NetworkError.statusCodeError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func testMockResponseErrorNetworkError() {
        //Given
        let apiURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=1e8867b1626434a57994c431d6d77ef9&sort_by=popularity.desc&page=1")!
        let urlRequest = URLRequest(url: apiURL)
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLResponder.self]
        let urlSession = URLSession(configuration: config)
        let expectation = expectation(description: "testMockResponseErrorNetworkError")
        MockURLResponder.respond = { request in
            let arrayToEncode = ["Juan", "Castello"]
            let data = try! JSONEncoder().encode(arrayToEncode)
            let http = HTTPURLResponse(url: apiURL, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (http, data)
        }
        let networkProvider = NetworkProvider(urlSession: urlSession)
        //When
        Task {
            //Then
            do {
                var _: [String] = try await networkProvider.fetcher(request: urlRequest)
            } catch let error as NetworkError{
                XCTAssertEqual(error , NetworkError.networkError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    

}

class MockURLResponder: URLProtocol {
    
    static var respond: ((_ urlRequest: URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    override func startLoading() {
        guard let handler = MockURLResponder.respond else {
            assert(false, "Mock is nil")
            return
        }
        do {
            let (response, data) = try handler(self.request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
    }
    override func stopLoading() {
        
    }
}

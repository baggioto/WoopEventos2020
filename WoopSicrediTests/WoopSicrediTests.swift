//
//  WoopSicrediTests.swift
//  WoopSicrediTests
//
//  Created by Felipe Baggioto on 14/07/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
@testable import Woop_Sicredi

class mainViewTests: XCTestCase {
    
    var viewModel: MainViewModel!
    var input: MainViewModel.Input! = nil
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.input = MainViewModel.Input(onViewDidLoad: PublishRelay<Void>())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTriggerOnViewDidLoad() throws {
        
        self.viewModel = MainViewModel()
        
        let successObserver = scheduler.createObserver(MainViewModelDoubleBehavior.self)
        
        let _ = scheduler.createHotObservable([next(0, ())])
            .bind(to: self.input.onViewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.double.asDriver()
            .drive(successObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(successObserver.events, [.next(0, .success)])
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

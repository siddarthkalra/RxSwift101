//
//  OrderCartViewModelSpec.swift
//  RxSwift101Tests
//
//  Created by Siddarth Kalra on 2019-01-06.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import Quick
import Nimble
import RxCocoa
import RxSwift
import RxTest
@testable import RxSwift101

class OrderCartViewModelSpec: QuickSpec {

    override func spec() {

        var sut: OrderCartViewModel!
        var scheduler: TestScheduler!

        beforeEach {
            sut = OrderCartViewModel()
            scheduler = TestScheduler(initialClock: 0)
        }

        describe("init") {

            it("has empty order item") {
                SharingScheduler.mock(scheduler: scheduler) {
                    let orderItemEvents = scheduler.record(source: sut.orderItemsDriver)
                    scheduler.start()

                    expect(orderItemEvents.firstElement!).to(beEmpty())
                }
            }
        }

        describe("orderItemsRelay") {

            it("emits events") {
                let disposeBag = DisposeBag()
                SharingScheduler.mock(scheduler: scheduler) {
                    let orderItemEvents = scheduler.record(source: sut.orderItemsDriver)

                    scheduler
                        .createHotObservable([next(0, "test1"), next(0, "test2"), next(0, "test3")])
                        .bind(to: sut.newMenuItemRelay).disposed(by: disposeBag)

                    scheduler.start()

                    expect(orderItemEvents.events[0].value.element).to(beEmpty())
                    expect(orderItemEvents.events[1].value.element).to(equal(["test1"]))
                    expect(orderItemEvents.events[2].value.element).to(equal(["test1", "test2"]))
                    expect(orderItemEvents.events[3].value.element).to(equal(["test1", "test2", "test3"]))
                }
            }
        }
    }

}

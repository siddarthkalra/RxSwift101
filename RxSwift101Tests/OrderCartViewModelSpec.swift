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
                    let orderItemEvents = scheduler.record(source: sut.orderItemDriver)
                    scheduler.start()

                    expect(orderItemEvents.firstElement!).to(beEmpty())
                }
            }
        }

        describe("orderItemRelay") {

            it("emits events") {
                SharingScheduler.mock(scheduler: scheduler) {
                    let orderItemEvents = scheduler.record(source: sut.orderItemDriver)

                    sut.orderItemRelay.accept("test1")
                    sut.orderItemRelay.accept("test2")
                    sut.orderItemRelay.accept("test3")
                    scheduler.start()

                    expect(orderItemEvents.events[0].value.element).to(beEmpty())
                    expect(orderItemEvents.events[1].value.element).to(equal("test1"))
                    expect(orderItemEvents.events[2].value.element).to(equal("test2"))
                    expect(orderItemEvents.events[3].value.element).to(equal("test3"))
                }
            }
        }
    }

}
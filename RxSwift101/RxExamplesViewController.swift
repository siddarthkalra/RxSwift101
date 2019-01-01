//
//  RxExamplesViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2018-12-06.
//  Copyright © 2018 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxSwift

class RxExamplesViewController: UITableViewController {

    private let cellID = "cellID"

    let rxExampleSections = ["Observables", "Subjects", "Relays"]
    let rxExamples: [[RxExample]] = [
        [.observeAllEventsTogether, .observeAllEventsSeparately, .sequenceWithError],
        [.publishSubjectExample, .behaviorSubjectExample, .replaySubjectExample, .variableExample],
        [.publishRelayExample, .behaviorRelayExample]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rx Examples"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return rxExampleSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rxExamples[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rxExampleSections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedExample = rxExamples[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = selectedExample.rawValue
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedExample = rxExamples[indexPath.section][indexPath.row]
        let vc = ObservableSequenceController()
        vc.rxExample = selectedExample

        navigationController?.pushViewController(vc, animated: true)
    }

}

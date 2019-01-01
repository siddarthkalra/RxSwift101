//
//  RxExamplesViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2018-12-06.
//  Copyright © 2018 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxSwift

enum RxExample: String {
    case observeAllEventsTogether = "Observable Sequence, all events together"
    case observeAllEventsSeparately = "Observable Sequence, all events separately"
    case sequenceWithError = "Observable Sequence with Error"
    case publishSubjectExample = "Publish Subject"
    case behaviorSubjectExample = "Behavior Subject"
    case replaySubjectExample = "Replay Subject"
    case variableExample = "Variable"
    case publishRelayExample = "Publish Relay"
    case behaviorRelayExample = "Behavior Relay"
}

class RxExamplesViewController: UITableViewController {

    let rxExampleSections = ["Observables", "Subjects", "Relays"]
    let rxExamples: [[RxExample]] = [
        [.observeAllEventsTogether, .observeAllEventsSeparately, .sequenceWithError],
        [.publishSubjectExample, .behaviorSubjectExample, .replaySubjectExample, .variableExample],
        [.publishRelayExample, .behaviorRelayExample]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rx Examples"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
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

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
    case observeAllEventsTogether
    case observeAllEventsSeparately
    case sequenceWithError
    case publishSubjectExample
    case behaviorSubjectExample
    case replaySubjectExample
    case variableExample
    case publishRelayExample
    case behaviorRelayExample
}

class RxExamplesViewController: UITableViewController {

    let rxExamples: [RxExample] = [.observeAllEventsTogether, .observeAllEventsSeparately, .sequenceWithError, .publishSubjectExample, .behaviorSubjectExample, .replaySubjectExample, .variableExample, .publishRelayExample, .behaviorRelayExample]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rxExamples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedExample = rxExamples[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = String(describing: selectedExample)
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedExample = rxExamples[indexPath.row]
        let vc = ObservableSequenceController()
        vc.rxExample = selectedExample

        navigationController?.pushViewController(vc, animated: true)
    }

}

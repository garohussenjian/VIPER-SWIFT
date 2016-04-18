//
//  ListViewController.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController, ListViewInterface {

    let entryCellIdentifier = "ListEntryCell"

    var eventHandler: ListModuleInterface?
    var dataProperty: UpcomingDisplayData?
    var strongTableView: UITableView?

    @IBOutlet var noContentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        strongTableView = tableView
        configureView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        eventHandler?.updateView()
    }

    func configureView() {
        navigationItem.title = "VIPER TODO"

        let addItem = UIBarButtonItem(barButtonSystemItem: .Add,
                                      target: self,
                                      action: #selector(didTapAddButton))

        navigationItem.rightBarButtonItem = addItem
    }

    func didTapAddButton () {
        eventHandler?.addNewEntry()
    }

    func showNoContentMessage() {
        view = noContentView
    }

    func showUpcomingDisplayData(data: UpcomingDisplayData) {
        view = strongTableView

        dataProperty = data
        reloadEntries()
    }

    func reloadEntries() {
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = dataProperty?.sections.count

        if dataProperty?.sections.count == nil {
            numberOfSections = 0
        }

        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let upcomingSection = dataProperty?.sections[section]
        return upcomingSection!.items.count
    }

    override func tableView(tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        let upcomingSection = dataProperty?.sections[section]
        return upcomingSection!.name
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        let upcomingSection = dataProperty?.sections[indexPath.section]
        let upcomingItem = upcomingSection!.items[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier(entryCellIdentifier,
                                                               forIndexPath: indexPath)

        cell.textLabel?.text = upcomingItem.title
        cell.detailTextLabel?.text = upcomingItem.dueDate
        cell.imageView?.image = UIImage(named: upcomingSection!.imageName)
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }
}

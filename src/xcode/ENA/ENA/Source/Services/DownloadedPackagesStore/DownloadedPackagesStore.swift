//
//  DownloadedPackagesStore.swift
//  ENA
//
//  Created by Kienle, Christian on 13.05.20.
//  Copyright © 2020 SAP SE. All rights reserved.
//

import Foundation

final class DownloadedPackagesStore {
    // MARK: Creating

    // MARK: Properties
    private var packagesByDay = [String: SAPDownloadedPackage]()

    // Stores all downloaded hours mapped by day.
    // The data stored here looks like this:
    // 2020-05-01
    //     0: keys for that day at hour 0
    //     1: keys for that day at hour 1
    //     n: keys for that day at hour n
    // 2020-05-02
    //     0: keys for that day at hour 0
    //     1: keys for that day at hour 1
    //     n: keys for that day at hour n
    //
    // etc
    //
    // This means that this store can be used to store the hours of any given day.
    // It is up to the consumer to find the correct day.
    // It is also up to the consumer of this class to clean unwanted hourly data.
    private var packagesByHour = [String: [Int: SAPDownloadedPackage]]()

    // MARK: Working with Days
    func missingDays(remoteDays: Set<String>) -> Set<String> {
        remoteDays.subtracting(Set(packagesByDay.keys))
    }

    func set(day: String, downloadedPackage: SAPDownloadedPackage) {
        packagesByDay[day] = downloadedPackage
    }

    func keyPackage(for day: String) -> SAPDownloadedPackage? {
        packagesByDay[day]
    }

    func allDailyKeyPackages() -> [SAPDownloadedPackage] {
        Array(packagesByDay.values)
    }

    func hourlyPackages(day: String) -> [SAPDownloadedPackage] {
        Array(packagesByHour[day, default: [:]].values)
    }

    // MARK: Working with Hours
    func set(hour: Int, day: String, downloadedPackage: SAPDownloadedPackage) {
        var packages = packagesByHour[day, default: [:]]
        packages[hour] = downloadedPackage
        packagesByHour[day] = packages
    }

    func missingHours(day: String, remoteHours: Set<Int>) -> Set<Int> {
        let packages = packagesByHour[day, default: [:]]
        let localHours = Set(packages.keys)
        return remoteHours.subtracting(localHours)
    }
}
//
//  NetworkHelper.swift
//  EXIFReader
//
//  Created by Gualtiero Frigerio on 29/10/2020.
//

import Foundation
import Network
import Combine

class NetworkHelper {
    var wifiAvailable:AnyPublisher<Bool, Never> {
        $isWifiAvailable.eraseToAnyPublisher()
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            self.updateWifiAvailability(status: path.status)
        }
        self.updateWifiAvailability(status: monitor.currentPath.status)
        monitor.start(queue: DispatchQueue.main)
    }
    
    private let monitor = NWPathMonitor(requiredInterfaceType: .cellular)
    @Published private var isWifiAvailable = false
    
    private func updateWifiAvailability(status:NWPath.Status) {
        print("updateWifiAvailability status \(status)")
        if status == .satisfied {
            self.isWifiAvailable = true
        }
        else {
            self.isWifiAvailable = false
        }
    }
}

//
//  NetworkHelper.swift
//  EXIFReader
//
//  Created by Gualtiero Frigerio on 29/10/2020.
//

import Combine
import Network

@available(iOS 13.0, *)
enum NetworkStatusHelperConnectionType {
    case any
    case cellular
    case wifi
    case wired
    
    func toInterfaceType() -> NWInterface.InterfaceType {
        var interfaceType:NWInterface.InterfaceType = .other
        switch self {
        case .any:
            interfaceType = .other
        case .cellular:
            interfaceType = .cellular
        case .wifi:
            interfaceType = .wifi
        case .wired:
            interfaceType = .wiredEthernet
        }
        return interfaceType
    }
}

@available(iOS 13.0, *)
class NetworkStatusHelper {
    var connectionAvailable:AnyPublisher<Bool, Never> {
        $isConnectionAvailable.eraseToAnyPublisher()
    }
    
    init(connectionType:NetworkStatusHelperConnectionType = .any) {
        isConnectionAvailable = false
        if connectionType == .any {
            monitor = NWPathMonitor()
        }
        else {
            monitor = NWPathMonitor(requiredInterfaceType: connectionType.toInterfaceType())
        }
        requiredType = connectionType
        monitor.pathUpdateHandler = { path in
            self.updatePath(path)
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    @Published private var isConnectionAvailable:Bool
    private var monitor:NWPathMonitor
    private var requiredType:NetworkStatusHelperConnectionType
    
    private func updatePath(_ path:NWPath) {
        if path.status == .satisfied {
            isConnectionAvailable = true
        }
        else {
            isConnectionAvailable = false
        }
    }
}

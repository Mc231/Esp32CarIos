//
//  WebSocketManagerProtocol.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 10.03.2024.
//

import Foundation

import Foundation

enum WebSocketMessage {
    case text(String)
    case data(Data)
}

extension WebSocketMessage {
    var asUrlSessionWebSocketMessage: URLSessionWebSocketTask.Message {
        switch self {
        case .text(let string):
            return .string(string)
        case .data(let data):
            return .data(data)
        }
    }
}

protocol WebSocketManagerDelegate: AnyObject {
    func webSocketDidReceiveMessage(_ manager: WebSocketManagerProtocol?, message: WebSocketMessage)
    func webSocketDidReceiveError(_ manager: WebSocketManagerProtocol?, error: Error)
}

protocol WebSocketManagerProtocol: AnyObject {
    var delegate: WebSocketManagerDelegate? { get set }
    func connect()
    func disconnect()
    func sendMessage(_ message: WebSocketMessage)
}

class URLSessionWebSocketManager: WebSocketManagerProtocol {
    weak var delegate: WebSocketManagerDelegate?

    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let url: URL

    init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    func connect() {
        disconnect()

        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        listenForMessages()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }

    func sendMessage(_ message: WebSocketMessage) {
        let messageToSend = message.asUrlSessionWebSocketMessage
        webSocketTask?.send(messageToSend) { [weak self] error in
            if let error = error {
                self?.delegate?.webSocketDidReceiveError(self, error: error)
            }
        }
    }

    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self.delegate?.webSocketDidReceiveMessage(self, message: .text(text))
                case .data(let data):
                    self.delegate?.webSocketDidReceiveMessage(self, message: .data(data))
                @unknown default:
                    fatalError("Unknown message format received from WebSocket")
                }
            }
            self.listenForMessages()
        }
    }
}

//
//  SocketManager.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/02/01.
//

import Foundation

import Starscream

// MARK: - Web Socket Type

enum SocketType {
  case ticker
  case orderbookdepth
  case transaction

  var message: String {
    switch self {
    case .ticker:
      return "ticker"
    case .orderbookdepth:
      return "orderbookdepth"
    case .transaction:
      return "transaction"
    }
  }
}


// MARK: - Web Socket Manager

final class WebSocketManager {
  static let shared = WebSocketManager()

  var socket: WebSocket?
  private let baseURL = "wss://pubwss.bithumb.com/pub/ws"

  init() {
    self.setUpWebSocket()
  }

  private func setUpWebSocket() {
    guard let request = self.setUpRequest() else { return }

    self.socket = WebSocket(request: request)
    socket?.connect()
  }

  private func setUpRequest() -> URLRequest? {
    guard let url = URL(string: self.baseURL) else { return nil }
    var request = URLRequest(url: url)
    request.timeoutInterval = 60
    return request
  }

  func sendMessage(socketType: SocketType, symbols: String, tickType: String) {
    let message = "{\"type\":\"\(socketType.message)\", \"symbols\": [\"\(symbols)\"], \"tickTypes\": [\"\(tickType)\"]}"
    socket?.write(string: message)
  }
}

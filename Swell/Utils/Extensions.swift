//
//  Extensions.swift
//  Swell
//
//  Created by Tanner Maasen on 1/16/22.
//

import Foundation
import SwiftUI
import UIKit

public extension Color {
    static let swellOrange = Color("swellOrange")
}

public extension TextField {
    func withTextFieldStyles() -> some View {
        self.padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.swellOrange, lineWidth: 2)
            )
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding(.bottom, 20)
    }
}

public extension SecureField {
    func withSecureFieldStyles() -> some View {
        self.padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.swellOrange, lineWidth: 2)
            )
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding(.bottom, 20)
    }
}

public extension Button {
    func withButtonStyles() -> some View {
        self.font(.custom("Ubuntu-Bold", size: 20))
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color.swellOrange)
            .cornerRadius(15.0)
    }
}

public extension UIAlertController {
  convenience init(alert: TextAlert) {
    self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
    addTextField {
       $0.placeholder = alert.placeholder
       $0.keyboardType = alert.keyboardType
    }
    if let cancel = alert.cancel {
      addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
        alert.action(nil)
      })
    }
    let textField = self.textFields?.first
    addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
      alert.action(textField?.text)
    })
  }
}
// Has to be here for the Text and View extensions (TM 1/16/22)
public struct TextAlert {
    public var title: String
    public var message: String
    public var placeholder: String = ""
    public var accept: String = "Send"
    public var cancel: String? = "Cancel"
    public var keyboardType: UIKeyboardType = .emailAddress
    public var action: (String?) -> Void
}

// Has to be here for the Text and View extensions (TM 1/16/22)
public struct AlertWrapper<Content: View>: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  let alert: TextAlert
  let content: Content

    public func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }

    final public class Coordinator {
        var alertController: UIAlertController?
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    public func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<AlertWrapper>) {
        uiViewController.rootView = content
        if isPresented && uiViewController.presentedViewController == nil {
            var alert = self.alert
            alert.action = {
                self.isPresented = false
                self.alert.action($0)
            }
            context.coordinator.alertController = UIAlertController(alert: alert)
            uiViewController.present(context.coordinator.alertController!, animated: true)
        }
        if !isPresented && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
}

public extension View {
    func alert(isPresented: Binding<Bool>, _ alert: TextAlert) -> some View {
        AlertWrapper(isPresented: isPresented, alert: alert, content: self)
    }
}
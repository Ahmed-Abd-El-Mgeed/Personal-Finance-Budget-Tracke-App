//
//  NotificationToastManager.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

//import SwiftUI
//import Combine
//import JDStatusBarNotification
//
//
///// A public manager class to easily present and dismiss status bar notifications in SwiftUI
//@MainActor
//public class NotificationManager: ObservableObject {
//    
//    // MARK: - Singleton
//    
//    public static let shared = NotificationManager()
//    
//    // MARK: - Published Properties
//    
//    @Published public var isPresented: Bool = false
//    @Published public var isShowingActivity: Bool = false
//    @Published public var progress: Double = 0.0
//    
//    // MARK: - Private Properties
//    
//    private let internalStyleName = "__notification-manager-style"
//    private var dismissTask: Task<Void, Never>?
//    
//    // MARK: - Initialization
//    
//    private init() {}
//    
//    // MARK: - Computed Properties
//    
//    /// Check if a notification is currently visible
//    public var isVisible: Bool {
//        NotificationPresenter.shared.isVisible
//    }
//    
//    // MARK: - Public Methods - Basic Presentation
//    
//    /// Present a notification with title only
//    public func show(title: String, style: ((StatusBarNotificationStyle) -> Void)? = nil) {
//        presentNotification(title: title, subtitle: nil, style: style)
//    }
//    
//    
//    /// Present a notification with title and subtitle
//    public func show(title: String, subtitle: String?, style: ((StatusBarNotificationStyle) -> Void)? = nil) {
//        presentNotification(title: title, subtitle: subtitle, style: style)
//    }
//    
//    /// Present a notification with custom colors
//    /// - Parameters:
//    ///   - title: The title text
//    ///   - subtitle: Optional subtitle text
//    ///   - backgroundColor: Background color of the notification
//    ///   - textColor: Color of the text
//    public func show(title: String,
//                     subtitle: String? = nil,
//                     backgroundColor: UIColor,
//                     textColor: UIColor = .white) {
//        let np = NotificationPresenter.shared
//        
//        let styleName = np.addStyle(named: internalStyleName) { style in
//            style.backgroundStyle.backgroundColor = backgroundColor
//            style.textStyle.textColor = textColor
//            return style
//        }
//        
//        np.present(title, subtitle: subtitle, styleName: styleName)
//        isPresented = true
//    }
//    
//    
//    /// Present a notification with an included style
//    public func show(title: String, subtitle: String? = nil, includedStyle: IncludedStatusBarNotificationStyle) {
//        let np = NotificationPresenter.shared
//        np.present(title, subtitle: subtitle, includedStyle: includedStyle)
//        isPresented = true
//    }
//    
//    /// Present a notification with a custom style name
//    public func show(title: String, subtitle: String? = nil, styleName: String) {
//        let np = NotificationPresenter.shared
//        np.present(title, subtitle: subtitle, styleName: styleName)
//        isPresented = true
//    }
//    
//    // MARK: - Public Methods - Custom View
//    
//    /// Present a notification with a custom SwiftUI view
//    public func show<Content: View>(style: ((StatusBarNotificationStyle) -> Void)? = nil, @ViewBuilder content: () -> Content) {
//        let np = NotificationPresenter.shared
//        
//        let styleName: String?
//        if let style = style {
//            styleName = np.addStyle(named: internalStyleName) { s in
//                style(s)
//                return s
//            }
//        } else {
//            styleName = nil
//        }
//        
//        np.presentSwiftView(styleName: styleName, viewBuilder: content)
//        isPresented = true
//    }
//    
//    /// Present a notification with a custom SwiftUI view and included style
//    public func show<Content: View>(includedStyle: IncludedStatusBarNotificationStyle, @ViewBuilder content: () -> Content) {
//        let np = NotificationPresenter.shared
//        let styleName = np.addStyle(named: internalStyleName, usingStyle: includedStyle) { return $0 }
//        np.presentSwiftView(styleName: styleName, viewBuilder: content)
//        isPresented = true
//    }
//    
//    // MARK: - Public Methods - Activity & Progress
//    
//    /// Show or hide activity indicator on current notification
//    public func showActivity(_ show: Bool) {
//        isShowingActivity = show
//        NotificationPresenter.shared.displayActivityIndicator(show)
//    }
//    
//    /// Update progress bar on current notification (0.0 to 1.0)
//    public func updateProgress(_ value: Double) {
//        progress = value
//        NotificationPresenter.shared.displayProgressBar(at: value)
//    }
//    
//    // MARK: - Public Methods - Auto Dismiss
//    
//    /// Present a notification that automatically dismisses after a duration
//    /// - Parameters:
//    ///   - title: The title text
//    ///   - subtitle: Optional subtitle text
//    ///   - duration: How long to show the notification (in seconds)
//    ///   - style: Optional style customization closure
//    public func showAndDismiss(title: String,
//                               subtitle: String? = nil,
//                               duration: TimeInterval = 2.0,
//                               style: ((StatusBarNotificationStyle) -> Void)? = nil) {
//        // Cancel any existing dismiss task
//        dismissTask?.cancel()
//        
//        show(title: title, subtitle: subtitle, style: style)
//        
//        dismissTask = Task { [weak self] in
//            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
//            
//            // Check if task was cancelled
//            guard !Task.isCancelled else { return }
//            
//            await MainActor.run {
//                self?.dismiss()
//            }
//        }
//    }
//    
//    /// Present a notification with custom colors that automatically dismisses
//    /// - Parameters:
//    ///   - title: The title text
//    ///   - subtitle: Optional subtitle text
//    ///   - duration: How long to show the notification (in seconds)
//    ///   - backgroundColor: Background color of the notification
//    ///   - textColor: Color of the text
//    public func showAndDismiss(title: String,
//                               subtitle: String? = nil,
//                               duration: TimeInterval = 2.0,
//                               backgroundColor: UIColor,
//                               textColor: UIColor = .white) {
//        dismissTask?.cancel()
//        
//        show(title: title, subtitle: subtitle, backgroundColor: backgroundColor, textColor: textColor)
//        
//        dismissTask = Task { [weak self] in
//            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
//            guard !Task.isCancelled else { return }
//            
//            await MainActor.run {
//                self?.dismiss()
//            }
//        }
//    }
//    
//    /// Present a notification with included style that automatically dismisses after a duration
//    public func showAndDismiss(title: String,
//                               subtitle: String? = nil,
//                               duration: TimeInterval = 2.0,
//                               includedStyle: IncludedStatusBarNotificationStyle) {
//        dismissTask?.cancel()
//        
//        show(title: title, subtitle: subtitle, includedStyle: includedStyle)
//        
//        dismissTask = Task { [weak self] in
//            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
//            guard !Task.isCancelled else { return }
//            
//            await MainActor.run {
//                self?.dismiss()
//            }
//        }
//    }
//    
//    /// Present a custom view notification that automatically dismisses after a duration
//    public func showAndDismiss<Content: View>(duration: TimeInterval = 2.0,
//                                              style: ((StatusBarNotificationStyle) -> Void)? = nil,
//                                              @ViewBuilder content: () -> Content) {
//        dismissTask?.cancel()
//        
//        show(style: style, content: content)
//        
//        dismissTask = Task { [weak self] in
//            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
//            guard !Task.isCancelled else { return }
//            
//            await MainActor.run {
//                self?.dismiss()
//            }
//        }
//    }
//    
//    // MARK: - Public Methods - Dismissal
//    
//    /// Dismiss the current notification
//    public func dismiss(animated: Bool = true) {
//        dismissTask?.cancel()
//        dismissTask = nil
//        NotificationPresenter.shared.dismiss(animated: animated)
//        reset()
//    }
//    
//    // MARK: - Private Helpers
//    
//    private func presentNotification(title: String, subtitle: String?, style: ((StatusBarNotificationStyle) -> Void)?) {
//        let np = NotificationPresenter.shared
//        
//        if let style = style {
//            let styleName = np.addStyle(named: internalStyleName) { s in
//                style(s)
//                return s
//            }
//            np.present(title, subtitle: subtitle, styleName: styleName)
//        } else {
//            np.present(title, subtitle: subtitle)
//        }
//        
//        isPresented = true
//    }
//    
//    private func reset() {
//        isPresented = false
//        isShowingActivity = false
//        progress = 0.0
//    }
//    
//    deinit {
//        dismissTask?.cancel()
//    }
//}
//
//extension NotificationManager {
//    
//    /// Handles a loading notification for async operations
//    /// - Parameters:
//    ///   - loadingTitle: title shown while loading
//    ///   - task: the async task to perform, returns optional error string
//    public func performWithLoading(
//        loadingTitle: String = "Loading...",
//        task: @escaping (@escaping (String?) -> Void) -> Void
//    ) {
//        //  Show loading
//        show(title: loadingTitle, backgroundColor: Color.lightBeige.uiColor, textColor: .black)
//        showActivity(true)
//        
//        //  Run the task
//        task { [weak self] errorMessage in
//            // Hide loading
//            self?.showActivity(false)
//            
//            if let error = errorMessage {
//                //  Error
//                self?.showAndDismiss(
//                    title: "Failed",
//                    subtitle: error,
//                    duration: 3,
//                    backgroundColor: UIColor.systemRed,
//                    textColor: .white
//                )
//            } else {
//                //  Success
//                self?.showAndDismiss(
//                    title: "Success",
//                    duration: 2,
//                    backgroundColor: UIColor.systemGreen,
//                    textColor: .white
//                )
//            }
//        }
//    }
//}



import SwiftUI
import Combine
import JDStatusBarNotification

@MainActor
public class NotificationManager: ObservableObject {
    
    // MARK: - Singleton
    public static let shared = NotificationManager()
    
    // MARK: - Published Properties
    @Published public var isPresented: Bool = false
    @Published public var isShowingActivity: Bool = false
    @Published public var progress: Double = 0.0
    
    // MARK: - Private Properties
    private let internalStyleName = "__notification-manager-style"
    private var dismissTask: Task<Void, Never>?
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Computed Properties
    public var isVisible: Bool {
        NotificationPresenter.shared.isVisible
    }
    
    // MARK: - Public Methods - Basic Presentation
    
    /// Show notification with title only
    public func show(title: String, style: ((StatusBarNotificationStyle) -> Void)? = nil) {
        presentNotification(title: title, subtitle: nil, style: style)
    }
    
    /// Show notification with title and subtitle
    public func show(title: String, subtitle: String?, style: ((StatusBarNotificationStyle) -> Void)? = nil) {
        presentNotification(title: title, subtitle: subtitle, style: style)
    }
    
    /// Show notification with background color, title color, and subtitle color
    public func show(title: String,
                     subtitle: String? = nil,
                     backgroundColor: UIColor,
                     titleColor: UIColor = .white,
                     subtitleColor: UIColor? = nil) {
        let np = NotificationPresenter.shared
        
        let styleName = np.addStyle(named: internalStyleName) { style in
            style.backgroundStyle.backgroundColor = backgroundColor
            style.textStyle.textColor = titleColor
            style.subtitleStyle.textColor = subtitleColor ?? titleColor
            return style
        }
        
        np.present(title, subtitle: subtitle, styleName: styleName)
        isPresented = true
    }
    
    /// Show notification with included style
    public func show(title: String, subtitle: String? = nil, includedStyle: IncludedStatusBarNotificationStyle) {
        let np = NotificationPresenter.shared
        np.present(title, subtitle: subtitle, includedStyle: includedStyle)
        isPresented = true
    }
    
    /// Show notification with custom style name
    public func show(title: String, subtitle: String? = nil, styleName: String) {
        let np = NotificationPresenter.shared
        np.present(title, subtitle: subtitle, styleName: styleName)
        isPresented = true
    }
    
    /// Show notification with a custom SwiftUI view
    public func show<Content: View>(style: ((StatusBarNotificationStyle) -> Void)? = nil, @ViewBuilder content: () -> Content) {
        let np = NotificationPresenter.shared
        let styleName: String?
        
        if let style = style {
            styleName = np.addStyle(named: internalStyleName) { s in
                style(s)
                return s
            }
        } else {
            styleName = nil
        }
        
        np.presentSwiftView(styleName: styleName, viewBuilder: content)
        isPresented = true
    }
    
    /// Show SwiftUI view with included style
    public func show<Content: View>(includedStyle: IncludedStatusBarNotificationStyle, @ViewBuilder content: () -> Content) {
        let np = NotificationPresenter.shared
        let styleName = np.addStyle(named: internalStyleName, usingStyle: includedStyle) { $0 }
        np.presentSwiftView(styleName: styleName, viewBuilder: content)
        isPresented = true
    }
    
    // MARK: - Activity & Progress
    public func showActivity(_ show: Bool) {
        isShowingActivity = show
        NotificationPresenter.shared.displayActivityIndicator(show)
    }
    
    public func updateProgress(_ value: Double) {
        progress = value
        NotificationPresenter.shared.displayProgressBar(at: value)
    }
    
    // MARK: - Auto Dismiss
    public func showAndDismiss(title: String,
                               subtitle: String? = nil,
                               duration: TimeInterval = 2.0,
                               style: ((StatusBarNotificationStyle) -> Void)? = nil) {
        dismissTask?.cancel()
        show(title: title, subtitle: subtitle, style: style)
        
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await MainActor.run { self?.dismiss() }
        }
    }
    
    public func showAndDismiss(title: String,
                               subtitle: String? = nil,
                               duration: TimeInterval = 2.0,
                               backgroundColor: UIColor,
                               titleColor: UIColor = .white,
                               subtitleColor: UIColor? = nil) {
        dismissTask?.cancel()
        show(title: title, subtitle: subtitle,
             backgroundColor: backgroundColor,
             titleColor: titleColor,
             subtitleColor: subtitleColor)
        
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await MainActor.run { self?.dismiss() }
        }
    }
    
    public func showAndDismiss(title: String,
                               subtitle: String? = nil,
                               duration: TimeInterval = 2.0,
                               includedStyle: IncludedStatusBarNotificationStyle) {
        dismissTask?.cancel()
        show(title: title, subtitle: subtitle, includedStyle: includedStyle)
        
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await MainActor.run { self?.dismiss() }
        }
    }
    
    public func showAndDismiss<Content: View>(duration: TimeInterval = 2.0,
                                              style: ((StatusBarNotificationStyle) -> Void)? = nil,
                                              @ViewBuilder content: () -> Content) {
        dismissTask?.cancel()
        show(style: style, content: content)
        
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await MainActor.run { self?.dismiss() }
        }
    }
    
    // MARK: - Dismiss
    public func dismiss(animated: Bool = true) {
        dismissTask?.cancel()
        dismissTask = nil
        NotificationPresenter.shared.dismiss(animated: animated)
        reset()
    }
    
    // MARK: - Helpers
    private func presentNotification(title: String, subtitle: String?, style: ((StatusBarNotificationStyle) -> Void)?) {
        let np = NotificationPresenter.shared
        
        if let style = style {
            let styleName = np.addStyle(named: internalStyleName) { s in
                style(s)
                return s
            }
            np.present(title, subtitle: subtitle, styleName: styleName)
        } else {
            np.present(title, subtitle: subtitle)
        }
        
        isPresented = true
    }
    
    private func reset() {
        isPresented = false
        isShowingActivity = false
        progress = 0.0
    }
    
    deinit {
        dismissTask?.cancel()
    }
    
    // MARK: - Loading helper
//    public func performWithLoading(
//        loadingTitle: String = "Loading...",
//        task: @escaping (@escaping (String?) -> Void) -> Void
//    ) {
//        show(title: loadingTitle, backgroundColor: Color.lightBeige.uiColor, titleColor: .black)
//        showActivity(true)
//        
//        task { [weak self] errorMessage in
//            self?.showActivity(false)
//            
//            if let error = errorMessage {
//                self?.showAndDismiss(
//                    title: "Failed",
//                    subtitle: error,
//                    duration: 3,
//                    backgroundColor: UIColor.systemRed,
//                    titleColor: .white,
//                    subtitleColor: .yellow
//                )
//            } else {
//                self?.showAndDismiss(
//                    title: "Success",
//                    duration: 2,
//                    backgroundColor: UIColor.systemGreen,
//                    titleColor: .white
//                )
//            }
//        }
//    }
    
    
    public func performWithLoading(
        loadingTitle: String = "Loading...",
        fieldTitle: String = "Field",
        successTitle: String = "Success",
        task: @escaping (@escaping (String?) -> Void) -> Void
    ) {
        // Show initial loading
        show(title: loadingTitle, backgroundColor: Color.lightBeige.uiColor, titleColor: .black)
        showActivity(true)
        
        // Run the async task
        task { [weak self] errorMessage in
            self?.showActivity(false)
            
            let finalTitle: String
            let subtitle: String? = nil
            let bgColor: UIColor
            
            if let error = errorMessage, !error.isEmpty {
                // If there is an error message, show it in the title
                finalTitle = error
                bgColor = UIColor.systemRed
            } else {
                // Show success message
                finalTitle = successTitle
                bgColor = UIColor.systemGreen
            }
            
            self?.showAndDismiss(
                title: finalTitle,
                subtitle: subtitle,
                duration: 3,
                backgroundColor: bgColor,
                titleColor: .white
            )
        }
    }


    
}



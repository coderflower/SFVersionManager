//
//  SFVersionManager.swift
//  Pods-SFVersionManager_Example
//
//  Created by 花菜 on 2018/10/29.
//

import UIKit

open class SFVersionManager: NSObject {
    
    struct SFVersionModel: Codable {
        let resultCount: Int
        let results: [Model]
        struct Model: Codable {
            let version: String
            let trackViewUrl: String
            let trackId: Int64
            let releaseNotes: String?
        }
    }
    public static let `shared` = SFVersionManager()
    /// 设置所在区域, 例如 中国地区 countryAbbreviation = "cn",
    open var countryAbbreviation: String?
    private var alertTitle: String = "发现新版本"
    private var nextTimeTitle: String = "下次提示"
    private var confirmTitle: String = "前往更新"
    /// 跳过当前 app store 版本
    private var skipVersionTitle: String? = nil
    
    /// 版本更新检查
    ///
    /// - Parameters:
    ///   - alertTitle: 弹窗标题
    ///   - nextTimeTitle: nextTimeTitle
    ///   - confirmTitle: confirmTitle
    ///   - skipVersionTitle: skipVersionTitle
    public func checkVersion(_ alertTitle: String = "发现新版本", nextTimeTitle: String = "下次提示", confirmTitle: String = "前往更新", skipVersionTitle: String? = nil) {
        self.alertTitle = alertTitle
        self.nextTimeTitle = nextTimeTitle
        self.confirmTitle = confirmTitle
        self.skipVersionTitle = skipVersionTitle
        fetchAppInfoFromAppStore()
    }
    
    private static let NORMAL_MODE_CHECK_URL = "https://itunes.apple.com/lookup?bundleId=%@&timestamp=%ld"
    private lazy var bundleIdentifier: String = {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "1"
    }()
    private var currentVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    /// 从 appstore 获取最新的版本信息
    private func fetchAppInfoFromAppStore() {
        /// 获取时间戳
        let urlString: String
        let timeStamp = Int64(Date().timeIntervalSince1970)
        if let countryAbbreviation = countryAbbreviation {
            urlString = String(format: "https://itunes.apple.com/lookup?country=%@&bundleId=%@&timestamp=%ld", countryAbbreviation, bundleIdentifier, timeStamp)
        } else {
            urlString = String(format: "https://itunes.apple.com/lookup?bundleId=%@&timestamp=%ld", bundleIdentifier, timeStamp)
        }
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        let dataTask = URLSession.shared.dataTask(with: request) {[weak self](data, response, error) in
            guard let `self` = self else { return }
            guard let response = response as? HTTPURLResponse  else {
                return
            }
            
            if  response.statusCode == 200, let data = data {
                guard let model = try? JSONDecoder().decode(SFVersionModel.self, from: data) else {
                    return
                }
                guard model.resultCount == 1, let versionModel = model.results.first else {
                    return
                }
                /// 获取跳过的版本, 判断跳过的版本与appstore 版本是否相同
                let flag1 = UserDefaults.standard.string(forKey: "SKIPVERSION") == versionModel.version
                
                /// 判断当前版本与appstore 版本是否相同
                let flag2 = (versionModel.version == self.currentVersion)
                
                /// 当前版本与appstore 版本不同 并且不跳过该版本才弹窗提示用户
                if !flag1 && !flag2 {
                    DispatchQueue.main.async {
                        if self.compareVersion(versionModel.version, currentVersion: self.currentVersion) {
                            self.showAlert(versionModel)
                        }
                    }
                }
            }
            
        }
        dataTask.resume()
        
    }
    
    /// 弹窗提示用户有更新
    ///
    /// - Parameter model: model
    private func showAlert(_ model: SFVersionModel.Model) {
        
        let alertController = UIAlertController(title: alertTitle, message: model.releaseNotes, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: nextTimeTitle, style: .default, handler: nil)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (_) in
            /// 打开 App Store
            self.openAppStore(model.trackViewUrl)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        if let skipVersionTitle = skipVersionTitle {
            let skipVersionAction = UIAlertAction(title: skipVersionTitle, style: .cancel) { (_) in
                /// 记录跳过的版本
                UserDefaults.standard.set(model.version, forKey: "SKIPVERSION")
                UserDefaults.standard.synchronize()
            }
            alertController.addAction(skipVersionAction)
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    /// 在 App Store 中打开
    ///
    /// - Parameter urlString: urlString
    private func openAppStore(_ urlString: String) {
        /// 判断 url 是否正确
        guard let url = URL(string: urlString) else {
            return
        }
        /// 判断能否打开
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.openURL(url)
        
    }
    /// 比较两个版本
    ///
    /// - Parameters:
    ///   - lastVersion: 最新版本
    ///   - currentVersion: 当前版本
    /// - Returns: 是否需要提示更新
    private func compareVersion(_ lastVersion: String, currentVersion: String) -> Bool {
        return currentVersion.compare(lastVersion) == ComparisonResult.orderedAscending
    }
    
}



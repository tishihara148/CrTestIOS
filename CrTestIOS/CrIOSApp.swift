//
//  CrashIOSApp.swift
//  CrashIOS
//
//  Created by aeidev on 6/22/23.
//

import SwiftUI
import os.log

@main
struct CrIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        file_init()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func file_init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = dir.appendingPathComponent("sb_log.txt")
        if (file_size(filePath) > 1000000) {
            let fromFile = dir.appendingPathComponent("sb_log.txt")
            let toFile = dir.appendingPathComponent("sb_log_old.txt")
            print("fromFile file path: \(fromFile.path)")
            print("toFile file path: \(toFile.path)")
            if (file_exist(toFile)) {
                let rc = file_delete(toFile)
            }
            do {
                try FileManager.default.moveItem(at: fromFile, to: toFile)
                print("File renamed successfully")
            } catch {
                print("Error renaming file: \(error)")
            }
        }
        let filePath2 = dir.appendingPathComponent("sb_log.txt")
        os_log("TNI os_log")

        
        let settingsFilePath = dir.appendingPathComponent("settings.txt")
        if (file_exist(settingsFilePath) == false) {
            let def_settings:String = "ServerURL=https://dev.screenbeam.com"
            let rc = file_write(settingsFilePath, contents:def_settings)
            print("file_wrete rc=\(rc)")
        }
        print("file_read")
        let str = file_read(settingsFilePath)
        print("str=\(String(describing: str))")

        //freopen(filePath2.path.cString(using: .ascii), "a+", stdout)
        //freopen(filePath2.path.cString(using: .ascii), "a+", stderr)
    }
    
    func file_exist(_ fileURL:URL) -> Bool {
        // Check if the file exists
        return FileManager.default.fileExists(atPath: fileURL.path)
    }

    func file_delete(_ fileURL:URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("File deleted successfully")
        } catch {
            print("Error deleting file: \(error)")
            return false
        }
        return true
    }

    func file_size(_ fileURL:URL) -> Int {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            let fileSize = fileAttributes[.size] as? NSNumber
            print("file size: \(fileSize!) bytes")
            return fileSize as! Int
        } catch {
            print("Error getting file attributes: \(error)")
        }
        return 0
    }
    
    func file_read(_ fileURL:URL) -> String? {
        do {
            // Read the file contents
            let contents = try String(contentsOf: fileURL)
            return contents
        } catch {
            print("Unable to read file: \(error)")
            return nil
        }
    }
    
    func file_write(_ fileURL:URL, contents:String) -> Bool {
        do {
            try contents.write(to: fileURL, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Unable to write file: \(error)")
            return false
        }
    }

}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        return true
    }
}

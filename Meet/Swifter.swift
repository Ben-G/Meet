#!/usr/bin/swift

import Foundation

func isSwiftFile(url: NSURL) -> Bool {
    let filename = String(url)
    let fileNameComponents = filename.characters.split { $0 == "." }

    if fileNameComponents.count > 0 {
        if String(fileNameComponents.last!) == "swift" {
            return true
        }
    }

    return false
}

func appendNewLineToEndOfFileIfMissing(url: NSURL) {
    let fileHandle = try! NSFileHandle(forUpdatingURL: url)
    let offset = fileHandle.seekToEndOfFile()
    let lastCharacterOffset = offset - 1
    fileHandle.seekToFileOffset(lastCharacterOffset)

    let data = fileHandle.readDataToEndOfFile()
    let string = NSString(data: data, encoding: NSUTF8StringEncoding)
    print("End of file")

    if string == "\n" {
        print("Is new line")
    } else {
        print("Is other character: \(string)")
        let data = "\n".dataUsingEncoding(NSUTF8StringEncoding)
        fileHandle.writeData(data!)
    }
}

func addNewLinesToEndOfEachFile(inDirectory: String) {
    let sourceCodePath = NSFileManager.defaultManager().currentDirectoryPath + "/" + inDirectory
    let url = NSURL(string: sourceCodePath)

    guard let sourceCodeURL = url else {
        print("Input argument is not a directory!")
        return
    }

    let fileManager = NSFileManager()
    let enumerator = fileManager.enumeratorAtURL(sourceCodeURL,
        includingPropertiesForKeys: [NSURLIsDirectoryKey], options: [], errorHandler: nil)

    guard let sourceCodePathEnumerator = enumerator else {
        print("Input argument is not a directory!")
        return
    }

    for path in sourceCodePathEnumerator {
        let pathURL = path as! NSURL
        var isFile: AnyObject?

        try! pathURL.getResourceValue(&isFile, forKey: NSURLIsRegularFileKey)

        if let isFile = isFile as? Bool where isFile == true && isSwiftFile(pathURL) {
            appendNewLineToEndOfFileIfMissing(pathURL)
        }
    }
}

if (Process.arguments.count < 2) {
    exit(0)
} else {
    addNewLinesToEndOfEachFile(Process.arguments[1])
}

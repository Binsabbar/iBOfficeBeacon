import Foundation

class FileUtilHelper {
    
    static let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    let searchDir: String
    
    init(searchDirectory: String) {
        searchDir = searchDirectory
    }
    
    func hasContent(_ content: String, beenWrittenToFile theFile: String) -> Bool {
        if let path = filePath(theFile) {
            let fileContent = stringFromFile(path as NSString)
            return fileContent.compare(content) == .orderedSame
        }
        return false
    }
    
    func deleteFile(_ theFile: String) {
        let fileManager = FileManager.default
        
        if let path = filePath(theFile) {
            do {
                try fileManager.removeItem(atPath: path)
            }
            catch let error as NSError {
                print("Something went wrong: \(error)")
            }
        }
    }
    
    func changeFile(_ theFile: String, modifiedDateToDate date: Date) {
        let fileManager = FileManager.default
        do {
            try fileManager.setAttributes([FileAttributeKey.modificationDate: date],
                                          ofItemAtPath: filePath(theFile)!)
        } catch{}
    }
    
    func assertFileIsDeleted(_ theFile: String) {
        let fileManager = FileManager.default
        if let path = filePath(theFile) {
            assert(!fileManager.fileExists(atPath: path), "File should be deleted after the test")
        }
    }
    
    func writeString(_ string: String, toFile theFile: String) {
        
        do {
            if let path = filePath(theFile) {
                try string.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            }
        } catch {
            assertionFailure("Could not write the file")
        }
    }
    
    func stringFromFile(_ file: NSString)-> NSString {
        do {
            return try NSString(contentsOfFile: file as String, encoding: String.Encoding.utf8.rawValue)
        } catch {return ""}
    }
    
    //MARK: Private helpers
    fileprivate func filePath(_ file: String) -> String? {
        return (searchDir as NSString).appendingPathComponent(file)
    }
}

func hasContent(_ content: String, beenWrittenToFile theFile: String) -> Bool {
    if let path = file(theFile, inDirectory: .documentDirectory) {
        let fileContent = stringFromFile(path as NSString)
        return fileContent.compare(content) == .orderedSame
    }
    return false
}

func deleteFile(_ theFile: String) {
    let fileManager = FileManager.default
    
    if let path = file(theFile, inDirectory: .documentDirectory) {
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Something went wrong: \(error)")
        }
    }
}

func changeFile(_ theFile: String, modifiedDateToDate date: Date) {
    let fileManager = FileManager.default
    do {
        try fileManager.setAttributes([FileAttributeKey.modificationDate: date],
                                      ofItemAtPath: file(theFile, inDirectory: .documentDirectory)!)
    } catch{}
}

func assertFileIsDeleted(_ theFile: String) {
    let fileManager = FileManager.default
    if let path = file(theFile, inDirectory: .documentDirectory) {
        assert(!fileManager.fileExists(atPath: path), "File should be deleted after the test")
    }
}

func writeString(_ string: String, toFile theFile: String) {
    
    do {
        if let path = file(theFile, inDirectory: .documentDirectory) {
            try string.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        }
    } catch {
        assertionFailure("Could not write the file")
    }
}

func stringFromFile(_ file: NSString)-> NSString {
    do {
        return try NSString(contentsOfFile: file as String, encoding: String.Encoding.utf8.rawValue)
    } catch {return ""}
}

//MARK: Private helpers
private func file(_ file: String, inDirectory directory: FileManager.SearchPathDirectory) -> String? {
    if let dir: NSString = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first as! NSString
    {
        return dir.appendingPathComponent(file)
    }
    return nil
}

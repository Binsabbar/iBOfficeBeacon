import Foundation

class FileUtilHelper {
    
    static let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    
    let searchDir: String
    
    init(searchDirectory: String) {
        searchDir = searchDirectory
    }
    
    func hasContent(content: String, beenWrittenToFile theFile: String) -> Bool {
        if let path = filePath(theFile) {
            let fileContent = stringFromFile(path)
            return fileContent.compare(content) == .OrderedSame
        }
        return false
    }
    
    func deleteFile(theFile: String) {
        let fileManager = NSFileManager.defaultManager()
        
        if let path = filePath(theFile) {
            do {
                try fileManager.removeItemAtPath(path)
            }
            catch let error as NSError {
                print("Something went wrong: \(error)")
            }
        }
    }
    
    func changeFile(theFile: String, modifiedDateToDate date: NSDate) {
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.setAttributes([NSFileModificationDate: date],
                                          ofItemAtPath: filePath(theFile)!)
        } catch{}
    }
    
    func assertFileIsDeleted(theFile: String) {
        let fileManager = NSFileManager.defaultManager()
        if let path = filePath(theFile) {
            assert(!fileManager.fileExistsAtPath(path), "File should be deleted after the test")
        }
    }
    
    func writeString(string: String, toFile theFile: String) {
        
        do {
            if let path = filePath(theFile) {
                try string.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            }
        } catch {
            assertionFailure("Could not write the file")
        }
    }
    
    func stringFromFile(file: NSString)-> NSString {
        do {
            return try NSString(contentsOfFile: file as String, encoding: NSUTF8StringEncoding)
        } catch {return ""}
    }
    
    //MARK: Private helpers
    private func filePath(file: String) -> String? {
        return (searchDir as NSString).stringByAppendingPathComponent(file)
    }
}

func hasContent(content: String, beenWrittenToFile theFile: String) -> Bool {
    if let path = file(theFile, inDirectory: .DocumentDirectory) {
        let fileContent = stringFromFile(path)
        return fileContent.compare(content) == .OrderedSame
    }
    return false
}

func deleteFile(theFile: String) {
    let fileManager = NSFileManager.defaultManager()
    
    if let path = file(theFile, inDirectory: .DocumentDirectory) {
        do {
            try fileManager.removeItemAtPath(path)
        }
        catch let error as NSError {
            print("Something went wrong: \(error)")
        }
    }
}

func changeFile(theFile: String, modifiedDateToDate date: NSDate) {
    let fileManager = NSFileManager.defaultManager()
    do {
        try fileManager.setAttributes([NSFileModificationDate: date],
                                      ofItemAtPath: file(theFile, inDirectory: .DocumentDirectory)!)
    } catch{}
}

func assertFileIsDeleted(theFile: String) {
    let fileManager = NSFileManager.defaultManager()
    if let path = file(theFile, inDirectory: .DocumentDirectory) {
        assert(!fileManager.fileExistsAtPath(path), "File should be deleted after the test")
    }
}

func writeString(string: String, toFile theFile: String) {
    
    do {
        if let path = file(theFile, inDirectory: .DocumentDirectory) {
            try string.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        }
    } catch {
        assertionFailure("Could not write the file")
    }
}

func stringFromFile(file: NSString)-> NSString {
    do {
        return try NSString(contentsOfFile: file as String, encoding: NSUTF8StringEncoding)
    } catch {return ""}
}

//MARK: Private helpers
private func file(file: String, inDirectory directory: NSSearchPathDirectory) -> String? {
    if let dir: NSString = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true).first
    {
        return dir.stringByAppendingPathComponent(file)
    }
    return nil
}

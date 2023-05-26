

import Foundation
import CoreText
import RswiftResources

public typealias DalculatorFont = _R.font

public extension DalculatorFont {

    static func register() throws {
        let filteredFonts = R.font.filter{ !$0.canBeLoaded() }
        guard !filteredFonts.isEmpty else { return }
        var errorArray = [Error]()
        errorArray.reserveCapacity(filteredFonts.count)
        let fontURLs:[URL] = filteredFonts.compactMap{
            guard let url = $0.bundle.url(forResource: $0.filename, withExtension: nil)
            else {
                errorArray.append(
                    CocoaError(
                        .fileNoSuchFile,
                        userInfo: [
                            NSLocalizedDescriptionKey : "\($0.filename)을 찾을 수 없습니다. \($0.bundle.bundlePath)에 해당 파일이 존재하지 않습니다.",
                        ]
                    )
                )
                return nil
            }
            return url
        }
        if #available(iOS 13.0, tvOS 13.0, macCatalyst 13.1, watchOS 6.0, macOS 10.15, *) {
            let sema = DispatchSemaphore(value: 0)
            CTFontManagerRegisterFontURLs(fontURLs as CFArray, .process, false) { errors, done in
                print(errors)
                if (done) {
                    errorArray.append(contentsOf: errors as! [CFError])
                    sema.signal()
                }
                return true
            }
            sema.wait()
            if let error = errorArray.randomElement() {
                throw error
            }
        } else {
            var errorPointer = nil as Unmanaged<CFArray>?
            guard CTFontManagerRegisterFontsForURLs(fontURLs as CFArray, .process, &errorPointer)
            else {
                errorArray.append(contentsOf: errorPointer.unsafelyUnwrapped.takeRetainedValue() as! [CFError])
                throw errorArray.randomElement().unsafelyUnwrapped
            }
        }
    }

}

public extension FontResource {
     func registerIfNeeded() throws {
        guard !canBeLoaded() else { return }
        guard
            let url = bundle.url(forResource: filename, withExtension: nil)
        else {
            throw CocoaError(
                .fileNoSuchFile,
                userInfo: [
                    NSLocalizedDescriptionKey : "\(filename)을 찾을 수 없습니다. \(bundle.bundlePath)에 해당 파일이 존재하지 않습니다.",
                ]
            )
        }
        var errorPointer = nil as Unmanaged<CFError>?
        guard CTFontManagerRegisterFontsForURL(url as CFURL, .process, &errorPointer)
        else {
            throw errorPointer.unsafelyUnwrapped.takeRetainedValue()
        }
    }
}

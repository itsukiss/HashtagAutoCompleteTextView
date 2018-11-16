//
//  UITextView+Rx.swift
//  HashTagAutoCompleteTextView
//
//  Created by 田中 厳貴 on 2018/11/16.
//  Copyright © 2018年 田中 厳貴. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITextView {
    
    var hashtag: Observable<(String?, String.Index?, String.Index?)> {
        return base.rx.text.map { text -> (String?, String.Index?, String.Index?) in
            let offset = self.base.selectedRange.location
            if let text = text, offset > 0 {
                let startIndex = text.startIndex
                let targetIndex = text.index(startIndex, offsetBy: offset - 1)
                let separatedSpaceText = text[startIndex...targetIndex].components(separatedBy: " ")
                let separatedNewLinesText = Array(separatedSpaceText.compactMap { text in
                    return text.components(separatedBy: "\n")
                    }.joined())
                if let targetWord = separatedNewLinesText.last {
                    if targetWord.contains("#"), let hashtagText = targetWord.components(separatedBy: "#").last {
                        let hashtagStartIndex = text.index(startIndex, offsetBy: offset - hashtagText.count)
                        let hashtagEndIndex = text.index(startIndex, offsetBy: offset)
                        return (hashtagText, hashtagStartIndex, hashtagEndIndex)
                    }
                }
            }
            return (nil, nil, nil)
        }
    }
}

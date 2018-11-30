//
//  UITextViewExtension.swift
//  HashTagAutoCompleteTextView
//
//  Created by 田中 厳貴 on 2018/11/16.
//  Copyright © 2018年 田中 厳貴. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func setHashTag(_ hashtag: String?, start: String.Index?, end: String.Index?) {
        guard let hashtag = hashtag, let startIndex = start, let endIndex = end, endIndex <= self.text.endIndex else { return }
        
        if startIndex != endIndex {
            let newText = self.text.replacingCharacters(in: startIndex..<endIndex, with: hashtag + " ")
            self.text = newText
            // ハッシュタグ挿入後に挿入した単語の後にキャレットが移動するように設定
            self.selectedRange = NSRange(location: startIndex.encodedOffset + hashtag.count + 1, length: 0)
        } else {
            var newText = self.text
            newText?.insert(contentsOf: hashtag + " ", at: startIndex)
            self.text = newText
            self.selectedRange = NSRange(location: startIndex.encodedOffset + hashtag.count + 1, length: 0)
        }
    }
}

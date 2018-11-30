//
//  HashTagAutoCompleteViewModel.swift
//  HashTagAutoCompleteTextView
//
//  Created by 田中 厳貴 on 2018/11/16.
//  Copyright © 2018年 田中 厳貴. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HashTagAutoCompleteViewModel {
    
    
    var hashtags: Observable<[(String?, String.Index?, String.Index?)]>
    var isCoverViewHidden: Driver<Bool>
    var isTableViewHidden: Driver<Bool>
    private let disposeBag = DisposeBag()
    
    typealias Input = (
        inputHashTag: Observable<(String?, String.Index?, String.Index?)>,
        isFocus: Driver<Bool>
    )
    
    init(input: Input) {
        let hashtagsRelay = BehaviorRelay<[(String?, String.Index?, String.Index?)]>(value: [])
        hashtags = hashtagsRelay.asObservable()
        
        input.inputHashTag.map { (inputText, startIndex, endIndex) -> [(String, String.Index?, String.Index?)] in
            guard let inputText = inputText else { return []}
            let searchData = HashTagStore.shared.mockData.filter { text in
                return text.lowercased().hasPrefix(inputText)
                }.map{ text in
                return ("#\(text)", startIndex, endIndex)
            }
            return searchData
        }
        .asObservable()
        .bind(to: hashtagsRelay)
        .disposed(by: disposeBag)
        
        isCoverViewHidden = input.isFocus.map { !$0 }
        isTableViewHidden = Observable.merge(
            hashtags.map { $0.isEmpty },
            input.isFocus.map { isFocus in
                return !(isFocus && !hashtagsRelay.value.isEmpty)
            }.asObservable()
        ).asDriver(onErrorJustReturn: true)
    }
}

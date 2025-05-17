//
//  CloudViewModel.swift
//  CineVisionAI
//
//  Created by Umut Kaya Ergüler on 17.05.2025.
//

import SwiftUI

class CloudViewModel: BaseViewModel {
    @Published var selectedImage: UIImage?
    @Published var summaryText: String = ""
    @Published var predictedGenresForOutput: [String] = []
    @Published var showOutputView = false

    func uploadPoster() {
        guard let image = selectedImage else {
            showToast("Önce bir görsel seçin.")
            return
        }
        isLoading = true
        
        //TODO: BURADA FlorenceFirstRequestModel ILE ILK ISTEGE CIKILACAK
        CloudService.shared.uploadPoster(image: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let caption):
                    self?.showToast("İşlem Başarılı")
                    print(caption)
                    //TODO: BURADA FLORENCESECONDREQUESTMODEL ILE IKINCI ISTEGIN ICI DOLDURULACAK
                    //ARDINDAN IKINCI ISTEGE CIKILACAK IKISI DE BURADA YAPILACAK
                case .failure(let error):
                    self?.showToast(error.localizedDescription)
                }
            }
        }
    }
}

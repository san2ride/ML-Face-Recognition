//
//  FaceDetectionView.swift
//  FaceRecognitionML
//
//  Created by Cause  I'm Electric on 3/4/24.
//

import SwiftUI
import Vision

struct FaceDetectionView: View {
    
    let photos = ["face","friends-sitting","people-sitting","ball","bird"]
    
    @State private var currentIndex: Int = 0
    @State private var classificationLabel: String = ""
    
    private func detectFaces(completion: @escaping ([VNFaceObservation]?) -> Void) {
        guard let image = UIImage(named: photos[currentIndex]),
              let cgImage = image.cgImage,
              let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else {
            return completion(nil)
        }
        let request = VNDetectFaceRectanglesRequest()
        
        let handler = VNImageRequestHandler(cgImage: cgImage,
                                            orientation: orientation,
                                            options: [:])
        DispatchQueue.global().async {
            try? handler.perform([request])
            
            guard let observations = request.results else {
                return completion(nil)
            }
            completion(observations)
        }
    }
    
    var body: some View {
        VStack {
            Image(photos[currentIndex])
            .resizable()
                .frame(width: 200, height: 200)
            HStack {
                Button("Previous") {
                    
                    if self.currentIndex >= self.photos.count {
                        self.currentIndex = self.currentIndex - 1
                    } else {
                        self.currentIndex = 0
                    }
                    
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .frame(width: 100)
                
                Button("Next") {
                    if self.currentIndex < self.photos.count - 1 {
                        self.currentIndex = self.currentIndex + 1
                    } else {
                        self.currentIndex = 0
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .frame(width: 100)
                .background(Color.gray)
                .cornerRadius(10)
            
            }.padding()
            
            Button("Classify") {
                // classify the image here
                self.detectFaces { results in
                    if let results = results {
                        // update the UI
                        DispatchQueue.main.async {
                            self.classificationLabel = "Faces: \(results.count)"
                            print(classificationLabel)
                        }
                    }
                }
                
            }.padding()
            .foregroundColor(Color.white)
            .background(Color.green)
            .cornerRadius(8)
            
            Text(classificationLabel)
        }
    }
}

#Preview {
    FaceDetectionView()
}

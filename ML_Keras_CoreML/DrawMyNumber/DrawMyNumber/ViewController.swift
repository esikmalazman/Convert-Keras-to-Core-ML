import UIKit
import Vision

final class ViewController: UIViewController {
    
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var predictLabel: UILabel!
    
    // TODO: Define lazy var classificationRequest
    lazy var classificationRequest : VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MNISTClassifier().model)
            return VNCoreMLRequest(model: model) { request, error in
                self.handleClassification(request, error: error)
            }
        } catch {
            fatalError("Couldn't load Vision ML Model : \(error.localizedDescription)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predictLabel.isHidden = true
    }
    
    func handleClassification(_ request : VNRequest, error : Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Unexpected result type from VNCoreMLRequest.")
        }
        
        guard let bestResult = results.first else {
            fatalError("Can't get best result.")
        }
        
        DispatchQueue.main.async {
            self.predictLabel.text = bestResult.identifier
            self.predictLabel.isHidden = false
        }
    }
    
    @IBAction func clearTapped() {
        drawView.lines = []
        drawView.setNeedsDisplay()
        predictLabel.isHidden = true
    }
    
    @IBAction func predictTapped() {
        guard let context = drawView.getViewContext(),
              let inputImage = context.makeImage()
        else { fatalError("Get context or make image failed.") }
        
        // Perform request on model
        print("Get context and make image succeeded.")
        let ciImage = CIImage(cgImage: inputImage)
        let handler = VNImageRequestHandler(cgImage: inputImage)
        
        do {
            try handler.perform([classificationRequest])
        } catch {
            print("Error perform classfication request : \(error.localizedDescription)")
        }
    }
}


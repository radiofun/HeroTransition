import SwiftUI
import UIKit


class HeroAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let imageView: UIImageView
    
    init(imageView: UIImageView) {
        self.imageView = imageView
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromImageView = fromVC.view.viewWithTag(100) as? UIImageView,
              let toImageView = toVC.view.viewWithTag(100) as? UIImageView else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        // Hide the original image views
        fromImageView.isHidden = true
        toImageView.isHidden = true
        
        let snapshot = UIImageView(image: fromImageView.image)
        snapshot.contentMode = fromImageView.contentMode
        snapshot.frame = containerView.convert(fromImageView.frame, from: fromImageView.superview)
        snapshot.layer.cornerRadius = fromImageView.layer.cornerRadius
        snapshot.clipsToBounds = true
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        
        
        let finalFrame = containerView.convert(toImageView.frame, from: toImageView.superview)
        let finalCornerRadius = toImageView.layer.cornerRadius
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1.6,
                       options: [],
                       animations: {
            snapshot.frame = finalFrame
            snapshot.layer.cornerRadius = finalCornerRadius
            toVC.view.alpha = 1
        }) {  _ in
                // Clean up after both animations are complete
                snapshot.removeFromSuperview()
                fromImageView.isHidden = false
                toImageView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }

class FirstHeroViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let image = UIImage(named: "launcher")
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageView()
    }
    
    func setupImageView() {
        imageView.tag = 100
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: view.bounds.width/2 - 120, y: 360, width: 240, height: 200)
        imageView.layer.cornerRadius = 12
        view.addSubview(imageView)
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 10
        imageView.layer.masksToBounds = true // Allow the shadow to extend beyond the bounds
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentSecondVC))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
        
    @objc func presentSecondVC() {
        let secondVC = SecondHeroViewController()
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.transitioningDelegate = self
        present(secondVC, animated: true, completion: nil)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HeroAnimator(imageView: imageView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HeroAnimator(imageView: imageView)
    }
}

class SecondHeroViewController: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "launcher"))
    private var originalPosition: CGPoint?
    private var isDismissing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.masksToBounds = true
        setupImageView()
        setupPanGesture()
    }
    
    func setupImageView() {
        imageView.tag = 100
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: -20, width: view.bounds.width, height: 400)
        view.addSubview(imageView)
        
        let textView = UITextView(frame: CGRect(x: 14, y: 400, width: view.bounds.width, height: 100))
        textView.text = "The Last of Us Part II : Remastered"
        textView.font = .systemFont(ofSize:32 , weight: .bold)
        textView.textAlignment = .left
        textView.backgroundColor = .black
        textView.textColor = .white
        view.addSubview(textView)
        
        let textView2 = UITextView(frame: CGRect(x: 14, y: 480, width: view.bounds.width, height: 200))
        textView2.text = "Sony Interactive Entertainment"
        textView2.font = .systemFont(ofSize:16 , weight: .bold)
        textView2.textAlignment = .left
        textView2.backgroundColor = .black
        textView2.textColor = .white
        textView2.alpha = 0.5
        view.addSubview(textView2)
        
        let subheader = UITextView(frame: CGRect(x: 14, y: 520, width: view.bounds.width-28, height: 200))
        subheader.text = "Five years after their dangerous journey across the post-pandemic United States, Ellie and Joel have settled down in Jackson, Wyoming. Living amongst a thriving community of survivors has allowed them peace and stability, despite the constant threat of the infected and other, more desperate survivors."
    
        subheader.textAlignment = .left
        subheader.font = .systemFont(ofSize:16 , weight: .regular)
        subheader.backgroundColor = .black
        subheader.textColor = .white
        subheader.alpha = 0.8
        view.addSubview(subheader)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            originalPosition = view.center
            UIView.animate(.spring(duration:0.1)) {
                self.view.layer.cornerRadius = 40
            }

        case .changed:
            guard let originalPosition = originalPosition else { return }
            view.center = CGPoint(x: originalPosition.x + translation.x, y: originalPosition.y + translation.y)
        case .ended:
            if translation.y > 100 || translation.x > 100 {
                // Trigger dismiss if dragged downward more than 100 pixels
                isDismissing = true
                dismiss(animated: true, completion: nil)
            } else {
                // Animate back to original position
                UIView.animate(.spring(duration:0.1)){
                    self.view.center = self.originalPosition ?? self.view.center
                }
            }
        default:
            break
        }
    }
}
struct HeroViewTest: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FirstHeroViewController {
        return FirstHeroViewController()
    }
    
    func updateUIViewController(_ uiViewController: FirstHeroViewController, context: Context) {
    }
}

#Preview {
    HeroViewTest()
        .ignoresSafeArea()
}

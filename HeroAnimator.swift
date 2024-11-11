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
        
        fromImageView.isHidden = true
        toImageView.isHidden = true
        
        let snapshot = UIImageView(image: fromImageView.image)
        snapshot.contentMode = fromImageView.contentMode
        snapshot.frame = containerView.convert(fromImageView.frame, from: fromImageView.superview)
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        
        toVC.view.alpha = 0
        
        let finalFrame = containerView.convert(toImageView.frame, from: toImageView.superview)
        
        UIView.animate(withDuration: duration, animations: {
            snapshot.frame = finalFrame
            toVC.view.alpha = 1
        }) { _ in
            snapshot.removeFromSuperview()
            fromImageView.isHidden = false
            toImageView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class FirstHeroViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let imageView = UIImageView(image: UIImage(named: "001"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageView()
    }
    
    func setupImageView() {
        imageView.tag = 100
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        view.addSubview(imageView)
        
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
    let imageView = UIImageView(image: UIImage(named: "001"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupImageView()
    }
    
    func setupImageView() {
        imageView.tag = 100
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 150, width: view.bounds.width, height: 300)
        view.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

struct PreviewHeroView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FirstHeroViewController {
        return FirstHeroViewController()
    }
    
    func updateUIViewController(_ uiViewController : FirstHeroViewController, context: Context) {
        
    }
}

#Preview {
    PreviewHeroView()
}

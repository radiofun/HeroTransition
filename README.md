# HeroTransition

A UIKit implementation of a hero image transition between view controllers, using a snapshot-based animation technique.

## Overview

`HeroAnimator` conforms to `UIViewControllerAnimatedTransitioning` and produces a smooth "shared element" transition. It captures a snapshot of the source image view, flies it across the screen to the destination frame using spring physics, and reveals the destination view controller underneath.

## Features

- Shared-element hero transition for `UIImageView`
- Snapshot-based animation (no view hierarchy hacking)
- Spring animation with damping 0.9 and initial velocity 1.6 for a natural feel
- Animates both frame, corner radius, and alpha simultaneously
- Views are tagged (tag `100`) for easy source/destination lookup
- 0.3 s transition duration

## Tech Stack

- **Swift** — UIKit, `UIViewControllerAnimatedTransitioning`
- **UIKit** — `UIView.animate(withDuration:usingSpringWithDamping:...)`

## Requirements

- Xcode 14+
- iOS 15+

## Usage

1. Add `HeroAnimator.swift` to your project.
2. Tag the source `UIImageView` and the destination `UIImageView` both with tag `100`.
3. Return a `HeroAnimator` instance from your `UINavigationControllerDelegate` or `UIViewControllerTransitioningDelegate`:

```swift
func animationController(forPresented presented: UIViewController,
                         presenting: UIViewController,
                         source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return HeroAnimator(imageView: selectedImageView)
}
```

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.

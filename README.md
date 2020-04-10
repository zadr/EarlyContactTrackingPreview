#### What
A stubbed-out implementation of Apple's [Contact Tracing](https://www.apple.com/covid19/contacttracing) [Framework API](https://covid19-static.cdn-apple.com/applications/covid19/current/static/contact-tracing/pdf/ContactTracing-FrameworkDocumentation.pdf) (as of April 10, 2020) to help track anonymously track contact with people who have contracted COVID-19.

#### Why
The ideas discussed in the framework seemed neat, and the framework wasn't available yet. What better way to learn how something works than to implement it?

Maybe you're curious how it works as well? Maybe you want to make an app based off of this framework and don't want to wait? Etc.

#### How to use
This module isn't and probably won't be published; add `pod 'EarlyContactTrackingPreview', :git => 'git@github.com:zadr/EarlyContactTrackingPreview.git'` to your Podfile.

See [`Tests/Flow.m`](https://github.com/zadr/EarlyContactTrackingPreview/blob/main/Tests/Flow.m) for my best understanding of how the API is intended to be used. It is possible I'm wrong— caveat developer— or that the API changes. If so, please let me know or file an issue on GitHub or something.

#### How to develop
The `xcworkspace` here is generated from the `podspec` through [`cocoapods-generate`](https://github.com/square/cocoapods-generate), please install it if you want to explore with Xcode.

```
$ gem install cocoapods-generate
$ pod gen
$ xed gen/EarlyContactTrackingPreview
```

#### License
I don't know. I didn't make this API. I claim no ownership over stub implementations. MIT License if you need to write something down.

The goal here is to be open to learn + protoyping usage and not closed for any reason.

#<img valign='top' src="https://what3words.com/assets/images/w3w_square_red.png" width="64" height="64" alt="what3words">&nbsp;w3w-swift-components-sdk

Overview
--------

what3words publishes a compoonents library on GitHub:

[https://github.com/what3words/w3w-swift-components](https://github.com/what3words/w3w-swift-components) 

Out of the box, it is designed to work with the what3words API.  

This package, however, will extend the functionality of the Swift SDK xcframework so that it can use the components in the component library the same as the API does.

Include this in your project, and it will provide the protocol extensions and cause the download of the `w3w-swift-components` as a dependancy.

Technical Details
-----------------

what3words' SDK is a self contained framework of Swift code for 3 word addresses functionality.

Objects in the SDK are prefixed with `W3WSdk`, for example, `W3WSdkSuggestion`, `W3WSdkOption`, etc...  Objects in the API are prefixed with `W3WApi`, such as `W3WApiSuggestion` and `W3WApiSquare`.  Both the SDK's and the API's objects conform to our "main" protocols, eg: `W3WSuggestion`, `W3WOption`, `W3WSquare`, etc...

This package contains SdkToApiBridge.swift which ensures the classes in the SDK conform to these "main" protocols.

All the components code uses only the protocols and this allows both the API and the SDK to employ it.
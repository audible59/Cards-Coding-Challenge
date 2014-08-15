Cards-Coding-Challenge
======================

NOTE: This application was built for iPhone 4-inch models running iOS 7.1.
      Xcode version 5.1.1 was used as the IDE for development.

Instructions for running the Card Coding Challenge iOS Application within Xcode 5.X:

i.) Open the CardsCodingChallenge.xcodeproj within Xcode version 5.X.

ii.) Within the Target's Build Setting properly setup the Code Signing Provisioning Profiles and Code Signing Identities as needed to run the application on a physical iPhone 4-inch model device.
     a.) This application can also run on the iPhone Retina (4-inch) and iPhone Retina (4-inch 64-bit) simulators.
     
iii.) Clean and Build the Project.

iv.) Run the project to deploy and run the application on the device or simulator.

Instruction for using the Card Coding Challenge iOS Application within the device or Simulator

i.) After the application has been launched the Main View will display a Scroll View at the bottom of the screen and a Button titled "Open" at the top right hand corner of the screen.
    a.) Scroll View
        - The user can swipe to the left and the right to scroll through the blank image cards.
        - The user can swipe down to partially hide the scroll view and swipe up to show the scroll view.
          -- When the scroll view is swiped down the label titled "Hello" will fade into the center of the Main view
          -- Wehn the scroll view is swiped up the label titled "Hello" will fade out of the Main view
    b.) Button
        - The user can press the button titled "Close" to open the Menu View
        
ii.) When the Menu View is presented five buttons will animate into the Menu View with a button title "Close" at the top right of the screen.
    a.) Button title "Close"
        - The user can press the button title "Close" to close the Menu View and go back to the Main View
        - The other five buttons will not do anything upon pressing them.

Cards-Coding-Challenge
======================

NOTE: This application was built for iPhone 4-inch models running iOS 7.1.
      Xcode version 5.1.1 was used as the IDE for development.

Instructions for running the Card Coding Challenge iOS Application within Xcode 5.X:

<ol>
      <li>Open the CardsCodingChallenge.xcodeproj within Xcode version 5.X.</li>
      <li>Within the Target's Build Setting properly setup the Code Signing Provisioning Profiles and Code Signing Identities as needed to run the application on a physical iPhone 4-inch model device.<ul><li>This application can also run on the iPhone Retina (4-inch) and iPhone Retina (4-inch 64-bit) simulators.</li></ul></li>
      <li>Clean and Build the Project.</li>
      <li>Run the project to deploy and run the application on the device or simulator.</li>
</ol>

Instruction for using the Card Coding Challenge iOS Application within the device or Simulator

<ol>
      <li>After the application has been launched the Main View will display a Scroll View at the bottom of the screen and a Button titled "Open" at the top right hand corner of the screen.
            <ul>
                  <li>Scroll View
                  
                        <ul>
                              <li>The user can swipe to the left and the right to scroll through the blank image cards.</li>
                              <li>The user can swipe down to partially hide the scroll view and swipe up to show the scroll view.
                              <ul>
                                    <li>When the scroll view is swiped down the label titled "Hello" will fade into the center of the Main view</li>
                                    <li>Wehn the scroll view is swiped up the label titled "Hello" will fade out of the Main view</li>
                              </ul>
                              </li>
                        </ul>
                  </li>
                  <li>Button Titled "Open"
                        <ul>
                              <li>- The user can press the button titled "Open" to open the Menu View</li>
                        </ul>
                  </li>
            </ul>
      </li>
      <li>When the Menu View is presented five buttons will animate into the Menu View with a button titled "Close" at the top right of the screen.
            <ul>
                  <li>Button titled "Close"
                        <ul>
                              <li>The user can press the button titled "Close" to close the Menu View and go back to the Main View</li>
                              <li>The other five buttons will not do anything upon pressing them.</li>
                        </ul>
                  </li>
            </ul>
      </li>
</ol>

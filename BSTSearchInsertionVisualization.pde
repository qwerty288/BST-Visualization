//The ControlP5 library is imported and then a ControlP5 object is declared, so that ControlP5 elements can be added to the visualization in the setup() function
import controlP5.*;
ControlP5 cp5;
//These variables are declared, for later use 
boolean toggle, lastToggle, CLEAR_TREE, toggle2, toggle3, lastToggle3;
binaryTree binaryTree;
PFont font, font2, font3, font4, font5;
ControlFont tFont;
PImage shadow, bg, squareShadow;
int defaultScale;
HScrollbar hs1, hs2;
animatedHollowCircle animatedHollowCircle;
animateInstructions animateInstructions;
float animationSpeed, xFactor, scale;

//This function initializes the required variables and generates the ControlP5 elements
void setup() {
    //The animateInstructions object is initialized, so that an animation displaying the visualization instructions is displayed, at the start
    animateInstructions = new animateInstructions();
    //The canvas size is set
    size(1280, 720);
    //The PImage objects to be used throughout the visualization, are initialized and resized
    shadow = loadImage("dropShadow.png");
    shadow.resize(100, 100);
    squareShadow = loadImage("squareShadow.png");
    squareShadow.resize(40, 40);
    bg = loadImage("background.jpg");
    //The background image is drawn
    image(bg, 0, 0);
    //The binaryTree object is initialized, to be used as a Binary-Tree data-structure throughout the visualization 
    binaryTree = new binaryTree();
    //The defaultScale variable is initialized. This determines the size of the displayed diagram, with no zooming-out applied
    defaultScale = 90;
    //The PFont and controlFont objects are initialized, so that they can be used throughout the visualization
    font = createFont("HelveticaNeue.ttf", 20);
    font2 = createFont("HelveticaNeue.ttf", 27);
    font3 = createFont("arial", 11);
    font4 = createFont("Cambria", 45);
    font5 = font;
    //The ControlP5 object 'cp5' is initialized, and the ControlP5 elements are then generated
    cp5 = new ControlP5(this);
    cp5.addTextfield("").setPosition(1160, 30).setSize(100, 40).setFont(new ControlFont(font)).setAutoClear(true);
    cp5.addTextfield("                      .").setPosition(1160, 100).setSize(100, 40).setFont(new ControlFont(font)).setAutoClear(true);
    cp5.mapKeyFor(new ControlKey() {
        public void keyEvent() { 
            Submit();
        }
    }, ENTER);   
    cp5.addToggle("toggle").setPosition(20, 20).setSize(30, 30).setLabelVisible(false).setColorBackground(color(150, 150, 150)).setColorForeground(color(160, 160, 160)).setColorActive(color(200, 200, 200));
    cp5.addToggle("toggle2").setPosition(20, 70).setSize(30, 30).setLabelVisible(false).setColorBackground(color(0, 133, 0)).setColorForeground(color(0, 130, 0)).setColorActive(color(133, 0, 0));   
    cp5.addToggle("toggle3").setPosition(20, 120).setSize(30, 30).setLabelVisible(false).setColorBackground(color(0, 150, 150)).setColorForeground(color(0, 160, 160)).setColorActive(color(0, 200, 200));   
    cp5.addButton("CLEAR_TREE").setPosition(1130, 680).setSize(130, 40);
    //The HScrollbar objects hs1 and hs2 are initialized, to add a ScrollBar to zoom out (hs1), and a ScrollBar to change animation speed (hs2)
    hs1 = new HScrollbar(20, 700, width / 4, 16, 5);
    hs2 = new HScrollbar(20, 670, width / 4, 16, 5);
    //The animatedHollowCircle object is initialized.
    animatedHollowCircle = new animatedHollowCircle(null, false, 0, false);
}

//This function draws any movement/animations on screen
void draw() {
    showOrHideCP5Interface();
    backgroundToggle();
    helpToggle();    
    updateAnimationSpeedAndScrollBar();
    animateSearchMotion();
    updateZoomScrollBar();
    animateInstructions();
    lastToggle = toggle;
    lastToggle3 = toggle3;
}
//This function hides the ControlP5 objects on screen, if a search motion is being drawn on screen
void showOrHideCP5Interface() {
    if (binaryTree.animatingSearchMotion) {
       cp5.hide();
    } else {
       cp5.show();
    }
}         
//This function is called whenever the 'Enter' key is pressed, and is responsible for acquiring, and then processing user input    
void Submit() {
    //updateBackground();
    //displayLabels();
    //binaryTree.updateNodes(hs1.spos);
    
    //Get user input from the ControlP5 TextFields, as strings
    String input = cp5.get(Textfield.class, "").getText();
    String input2 = cp5.get(Textfield.class, "                      .").getText();
    //Add, or search for the inputted value if it's a positive integer. Inputs from both fields simultaneuosly can't be taken
    if ((!(input.equals("")) && input.matches("[0-9]+") && Float.valueOf(input) < 2147483647) && input2.equals("")) {
        binaryTree.add(Integer.valueOf(input));
    } else if ((!(input2.equals("")) && input2.matches("[0-9]+") && Float.valueOf(input2) < 2147483647) && input.equals("")) {
        binaryTree.search(Integer.valueOf(input2));
    } else {
        //Change text color depending on current background
        if (!toggle) {
            fill(50);
        } else {
            fill(255);
        }
        textSize(20);
        //Display warning message to user, if non-positive integers are entered, or if the user attempts to send inputs to both the search and input text field
        text("Only unique integers can be entered into the tree!", 640, 700);
    }
}

//This function is called whenever the 'CLEAR-TREE' button is pressed. When called, the function will reset the 'binaryTree' object and effectively clear the user's Binary Tree
void CLEAR_TREE (int value) {
    //Reset the help-toggle to false, so that this doesn't affect the display of the start animaion
    if (toggle3 == true) {
        toggle3 = false;
    }
    //Reset the 'binaryTree' object
    binaryTree = new binaryTree();
    //Redraw the background
    updateBackground();    
    //Re-animate the start instructions by resetting the 'animateInstructions' object
    animateInstructions = new animateInstructions();
}

//This function will re-draw the labels and drop-shadows for the ControlP5 Toggles and Text-Fields
void displayLabels() {
    image(squareShadow, 13, 13);
    image(squareShadow, 13, 63);
    image(squareShadow, 13, 113);
    //Change text color according to suit current background
    if (toggle == true) {
        fill(255);
    } else {
        fill(70);
    }
    textAlign(CENTER, CENTER);
    textFont(font5);
    text("Insert", 1209, 12);
    text("Search", 1209, 82);
    text("Help", 80, 133);
}

//This function displays the current-set animation speed in the screen, as a percentage
void showAnimationSpeed() {
    fill(255);
    textFont(font);
    text("Animation Speed: " + Math.round(100*(0.5/animationSpeed)) +"%", 467, 677);
}
//This function displays the current-set zoom speed in the screen, as a percentage
void showZoomFactor() {
    fill(255);
    textFont(font);
    text("Zoom Factor: " + Math.round(100*(hs1.spos - 20) / 303) +"%", 467, 696);
}
//This function re-draws the background, according to the value of the background toggle
void updateBackground() {
    if (toggle) {
        background(100);
    } else {
        image(bg, 0, 0);
    }
}
//This function updates the animationSpeed variable according to the position of the handle of scrollbar hs2, before then updating and drawing the scrollbar hs2 itself
void updateAnimationSpeedAndScrollBar() {
    //Calculate the animation speed
    animationSpeed = 1 - ((hs2.spos - 20) / 305); 
    //If the scrollbar hs2 is being used, then the animation speed is drawn on screen for the user to see
    if (hs2.locked) {
        updateBackground();
        binaryTree.updateNodes(hs1.spos);
        showAnimationSpeed();
        displayLabels();
    }
    //The scrollbar hs2 is then updated and displayed
    hs2.update(hs1.isUsed);
    hs2.display();
}

//This function draws the initial instruction animation
void animateInstructions() {
    //Re-draw the instructions only if the animation is still in effect
    if (!animateInstructions.finished) {
        animateInstructions.update();
        animateInstructions.display();
    }
}

//This function updates the scrollbar hs1, and re-draws the tree if this scrollbar is being used, to display a zooming-animation
void updateZoomScrollBar() {
    if (!binaryTree.animatingSearchMotion && !hs2.isUsed) {
        if (hs1.locked == true) {
            updateBackground();
            binaryTree.updateNodes(hs1.spos);
            showZoomFactor();
            displayLabels();
        }
        hs1.update(hs2.isUsed);
        hs1.display();
    }
}

//This function displays the help-text to the user, if the help-toggle is pressed
void helpToggle() {
    if (lastToggle3 != toggle3 && toggle3)  {
        updateBackground();
        binaryTree.updateNodes(hs1.spos);
        displayLabels();
        showHelp();
    } else if (lastToggle3 != toggle3) {
        updateBackground();
        binaryTree.updateNodes(hs1.spos);
        displayLabels();
    }
}

//This function draws the help-text on screen 
void showHelp() {
    fill(255);
    textAlign(CENTER, CENTER);
    textFont(font5);
    text("Press this button here to reset the tree and start over", 880, 698);
    text("Zoom out", 389, 666);
    text("Change Animation Speed", 459, 698);
    if (toggle == true) {//bg1
        fill(255);
    }
    else {
         fill(100);
    }
    text("Toggle background", 145, 35);
    text("Toggle search animation", 168, 84);
}

//This function updates the background, depending on the state of the first toggle
void backgroundToggle () {
    if (lastToggle != toggle) {
        updateBackground();
        binaryTree.updateNodes(hs1.spos);
        displayLabels();
    }
}
//This function animates the search motion, if the user inputs a valid number
void animateSearchMotion() {
    //If no operations have been performed on the binary tree, then return
    if (!binaryTree.animatingSearchMotion) {
        return;
    }
    
    if (!animatedHollowCircle.finishedAnimation) {
         if (toggle2 && !binaryTree.notAdding || binaryTree.size == 1) {
             animatedHollowCircle.finishedAnimation = true;//Disable animation if search-anmation toggle is enabled
         } else {
             //draw the red hollow circle on screen
             updateBackground();
             binaryTree.displayPreviousNodes(hs1.spos);
             animatedHollowCircle.update();
             animatedHollowCircle.display();
         }
    } else {
          //If the animatedHollowCircle object reports that it's finished it's animation, then reset the appropriate boolean variables, and re-draw points on the screen
         binaryTree.animatingSearchMotion = false;
         binaryTree.updatePreviousXPos();
         if (binaryTree.size > 1) {//
             if (!toggle2) {
                 delay((Integer)Math.round(150*animationSpeed));
             }
         }
         updateBackground();
         binaryTree.updateNodes(hs1.spos);
         displayLabels();    
    }
}

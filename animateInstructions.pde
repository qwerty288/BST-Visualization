/*
This class was designed, such that declaring and initializing an object of this class and then calling it's update and display functions
would then produce an animation of the visualization instructions zooming in from the fop of the screen
*/
class animateInstructions {
    float X, tempX; // x position of slider
    float startX, endX; // max and min values of slider
    int loose; // how loose/heavy;
    float scale, xFactor;
    boolean finished;
    //The constructor sets the start and end coefficients
    animateInstructions() {
        X = tempX = startX = 0;
        endX = 100;
        loose = 7;
        finished = false;
    }
    //This function updates the X coefficient
    void update() {
        scale = (X/endX);//the translation scale is calculated, depending on the X coefficient
        if (scale==1) {
            return;
        }
        tempX = constrain(endX, startX, endX);
        if (abs(tempX - X) > 1) {
            X = X + (tempX - X) / loose;//the coefficient X is updated
            float xMin = (width/2) * scale;//min
            float xMax = (width/2) * scale;//max.
            //The translation coefficient to centre the text in the x axis, xFactor, is calculated
            xFactor = (xMin + ((xMax - xMin) / 2)) - (width/2);
        } else {
            scale = 1;
        }
    }
    //The same formula as that in HScrollBar is sued
    float constrain(float val, float minv, float maxv) {
        return min(max(val, minv), maxv);
    }
    //This function displays the text
    void display() {
        if (scale == 1) {//reshow nodes?
            finished = true;
            return;
        } 
        //display bacoground
        cp5.hide();
        if (toggle == false) {
            image(bg, 0, 0);
        }
        else {
            background(100);
        }
       
        translate(-xFactor, 0); //could animate this!
        scale(scale);
        textFont(font4);
        fill(255);
        textAlign(CENTER, CENTER);
        text("A Binary Search Tree, Search and Insertion Visualization", width/2, height/2);
        textFont(font5);
        //instructions here
        text("Press this button here to reset the tree and start over", 880, 702);
        fill(70);
        text("Insert", 1211, 14);
        text("Search", 1211, 84);
        text("Press this toggle to change the background", 250, 35);
        text("Press this toggle to enable/disable the search-animation", 307, 84);
        text("Click for Help", 115, 133);
        fill(255);
        text("Use this slider to change the search animation-speed, and the slider below it to zoom out of the diagram", 480, 635);
        text("This visualization was made by Prasanth Muthukalyani Sathish Babu (ID 1906781). Add an integer to get started", (width)/2, (5.9*height)/10);
        scale(1/scale);
        //translate(xFactor, 0);
    }
}

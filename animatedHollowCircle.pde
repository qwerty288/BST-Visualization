/*
An object of this class is used to animate a Hollow Red Circle from a set of points provided in the constructor. 
The object stores co-ordinate information of the Circle, and which can be updated using the update() function. The Circle can
then be displayed using the display() function. The acceleration/deceleration from the HScrollBar class is implemented here, 
to make motions appear fluid and aesthetically pleasing. (Why not PV in implementation) Tjis feature wans't implemented using
PVectors, as 
*/
class animatedHollowCircle {
    float X, tempX, Y, tempY, startX, endX, startY, endY, loose;  
    boolean finishedMovement, finishedAnimation, foundNode, isAdding, delay, finalDelay;
    int count, size, keyFound;
    Node[] pointArray;
    /*The constructor requires a 'nodeArrayList' of Node objects to be saved, so that the Circle can move between the points corresponding to the nodes.
    In addition, boolean values representing whether the search was successful, and whether an addition or search is 
    being animated, are also required
    */
    animatedHollowCircle(nodeArrayList p, boolean found, int kF, boolean adding) {
        //The required values are initialized
        delay = false;//Setting this value to true effectively sends a signal to the display() function
        finalDelay = false;
        isAdding = adding;
        finishedAnimation = false;
        if (p == null) {
          return;
        } 
        count = 0;
        pointArray = p.array;
        //The start position is set to (width/2, 0), to create the animation of the circle coming from the top-cente of the screen
        X = tempX = startX = width/2;
        Y = tempY = startY = 0;
        //The end position is set to the position of the first Node object in the list. Their 'previous' co-ordinates are used, so that ...
        if (p.array[0] != null) {
            endX = p.array[0].previousXPos; 
            endY = p.array[0].previousYPos; 
        }
        else {
            endX = startX;
            endY = startY;
        }
        foundNode = found;
        loose = 20 * animationSpeed;
        keyFound = kF;
    }
    //This funciton updates the X and Y co-ordinates of the animatedHollowCircle object
    void update() {
        //The formula from HScrollBar is applied to the X and Y co-ordinates of the circle
        tempX = constrain(endX, startX, endX);
        if (abs(tempX - X) > 1) {
            X = X + (tempX - X) / loose;
        } else if (startX != endX) {
            //If the speed of the circle is zero, then this value is changed to reflect the current state of the Circle's movement
            finishedMovement = true;
        }
        tempY = constrain(endY, startY, endY);
        if (abs(tempY - Y) > 1) {
            Y = Y + (tempY - Y) / loose;
        } else if (startY != endY) {
          //If the speed of the circle is zero, then this value is changed to reflect the current state of the Circle's movement
            finishedMovement = true;
        }
        if (finishedMovement == true && finishedAnimation == false) {
            /*If the Circle has succesfully moved from one point to another, then the start and end positions of the circle are changed
            so that the Circle now moves between the next 2 points on the nodeArrayList acquired from the constructor*/
            delay = true;//This value is set to true, to make the display function pause if a Circle reaches a node. This is to give the user time to read the displayed text at the bottom of the screen
            count++;
            if (pointArray[count] == null) {
                finalDelay = true;//If the Circle has reached the final point, then this value is set to true
                finishedAnimation = true;
                return;
            }
            startX = pointArray[count-1].previousXPos;
            endX = pointArray[count].previousXPos;
            startY = pointArray[count-1].previousYPos;
            endY = pointArray[count].previousYPos;
            finishedMovement = false;//This value is the reset so that the above operations only occur once
        }      
    }
    //This function was obtained from the HScrollBar class
    float constrain(float val, float minv, float maxv) {
        return min(max(val, minv), maxv);
    }
    //This function displays a Hollow Red Circle, and it's last-calculated position
    void display() { 
        if ((((Math.abs(X-endX)) / (Math.abs(startX - endX))) < 0.2) || count == 0) {
            displayText(count, true);
        } 
        noFill();
        strokeWeight(4);
        if (pointArray[count+1] == null && foundNode == true) {
            stroke(0, 255, 0, 150);
        }
        else {
            stroke(255, 73, 82, 150);
        }
        ellipse(X, Y, 94, 94);
        if (delay) { 
            if (finalDelay) {
                delay((Integer)Math.round(4500*animationSpeed));
            } else {
                displayText(count-1, true);
                delay((Integer)Math.round(6000*animationSpeed));
            }
            delay = false;
        }
    }


    void displayText(int i, boolean isWhite) {
        if (i==-1) {
            return;
        }
        textFont(font2);
        if (isWhite) {
            fill(255);
        } else {
            fill(0, 0, 0, 0);
        }
        scale(1/scale);
        translate(xFactor, 0);
        if (pointArray[i+1] == null) {
             if (foundNode == true && pointArray[i] != null) {
                 if (isAdding) {
                     if (keyFound > pointArray[i].nodeKey) {
                         text(keyFound + " > " + pointArray[i].nodeKey + " & no right child exists. Inserting into right child", 640, (((defaultScale+(defaultScale*binaryTree.maxDepth))+(5*textAscent()))*scale));
                     } else {
                         text(keyFound + " < " + pointArray[i].nodeKey + " & no left child exists. Inserting into left child", 640, (((defaultScale+(defaultScale*binaryTree.maxDepth))+(5*textAscent()))*scale));
                     }
                 } else {
                     text("Node with key: " + keyFound + " found", 640, (((defaultScale+(defaultScale*binaryTree.maxDepth))+(5*textAscent()))*scale));
                 }
             } else if (pointArray[i] != null) {
                 if (keyFound > pointArray[i].nodeKey) {
                     text(keyFound + " > " + pointArray[i].nodeKey + " & no right child exists. Search Failed", 640, (((defaultScale+(defaultScale*binaryTree.maxDepth))+(5*textAscent()))*scale));
                 } else {
                     text(keyFound + " < " + pointArray[i].nodeKey + " & no left child exists. Search Failed", 640, (((defaultScale+(defaultScale*binaryTree.maxDepth))+(5*textAscent()))*scale));
                 }
             }
        } else {
             if (pointArray[i].nodeKey > keyFound) {
                 text(keyFound + " < " + pointArray[i].nodeKey + " , going left", 640, (((defaultScale+(defaultScale*binaryTree.maxDepth))+(5*textAscent()))*scale));
             } else {
                 text(keyFound + " > " + pointArray[i].nodeKey + " , going right", 640, (((defaultScale+(defaultScale*binaryTree.maxDepth))+(5*textAscent()))*scale));
             }
        }
        translate(-xFactor, 0);
        scale(scale);
    }
}

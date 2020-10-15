/*
This class is designed such that objects of this class represent nodes in a binaryTree. Each 'Node' object contains a node key, a link to it's parents and children,
the direction of which the node came from (in boolean form, with left = false and right = true), and it's co-ordinate information for display.
*/
class Node {
    Integer xPos, yPos, parentNodeNumber, leftChildNumber = null, rightChildNumber = null, previousXPos = null, previousYPos = null, nodeNumber;
    boolean directionFrom; //false = left of root node, true = right of root node
    Integer nodeKey = null;
    Node(Integer xP, Integer yP, Integer nK, boolean dF, int pNN) {
        //This constructor allows for the appropriate variables to be initialized
        xPos = xP;
        yPos = yP;
        previousXPos = xPos;
        previousYPos = yPos;
        nodeKey = nK;
        directionFrom = dF;
        parentNodeNumber = pNN;
    }
    //Given a node number, and whether the previous or present co-ordinates should be displayed, this function displays a node when called
    void display(int i, boolean isPrevious) {
        noStroke();
        if (this.leftChildNumber == null & this.rightChildNumber == null) {
            fill(255, 255, 255, 150);
        } else {
            fill(255);
        }
        int xPosTemp = 0;
        int yPosTemp = 0;
        if (isPrevious) {
            xPosTemp = this.previousXPos;
            yPosTemp = this.previousYPos;
        } else {
            xPosTemp = this.xPos;
            yPosTemp = this.yPos;
        }
        ellipse(xPosTemp, yPosTemp, defaultScale, defaultScale); 
        if (!toggle) {
            image(shadow, xPosTemp - 47, yPosTemp - 45);
        }
        fill(0, 0, 0, 150);
        textAlign(CENTER); //shrink if digits are 2much
        textFont(font2);
        //This code shrinks the nodekey text to fit inside the ellipse, if it's too large
        if (((this.nodeKey).toString()).length() > 6) {
            textSize(27*(float)Math.pow(0.87,((this.nodeKey).toString()).length()-6));
        } 
        text(this.nodeKey, xPosTemp + 0.5, yPosTemp + 5);
        textFont(font3);
        text(i, xPosTemp, yPosTemp + 20);
    }
    

}

/*
An object of this class represents a Binary-Tree data-structure. Insertion and Search operations can be performed on the structure. 
In addition, functions to display the Binary-Tree containd in the 'binaryTree' object are also present. Rather than using an implementation
like: https://www.geeksforgeeks.org/binary-tree-set-1-introduction/, I used my arrayList implementation 
This was to make implementing checkXIntersection easier and more efficient, as the complexity of searching for a node with a 
given number was reduced from O(n) to O(1). In addition, modifying induvidual nodes was also far easier to do.
An arrayList data structure was used to store Node objects, so that there is no limit on the size of tree which can be generated
*/
class binaryTree {
    int size, maxDepth;
    nodeArrayList nodeArrayList;
    nodeArrayList searchRoute;
    boolean animatingSearchMotion, notAdding;
    //The object contstructor intitalises the appropriate variables for later use
    binaryTree() {
        size = 0;
        nodeArrayList = new nodeArrayList();
        animatingSearchMotion = false;
    }
    //This function searches for a value in the tree, and then starts an animation showing the search-path took
    void search(int key) {
        //If tree has no values, then return
        if (size == 0) {
            return;
        } 
        Integer nodeNumberToCheck = 0;
        boolean directionFrom = false; //left is false, right is true
        int nodeDepth = 0, temp = 0;
        searchRoute = new nodeArrayList();
        while (1 == 1) {                      
            if (nodeNumberToCheck == null) { 
                animateSearch(false, key);
                return;
            } else {
                temp = nodeNumberToCheck;
                searchRoute.add(this.nodeArrayList.array[nodeNumberToCheck]);
                nodeDepth++;
            }
            if (this.nodeArrayList.array[nodeNumberToCheck].nodeKey < key) { //go right
                directionFrom = true;
                nodeNumberToCheck = this.nodeArrayList.array[nodeNumberToCheck].rightChildNumber;
            } else if (this.nodeArrayList.array[nodeNumberToCheck].nodeKey > key) {//go left
                directionFrom = false;
                nodeNumberToCheck = this.nodeArrayList.array[nodeNumberToCheck].leftChildNumber;
            } else {//found
                //2 'null' objects are added to avoid out-of-bounds errors in animatedHollowCircle
                searchRoute.add(null);
                searchRoute.add(null);
                animateSearch(true, key);
                return;
            } //duplicate
        }
    }
    //when called, this function initialises the animatingHollowCircle object to start the display of a search-animation
    void animateSearch(boolean found, int key) {
        searchRoute.add(null);
        searchRoute.add(null);
        notAdding = true;
        animatingSearchMotion = true;
        animatedHollowCircle = new animatedHollowCircle(searchRoute, found, key, false);        
    }
    //This function takes in a valid integer, adds it to the tree and then re-initializaes the animatedHollowCircle object to startthe display of a search animation, if the addition was successful
    void add(int key) {
        notAdding = false;
        if (size == 0) {
            maxDepth = 0;
            this.nodeArrayList.add(new Node((width/2), 90, key, false, 0));
            animatingSearchMotion = true;
            size++;
            return;
        }  
        Integer nodeNumberToCheck = 0;
        boolean directionFrom = false; //left is false, right is true
        int nodeDepth = 0, temp = 0;
        searchRoute = new nodeArrayList();
        while (1 == 1) {                   
            if (nodeNumberToCheck == null) { //update parents
                if (nodeDepth > maxDepth) {
                    maxDepth = nodeDepth;
                }
                //Add two 'null' objects to searchRoute, to avoid outofbounds error in animatedHollowCircle
                searchRoute.add(null);
                searchRoute.add(null);
                //Update child-links of the parent of the node-to-be-added
                if (!directionFrom) { //came from left
                    this.nodeArrayList.array[temp].leftChildNumber = size;
                } else { //came from right
                    this.nodeArrayList.array[temp].rightChildNumber = size;
                }
                int xPosition = calculateXPos(directionFrom, temp);
                this.nodeArrayList.add(new Node(xPosition, defaultScale + (defaultScale * nodeDepth), key, directionFrom, temp));
                animatedHollowCircle = new animatedHollowCircle(searchRoute, true, key, true);
                checkXIntersection(xPosition, size);
                animatingSearchMotion = true;
                size++;                
                return;
            } else {
                temp = nodeNumberToCheck;
                searchRoute.add(this.nodeArrayList.array[nodeNumberToCheck]);
                nodeDepth++;
            }
            if (this.nodeArrayList.array[nodeNumberToCheck].nodeKey < key) { //right
                directionFrom = true;
                nodeNumberToCheck = this.nodeArrayList.array[nodeNumberToCheck].rightChildNumber;
            } else if (this.nodeArrayList.array[nodeNumberToCheck].nodeKey > key) {
                directionFrom = false;
                nodeNumberToCheck = this.nodeArrayList.array[nodeNumberToCheck].leftChildNumber;
            } else {
                return;
            } //duplicate
        }
    }
    //This function calculates the x position of a to-be-inserted node, by using it's previous coordinates and the direction in which the node-to-be-inserted came from
    int calculateXPos(boolean directionFrom, int previousNode) {
        if (!directionFrom) { //left
            return this.nodeArrayList.array[previousNode].xPos - defaultScale;
        } else {
            return this.nodeArrayList.array[previousNode].xPos + defaultScale;
        }
    }
    //Thiis function is responsible for checking for intersections on the Y-axis, and then changing the co-ordinates of the required nodes if an intersection is present
    void checkXIntersection(int xPos, int nN) {
        if (nN == 0) {//not needed?
            return;
        }
        ///Use a linear-search to try and check if a Y-intersection is present
        for (int i = 0; i < size; i++) {
            if (this.nodeArrayList.array[i] != null && this.nodeArrayList.array[i].xPos == xPos && i != nN) {
                break;//If intersection is detected, exit loop and go down
            } else if (i == size-1) {
                return;//If search unsuccessful, exit function as no intersection is present
            }
        }
        //Travel up the node with the nodeNumnber 'nN', until a node with a different 'directionFrom' variable is found
        int z = nN;
        boolean d1 = this.nodeArrayList.array[z].directionFrom, d2 = d1;
        while (d1 == d2) {
            d1 = this.nodeArrayList.array[z].directionFrom;
            z = this.nodeArrayList.array[z].parentNodeNumber;
            d2 = this.nodeArrayList.array[z].directionFrom;
        }
        //Determine which side of the root-node, the node of node number 'nN' is on
        int direction;
        if (this.nodeArrayList.array[z].xPos > (width/2)) {
            direction = 1;
        } else {
            direction = -1;
        }
        //If this node is facing outwards, then apply case 2. Else, apply case 1
        if (this.nodeArrayList.array[z].xPos > (width/2) && this.nodeArrayList.array[z].directionFrom || this.nodeArrayList.array[z].xPos < (width/2) && !this.nodeArrayList.array[z].directionFrom) { //if dc node is found in right direction
            case1(z, direction);
            checkFurthestNode(z, direction);
        } else if (this.nodeArrayList.array[z].xPos > (width/2) && !this.nodeArrayList.array[z].directionFrom || this.nodeArrayList.array[z].xPos < (width/2) && this.nodeArrayList.array[z].directionFrom) { //if dc node is found in wrong direction
            case2(this.nodeArrayList.array[z].parentNodeNumber, direction, this.nodeArrayList.array[z].directionFrom); //node above is passed through
        }
        //exit function
        return;
    }
    //This function shifts a given node outwards, and then updates it's previous x position
    void shiftNodeOutwards(int n, int d) {//update minX, maxX
        this.nodeArrayList.array[n].previousXPos = this.nodeArrayList.array[n].xPos;
        this.nodeArrayList.array[n].xPos = this.nodeArrayList.array[n].xPos + (defaultScale * d);
    }

    //This function is designed to traverse an the node of node number n, through recursion. All visited nodes are shifted outwards
    void case1(int n, int d) {
        shiftNodeOutwards(n, d);
        if (this.nodeArrayList.array[n].leftChildNumber != null) {
            case1(this.nodeArrayList.array[n].leftChildNumber, d);
        }
        if (this.nodeArrayList.array[n].rightChildNumber != null) {
            case1(this.nodeArrayList.array[n].rightChildNumber, d);
        }
    }
    //This function is designed to travel up a node of node number n, through recursion. All visited nodes and their parents are shifted outwards.
    //when reach dc node, check outer
    void case2(int n, int d, boolean lastDirection) { //d==1 is to right
        shiftNodeOutwards(n, d);
        if (d == 1 && this.nodeArrayList.array[n].rightChildNumber != null) {
            case1(this.nodeArrayList.array[n].rightChildNumber, d);
        } else if (d == -1 && this.nodeArrayList.array[n].leftChildNumber != null) {
            case1(this.nodeArrayList.array[n].leftChildNumber, d);
        }
        if (this.nodeArrayList.array[n].directionFrom != lastDirection) { //at dc node
            checkFurthestNode(n, d);
        } else {
            case2(this.nodeArrayList.array[n].parentNodeNumber, d, this.nodeArrayList.array[n].directionFrom); //apply same to node above
        }
    }
    //This function is designed to travel to the outer-most node from the node with node number n via recursion. IF this node is found, then it's checked for intersection
    void checkFurthestNode(int n, int d) {
        if (d == 1) {
            if (this.nodeArrayList.array[n].rightChildNumber != null) {
                checkFurthestNode(this.nodeArrayList.array[n].rightChildNumber, d);
            } else {
                checkXIntersection(this.nodeArrayList.array[n].xPos, n);
            }
        } else if (d == -1) {
            if (this.nodeArrayList.array[n].leftChildNumber != null) {
                checkFurthestNode(this.nodeArrayList.array[n].leftChildNumber, d);
            } else {
                checkXIntersection(this.nodeArrayList.array[n].xPos, n);
            }
        }
    }
    //This function displays all the nodes in the binary tree, when called. It's also designed to take in the variable hs1.spos, which it then maps to a scale to transform the displayed points onto
    void updateNodes(float spos) { 
        if (size == 0) {
            return;
        }
        //calculate scale
        scale = (spos - 20) / 303;
        int z = 0, z2 = 0;
        //use while-loops to obtain the furthest nodes on either side of the root node
        while (this.nodeArrayList.array[z].leftChildNumber != null) {
            z = this.nodeArrayList.array[z].leftChildNumber;
        }
        while (this.nodeArrayList.array[z2].rightChildNumber != null) {
            z2 = this.nodeArrayList.array[z2].rightChildNumber;
        }
        //use the x co-ordinates of both the outer nodes to calculate a translation factor, so that the the drawn diagram is centred
        float xMin = this.nodeArrayList.array[z].xPos * scale;
        float xMax = this.nodeArrayList.array[z2].xPos * scale;
        xFactor = (xMin + ((xMax - xMin) / 2)) - (width/2);
        transform();
        //loop through this.nodeArrayList to display all the lines
        stroke(0, 0, 0, 50);
        strokeWeight(15);         
        if (size > 0) {
            for (int i = 1; i < size; i++) {
                line(this.nodeArrayList.array[i].xPos, this.nodeArrayList.array[i].yPos, (this.nodeArrayList.array[this.nodeArrayList.array[i].parentNodeNumber].xPos), (this.nodeArrayList.array[this.nodeArrayList.array[i].parentNodeNumber].yPos));
            }
        }
        //loop through this.nodeArrayList to display all the points
        for (int i = 0; i < size; i++) {
             this.nodeArrayList.array[i].display(i, false);
        }
        deTransform();
    }
    //This function updates the 'previous positions' of each Node object stored
    void updatePreviousXPos() {
        for (int i=0;i<size;i++) {
            this.nodeArrayList.array[i].previousXPos = this.nodeArrayList.array[i].xPos;
        }
    }
    //This function is very similar to updateNodes(). The only difference is that a Node object's previous coordinates are used, so that this function can display the Binary-Tree diagram before a successful operation
    void displayPreviousNodes(float spos) { ///update previous, here. and also calculate xIntersection
        if (size == 1) {
            this.nodeArrayList.array[0].display(0, true);
            return;
        }
        
        scale = (spos - 20) / 303;        
        int z = 0, z2 = 0;
        while (this.nodeArrayList.array[z].leftChildNumber != null) {
            z = this.nodeArrayList.array[z].leftChildNumber;
        }
        while (this.nodeArrayList.array[z2].rightChildNumber != null) {
            z2 = this.nodeArrayList.array[z2].rightChildNumber;
        }
        if (z == size-1 && !notAdding) {
            z = this.nodeArrayList.array[z].parentNodeNumber;
        } 
        if (z2 == size-1 && !notAdding) {
            z2 = this.nodeArrayList.array[z2].parentNodeNumber;
        }
        float xMin = 0;
        float xMax = 0;
        if (notAdding) {
             xMin = this.nodeArrayList.array[z].xPos * scale;
             xMax = this.nodeArrayList.array[z2].xPos * scale;
        } else { 
             xMin = this.nodeArrayList.array[z].previousXPos * scale;
             xMax = this.nodeArrayList.array[z2].previousXPos * scale;
         }
        xFactor = (xMin + ((xMax - xMin) / 2)) - (width/2);
        transform();
        stroke(0, 0, 0, 50);
        strokeWeight(15);
        int limit = 0;
        if (notAdding == true) {
            limit = size;
        } else {
            limit = size - 1;
        }
        //display line
        if (size > 0) {            
            for (int i = 1; i < limit; i++) {
                line(this.nodeArrayList.array[i].previousXPos, this.nodeArrayList.array[i].previousYPos, (this.nodeArrayList.array[this.nodeArrayList.array[i].parentNodeNumber].previousXPos), (this.nodeArrayList.array[this.nodeArrayList.array[i].parentNodeNumber].previousYPos));
            }
        }
        //then display nodes
        for (int i = 0; i < limit; i++) {
            this.nodeArrayList.array[i].display(i, true);
        }
        
        if (animatedHollowCircle.finishedAnimation == true) {
            deTransform();
        }
    }
    //this function performs a translation and a transformation based on values calculated elsewhere
    void transform() {
        translate(-xFactor, 0);
        scale(scale);
    }
    //This function acts as an inverse to the function aboveß
    void deTransform() {
        scale((1 / scale));
        translate(xFactor, 0);
    }
    
}

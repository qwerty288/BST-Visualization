/*
Objects of this class represent Scroll-Bars which are displayed on screen if their update() and display() functions are called. 
The position of the Scroll-Bar (this.spos) can be accessed and then mapped onto another variable (the scale factor, and animation speed in this case)
This class was acquired from https://processing.org/examples/scrollbar.html, and then modified to provide additional features. The comments that were
included in this class by the author were removed, and the comments below represent modifications made
*/
class HScrollbar {
    int swidth, sheight;
    float xpos, ypos;
    float spos, newspos;
    float sposMin, sposMax; 
    int loose; 
    boolean over, over2; 
    boolean locked, done;
    float ratio;
    boolean isUsed;//This variable was created to represent whether the HScrollBar object was active
    boolean isZoom;

    HScrollbar(float xp, float yp, int sw, int sh, int l) {
        //The if statement below sets different starting positions of the Scroll Bar 'thumb', for the Zoom and Animation scroll bars
        if (yp==700) {
            spos = 323;
            isZoom = true;
        } else {
            spos = 179;
            isZoom = false;
        }
        swidth = sw;
        sheight = sh;
        int widthtoheight = sw - sh;
        ratio = (float) sw / (float) widthtoheight;
        xpos = xp;
        ypos = yp - sheight / 2;
        newspos = spos;
        sposMin = xpos;
        sposMax = xpos + swidth - sheight;
        loose = l;
        done = true;
        isUsed = false;
    }
    void update(boolean isSecondScrollBarOn) {//This function was modified to take in a second boolean variable (the isUsed variable of another scroll bar)
        if (overEvent()) {
            over = true;
        } else {
            over = false;
        }
        if (mousePressed && over) {
            locked = true;
        }
        if (!mousePressed) {
            locked = false;
        }
        //By modifying the if statement to check 'isSecondScrollBarOn'. this means that changing the thumb position (spos) of one scroll bar doesn't affect that of the other scrollbar
        if  (locked && !binaryTree.animatingSearchMotion && !isSecondScrollBarOn) {//only for zoom
            isUsed = true;//The boolean variable isUsed is updated
            newspos = constrain(mouseX - sheight / 2, sposMin, sposMax);
            done = false;
        } else if (done == false) {
            done = true;
        } else {
            isUsed = false;//The boolean variable isUsed is updated
        }
        if (abs(newspos - spos) > 1 && !binaryTree.animatingSearchMotion) {
            spos = spos + (newspos - spos) / loose;
        } 
    }

    float constrain(float val, float minv, float maxv) {
        return min(max(val, minv), maxv);
    }

    boolean overEvent() {
        if (mouseX > xpos && mouseX < xpos + swidth &&
            mouseY > ypos && mouseY < ypos + sheight) {
            return true;
        } else {
            return false;
        }
    }

    void display() {
        noStroke();
        fill(200);
        rect(xpos, ypos, swidth, sheight);
        if (over || locked) {
            fill(150);
        } else {
            fill(120);
        }
        rect(spos, ypos, sheight, sheight);
    }

    float getPos() {
        return spos * ratio;
    }
}

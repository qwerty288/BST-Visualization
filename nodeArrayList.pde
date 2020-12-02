/*
An object of this class represents an arrayList data-structure, which can be used to store 'Node' objects. 
*/
class nodeArrayList {
    Node[] array;
    int size;
    int capacity;

    nodeArrayList() {
        this.capacity = 1;
        this.size = 0;
        this.array = new Node[capacity]; 
    }
 
    void add(Node element) {
        if (size < capacity) {
            array[size] = element;
        } else {
            int newCapacity = capacity * 2;
            Node[] array2 = new Node[newCapacity];
            for (int i = 0; i < capacity; i++) {
                array2[i] = array[i];
            }
            array2[capacity] = element;
            array = array2;
            capacity = newCapacity;
        }
        size++;
    }
    
    int size() {
        return this.size;
    }
}

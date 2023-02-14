package;

import PizzaOrder;

class Customer {
    private var order:PizzaOrder;
    private var patienceTime:Int;
    private var timer:Timer;


    public function Customer() {
        // Create a new order
        // order = new PizzaOrder();
        // Set patience time based on current difficulty
        patienceTime = 10;
        timer = haxe.Timer.delay(onTimer, patienceTime * 1000);

    }

    private function onTimer() {
        // Customer leaves, add failure
        trace("Customer leaves");
    }
}
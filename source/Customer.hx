package;

import PizzaOrder;
import haxe.Timer;

class Customer {
    var order:PizzaOrder;
    var patienceTime:Int;
    var timer:Timer;
    var event:Event<Int->Void>;
    var customerId:Int;

    public function Customer(difficulty:Int, event:Event<Int->Void>, customerId:Int) {
        this.event = event;
        this.customerId = customerId;
        // Create a new order
        // order = new PizzaOrder();
        // Set patience time based on current difficulty
        patienceTime = (10 - difficulty) * 2;
        timer = haxe.Timer.delay(onTimer, patienceTime * 1000);
        
    }

    private function onTimer() {
        // Customer leaves, add failure
        trace("Customer leaves");
        event.dispatch(1);
    }
}
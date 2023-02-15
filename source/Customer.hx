package;

import PizzaOrder;
import PlayState;
import haxe.Timer;
import lime.app.Event;

class Customer {
    public var order:PizzaOrder;
    var patienceTime:Int;
    var timer:Timer;
    var event:Event<Void->Void>;
    var customerId:Int;

    public function new(difficulty:Int, event:Event<Void->Void>) {
        this.event = event;
        order = PizzaOrder.newOrder(PlayState.getMaxComplexity(difficulty));
        patienceTime = (10 - difficulty) * 4;
        timer = haxe.Timer.delay(onTimer, patienceTime * 1000);
    }

    private function onTimer() {
        // Customer leaves, add failure
        trace("Customer leaves");
        event.dispatch();
    }
}
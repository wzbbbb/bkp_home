package helloworld;

public class heavybagdemo {
		public static void main(String[] args){
			HeavyBag bag1 = new HeavyBag();
			HeavyBag bag2 = new HeavyBag();
			bag1.set_weight(100);
			bag1.set_hight(2);
			bag1.set_color("black");
			bag1.set_cover("lether");
			bag2.set_weight(75);
			bag2.set_hight(2);
			bag1.printDesc();
			bag2.printDesc();
		}
		
}

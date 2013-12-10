package helloworld;
public class playingCard {
	int rank = 0;
	String suit ="";
	static int num_of_card =0;
playingCard(int r, String s ){
	rank = r;
	suit = s;
	++num_of_card;
}
playingCard(){
	this(1, "heart");
}
public static int printHowManyCard(){
	return num_of_card;
}
void printCard(){
	System.out.println("rank and suit: " + rank + " , " +suit);
}
}


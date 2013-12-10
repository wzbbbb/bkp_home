package helloworld;

public class playCard {

	public static void main(String []  args){
		playingCard card1 = new playingCard(10,"diamond");
		int num = playingCard.printHowManyCard();
		assert num ==11;
		System.out.println(num);
		card1.printCard();
		playingCard card2= new playingCard();
		System.out.println(playingCard.printHowManyCard());
		card2.printCard();
		String[] suits = {"heart","diamond","club","spade"};
		playingCard[] deck = new playingCard[53];
		for (int i = 0; i< 13; ++i){
			for (String item : suits){
				deck[i]= new playingCard((i+1), item);
				deck[i].printCard();
			}
		}
	}
}

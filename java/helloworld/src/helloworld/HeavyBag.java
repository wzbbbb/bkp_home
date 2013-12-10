package helloworld;

public class HeavyBag {
int weight = 0;
int  hight = 0;
String color = "";
String cover = "";
void set_weight(int newWeight){
	weight = newWeight;
}
void set_hight(int newHeight){
	hight = newHeight;
}
void set_color(String newColor){
	color=newColor;
}
void set_cover(String newCover){
	cover=newCover;
}
void printDesc(){
	System.out.println("weight:        " + weight+"================hight:          " + hight + "\n" +
"cover: ===" + cover + "color :==" + color);
}
}

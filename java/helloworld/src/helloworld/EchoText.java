package helloworld;
public class EchoText{
public static void main(String[] args) throws java.io.IOException{
	System.out.println("input something then enter");
	int ch;
	while ((ch = System.in.read())!= -1) {
		System.out.print((char) ch);
	}
		System.out.println();
}
}

package helloworld;

public class EchoText1 {

	/**
	 * @param args
	 */
	public static void main(String[] args)throws java.io.IOException {
		// TODO Auto-generated method stub
		System.out.println("input something then enter");
		int ch;
		while ((ch = System.in.read())!= -1) {
			System.out.print((char) ch);
		}
			System.out.println();
	}

}

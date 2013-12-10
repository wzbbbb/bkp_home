package helloworld;
public class dumpargs{
	public static void main(String[] args){
		System.out.println("passwd arguments:");
		for (int i=0; i<args.length; i++){
			System.out.println(args[i]);
		}
	}
}
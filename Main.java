import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ArrayList<Integer> numbers = new ArrayList<>();

        System.out.println("Enter integers (type any non-number letter to stop):");

        // The loop keeps running as long as the user inputs integers
        while (scanner.hasNextInt()) {
            numbers.add(scanner.nextInt());
        }

        System.out.println("Your final list of numbers: " + numbers);
        scanner.close();
    }
}
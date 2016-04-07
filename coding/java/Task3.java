import java.math.BigInteger;

public class Task3 {
    public static void main(String[] args) {
        int n = 24, k = 16, d = 11;
        boolean checkK = true;
        for (int i = 0; i <= 19; i++) {
            int st = getStatus(n, checkK ? i : k, checkK ? d : i);
            //System.out.println(Hamming(n,k,d));
            System.out.println(i + ": " + (st == 0 ? "No" : (st == 1 ? "?" : "Yes")));
            System.out.println(i + "--->" + Hamming(n,i,d) + " " + VG(n,i,d) + " " + Gr(n,i,d));
        }
    }

    private static int getStatus(int n, int k, int d) {
        int a = Hamming(n, k, d), b = VG(n, k, d), c = Gr(n, k, d);
        int m1 = Math.max(a, Math.max(b, c)), m2 = Math.min(a, Math.min(b, c));
        if (m1 == 2 && m2 == 0) {
            throw new AssertionError();
        }
        if (m1 == 2) {
            return 2;
        } else if (m2 == 0) {
            return 0;
        }
        return 1;
    }

    private static int Hamming(int n, int k, int d) {
        long sum = 0;
        int t = (d - 1) / 2;
        for (int i = 0; i <= t; i++) {
            sum += C(n, i).longValue();
        }
        boolean res = sum <= Math.pow(2, n - k);
        return res ? 1 : 0;
    }

    private static int VG(int n, int k, int d) {
        long sum = 0;
        for (int i = 0; i <= d - 2; i++) {
            sum += C(n - 1, i).longValue();
        }
        boolean res = sum <= Math.pow(2, n - k);
        return res ? 2 : 1;
    }

    private static int Gr(int n, int k, int d) {
        int sum = 0;
        for (int i = 0; i < k - 1; i++) {
            int x = (int) Math.pow(2, i);
            int y = d / x;
            if (d % x != 0) {
                y++;
            }
            sum += y;
        }
        boolean res = n >= sum;
        return res ? 1 : 0;
    }

    static BigInteger C(final int N, final int K) {
        BigInteger ret = BigInteger.ONE;
        for (int k = 0; k < K; k++) {
            ret = ret.multiply(BigInteger.valueOf(N - k)).divide(BigInteger.valueOf(k + 1));
        }
        return ret;
    }
}

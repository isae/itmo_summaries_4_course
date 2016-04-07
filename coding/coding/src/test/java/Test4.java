
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * victor
 */
public class Test4 {

    public String concat(List<String> arrs, String delimeter) {
        String temp = "";
        for (int i = 0; i < arrs.size() - 1; ++i) {
            temp += arrs.get(i) + delimeter;
        }
        temp += arrs.get(arrs.size() - 1);
        return temp;
    }

    /**
     * Максимальная длина последовательности идущих подряд элементов
     */
    public int seqLength(Group group) {
        int c = 1;
        int m = 1;
        for (int i = 1; i < group.size(); ++i) {
            if (group.get(i - 1) + 1 == group.get(i)) {
                ++c;
                if (c > m) {
                    m = c;
                }
            } else {
                c = 1;
            }
        }
        return m;
    }

    @Test
    public void posTest() {
        Assert.assertEquals(1, seqLength(new Group(0)));
        Assert.assertEquals(2, seqLength(new Group(1, 2, 4, 8)));
        Assert.assertEquals(4, seqLength(new Group(1, 2, 3, 4, 6, 9, 12)));
        Assert.assertEquals(6, seqLength(new Group(1, 2, 3, 4, 5, 6, 8, 9, 10, 12)));
        Assert.assertEquals(14, seqLength(new Group(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)));
    }

    public static int[] inc(int[] v) {
        int c = 1;
        int[] b = new int[v.length];
        for (int i = v.length - 1; i >= 0; --i) {
            int t = (v[i] + c) % 2;
            int q = (v[i] + c) / 2;
            b[i] = t;
            c = q;
        }
        return b;
    }

    public static int[][] words(int r) {
        int[][] a = new int[1 << r][r];
        for (int i = 1; i < (1 << r); ++i) {
            a[i] = inc(a[i - 1]);
        }
        return a;
    }

    @Test
    public void main() throws IOException {
        // основание системы счисления (2 - двоичный код)
        int p = 2;
        // модуль / длина кода
        int n = 17;

        List<Group> groups = new ArrayList<>();
        Set<Integer> used = new HashSet<>();
        for (int s = 0; s < n; ++s) {
            if (!used.contains(s)) {
                Group group = new Group();
                group.add(s);
                int b = s * p % n;
                while (!group.contains(b)) {
                    group.add(b);
                    used.add(b);
                    b = b * p % n;
                }
                groups.add(group);
            }
        }
        try (PrintWriter writer = new PrintWriter("result.html")) {
            writer.println("<html><head><meta charset=\"UTF-8\"><link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css\"/></head><body>");
            writer.println("<h2>Циклотомические классы по модулю " + n + "</h2>");
            writer.println("<ul>");
            for (Group group : groups) {
                writer.println("<li>C<sub>" + group.get(0) + "</sub> = " + group + "</li>");
            }
            writer.println("</ul>");
            writer.println("<h2>Минимальные многочлены корней</h2>");
            writer.println("<ul>");
            for (Group group : groups) {
                if (group.get(0) == 0) {
                    writer.println("<li>M<sub>0</sub>(x) = x + 1</li>");
                } else {
                    writer.println("<li>M<sub>" + group.get(0) + "</sub>(x) = " + concat(group.stream().map(i -> "(x - a<sup>" + i + "</sup>)").collect(Collectors.toList()), "*") + "</li>");
                }
            }
            writer.println("</ul>");
            int[][] map = words(groups.size());
            writer.println("<h2>БЧХ-коды длины " + n + "</h2>");
            writer.println("<table class='table'>");
            writer.println("<tr><th>Показатели</th><th>Порождающий</th><th>Размерность<br/>n-deg g(x)</th><th>Расстояние</th></tr>");
            List<Code> codes = new ArrayList<>();
            for (int i = 0; i < map.length - 1; ++i) {
                Group g = new Group();
                List<Integer> polynomial = new ArrayList<>();
                for (int j = 0; j < map[i].length; ++j) {
                    if (map[i][j] == 1) {
                        g.addAll(groups.get(j));
                        polynomial.add(groups.get(j).get(0));
                    }
                }
                if (!g.isEmpty()) {
                    Collections.sort(g);
                    int distance = seqLength(g) + 1;
                    assert distance <= n;
                    codes.add(new Code(g, polynomial, n - g.size(), distance));
                }
            }
            codes = codes.stream().sorted((lhs, rhs) -> Integer.compare(lhs.distance, rhs.distance)).collect(Collectors.toList());
            for (Code code : codes) {
                writer.println("<tr>");
                writer.println("<td>" + code.group + "</td>");
                String tm = "";
                for (int i : code.polynomial) {
                    tm += "M<sub>" + i + "</sub>";
                }
                writer.println("<td>" + tm + "</td>");
                writer.println("<td>" + code.size + "</td>");
                writer.println("<td>" + code.distance + "</td>");
                writer.println("</tr>");
            }
            writer.println("</table>");
            writer.println("</body></html>");
        }
    }

    public static class Code {
        Group group;
        List<Integer> polynomial;
        int size;
        int distance;

        public Code(Group group, List<Integer> polynomial, int size, int distance) {
            this.group = group;
            this.polynomial = polynomial;
            this.size = size;
            this.distance = distance;
        }
    }

    public static class Group extends ArrayList<Integer> {
        public Group(Integer... numbers) {
            super(Arrays.asList(numbers));
        }
    }
}

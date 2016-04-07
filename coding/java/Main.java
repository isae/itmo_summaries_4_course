import javafx.util.Pair;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.*;

public class Main {
    public static void main(String[] args) throws FileNotFoundException {
        System.setOut(new PrintStream(new FileOutputStream("output")));
        Scanner sc = new Scanner(new FileInputStream("input"));
        int n = sc.nextInt();
        int m = sc.nextInt();
        int[][] g = new int[n][m];
        int[] b = new int[n];
        int[] e = new int[n];
        for(int i = 0; i < n; i++){
            boolean began = false;
            for(int j = 0; j < m; j++){
                g[i][j] = sc.nextInt();
                if(g[i][j] == 1 && !began){
                    began = true;
                    b[i] = j;
                }
                if(g[i][j] == 1){
                    e[i] = j;
                }
            }
        }
        System.out.println("digraph graphname {");
        List<Pair<String, Map<Integer, Integer>>> layer = new ArrayList<>();
        layer.add(new Pair<>("first", new TreeMap<>()));
        for(int i = 0; i < m; i++){
            Set<Integer> active = new TreeSet<>();
            for(int j = 0; j < n; j++){
                if(i >= b[j] && i < e[j]){
                    active.add(j);
                }
            }
            List<Pair<String, Map<Integer, Integer>>> newLayer = new ArrayList<>();
            buildrec(layer, newLayer, new ArrayList<>(), active, active.size(), i, g);
            layer = newLayer;
        }
        System.out.println("}");
    }

    private static void buildrec(List<Pair<String, Map<Integer, Integer>>> layer,
                                 List<Pair<String, Map<Integer, Integer>>> newLayer,
                                 ArrayList<Integer> seq, Set<Integer> active, int remains, int layerNum, int[][] g) {
        if(remains > 0){
            seq.add(0);
            buildrec(layer, newLayer, seq, active, remains - 1, layerNum, g);
            seq.set(seq.size() - 1, 1);
            buildrec(layer, newLayer, seq, active, remains - 1, layerNum, g);
            seq.remove(seq.size() - 1);
        } else {
            Map<Integer, Integer> node = new TreeMap<>();
            int i = 0;
            String ending = "";
            for(int row : active){
                node.put(row, seq.get(i));
                ending += seq.get(i++);
            }
            String name = "n" + layerNum + "_" + ending + "blya";
            newLayer.add(new Pair<>(name, node));
            System.out.println(name + " [label=\"" + new StringBuilder(ending).reverse().toString() + "\"]");
            for(Pair<String, Map<Integer, Integer>> p : layer){
                boolean match = true;
                for(int a : p.getValue().keySet()){
                    if(node.keySet().contains(a) && !node.get(a).equals(p.getValue().get(a))){
                        match = false;
                    }
                }
                if(match){
                    System.out.print(p.getKey() + " -> " + name + "[label = \"");
                    int sum = 0;
                    for(int index : p.getValue().keySet()){
                        sum += g[index][layerNum] * p.getValue().get(index);
                    }
                    Set<Integer> remainIndices = new TreeSet<>();
                    remainIndices.addAll(node.keySet());
                    remainIndices.removeAll(p.getValue().keySet());
                    for(int index : remainIndices){
                        sum += g[index][layerNum] * node.get(index);
                    }
                    sum %= 2;
                    System.out.println(sum + "\"]");
                }
            }
        }
    }
}
import java.io.*;
import java.nio.*;
import java.util.*;
import java.util.stream.*;
import java.nio.file.*;

public class Migrator {
    public class DQ {
        public final int id;
        public final String  question;
        public final int max;
        private int count=0;
        public final boolean isQ;
    
        public String toString() {
            return "" + count;
        }
        public void setcnt(final String v) { count = Integer.parseInt(v); }
        public int getcnt() { return count; }
        public int cntplusone() { count++; return count;}
        public DQ(final String id, final String question, final String max, final boolean isQ) {
            this.id=Integer.parseInt(id);
            this.question=question;
            this.max=Integer.parseInt(max);//terrible name it is q for ch
            this.isQ = isQ;
        }
    
        }
    
        public DQ fromChoice(final String line) {
            final String[] p = line.split("\t");
            DQ dq = new DQ(p[4],p[0],p[5], false);
            dq.setcnt(p[6]);
            return dq;
        }
        public DQ from(final String line) {
            final String[] p = line.split("\t");
            return new DQ(p[0],p[2],p[3], true);
        }
        public HashMap<Integer, DQ> readQs(final String input, final char ch) {
            final ArrayList<String> l = new ArrayList<>();
            final HashMap<Integer, DQ> hm = new HashMap<>();
            try (Stream<String> stream = Files.lines(Paths.get(input))) {
                stream.forEach(e -> { 
                            if (! l.isEmpty()) { 
                                DQ parsed = ch == 'q' ? from(e) : fromChoice(e);
                                if (hm.containsKey(parsed.id)) { throw new RuntimeException("Duplicatie "  + parsed.id);}
                                hm.put(parsed.id, parsed);
                            }	
                            l.add(",");
    
                        });
            } catch (final IOException ex) {}
            return hm;
        }
        public int findId(final HashMap<Integer, DQ> map, final String q, boolean isQ, int qId) {
            for (int k : map.keySet()) {
                System.out.println("iiii "+ k);
                DQ dq = map.get(k);
                System.out.println("iiii "+ dq.question);

                if (isQ && dq.isQ) {
                    if (dq.question.contains(q)) {
                        return dq.id;
                    }
                    String[] ps = q.split("-");
                    if (dq.question.contains(ps[ps.length - 1].trim())) {
                        return dq.id;
                    }
                } else {
                    if (! dq.isQ && dq.max == qId && q.trim().equals(dq.question.trim())) {
                        return dq.id;
                    }
                }
            }
            return -1;
        }
        

    public class Dat {
        public final String en;
        public final String fa;
        public final String st;
        public final int val;
        public final int id;
        public final int qid;
        public int cnt;

        Dat(final String s, final String sep) {
            final String[] p = s.split(sep);
            en = p[0];
            fa = p[1];
            st = p[2];
            val = Integer.parseInt(p[3].trim());
            id = Integer.parseInt(p[4].trim());
            qid = Integer.parseInt(p[5].trim());
            cnt = Integer.parseInt(p[6].trim());
        }

        public String toString() {
            return "dbinfo:\tchoice_id: " + id + "\t q_id:" + qid + "\t q_en: \"" + en + "\"";
        }
    }

    public boolean match(String big, String small) {
        boolean res = false;
        if (big.contains("-")) {
            res = big.trim().split("-")[1].trim().equals(small.trim());
        }
        if (res) {
            //System.out.println("... comapring" + big + " & " + small + "true");
        } else {
            res = big.equals(small);
        }
        return res;
    }

    final static String PATH = "/Users/bchangiz/gozar/nameddata/march16/";
    final static HashMap<Integer, Integer> partToQId = new HashMap<>();

    public static void main(final String[] args) {
        final Migrator migrator = new Migrator();

        final HashMap<Integer, DQ> qs = migrator.readQs(PATH + "q.tsv", 'q');
		final HashMap<Integer, DQ> chs = migrator.readQs(PATH + "ch.tsv", 'c');


        final HashMap<Integer, Integer> chIdCount = new HashMap<>();
        final HashMap<Integer, Dat> allCh = migrator.loadCh();
        final List<String[]> content = new ArrayList<String[]>();

        try (final Stream<String> stream = Files.lines(Paths.get(PATH + "input.tsv"))) {
            stream.forEach(e -> { content.add(e.split("\t")); });
        }catch (final IOException ex) {
            ex.printStackTrace();
        }

        migrator.process(content, qs, chs);
    }


    

    public void process(final List<String[]> content, HashMap<Integer, DQ> qs, HashMap<Integer, DQ> chs) {
            final int MAX = content.get(0).length;
            int qIndexStart = -1;
            for (int i=0; i<MAX && qIndexStart == -1; i++) {
                String line = content.get(0)[i].trim();
                if (line.startsWith("Q") && Character.isDigit(line.charAt(1))) {
                    qIndexStart = i;
                }
            }
            
            List<String> out = new ArrayList<String>();

            for (int i = qIndexStart; i< MAX; i++) {
                String txt = content.get(1)[i].trim();
                int qId = findId(qs, txt, true, -1);
                out.add(content.get(0)[i].trim() + "\t" + content.get(2)[i].trim() + "\t" + qId + "\t" + txt + "\t" + (qId > -1 ? qs.get(qId).max : "unknown"));

                for (int j = 3; j < content.size(); j++) {
                    txt = content.get(j)[i].trim();
                    out.add(content.get(0)[i].trim() + "\t" + content.get(2)[i].trim() + "\t" + 
                         findId(chs, content.get(j)[i].trim(), false, qId) + "\t" + qId + "\t" + txt);
                }
            }
                 

        




        System.out.println("RESULT-------" + out.size());
        out.forEach(e -> {
            //Dat dat = allCh.get(e.getKey());
            //dat.cnt += e.getValue();
            //allCh.put(e.getKey(), dat);
            System.out.println("ggg"+e);
        });
    }

    public HashMap<Integer, Dat> loadCh() {
        final HashMap<Integer, Dat> allCh = new HashMap<>();
        final String FILE = "allchoices.tsv";
        try (final Stream<String> stream = Files.lines(Paths.get(PATH + FILE))) {
            stream.forEach(e -> {
                if (!(e.contains("choice_en") && e.contains("choice_fa"))) {
                    // status value id question count")) {
                    Dat d = new Dat(e, "\t");
                    partToQId.put(partToQId.size(), d.id);
                    assert (!allCh.containsKey(d.id));
                    allCh.put(d.id, d);
                }
            });

        } catch (final IOException ex) {
        }
        return allCh;
    }
}
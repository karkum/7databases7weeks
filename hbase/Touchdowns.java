  3 import org.apache.hadoop.hbase.KeyValue;
  4 import org.apache.hadoop.hbase.filter.Filter;
  5 import org.apache.hadoop.hbase.filter.ValueFilter;
  6 import org.apache.hadoop.hbase.filter.CompareFilter;
  7 import org.apache.hadoop.hbase.filter.RegexStringComparator;
  8 import org.apache.hadoop.conf.Configuration;
  9 import org.apache.hadoop.hbase.HBaseConfiguration;
 10 import org.apache.hadoop.hbase.client.Get;
 11 import org.apache.hadoop.hbase.client.HTable;
 12 import org.apache.hadoop.hbase.client.Put;
 13 import org.apache.hadoop.hbase.client.Result;
 14 import org.apache.hadoop.hbase.client.ResultScanner;
 15 import org.apache.hadoop.hbase.client.Scan;
 16 import org.apache.hadoop.hbase.util.Bytes;
 17 
 18 public class Touchdowns {
 19     public static void main(String[] args) throws IOException {
 20         Configuration config = HBaseConfiguration.create();
 21         HTable table = new HTable(config, "nflplays");
 22 
 23         Scan s = new Scan();
 24         s.setMaxVersions();
 25         s.addColumn(Bytes.toBytes("play"), Bytes.toBytes("description"));
 26 
 27         Filter tdFilter = new ValueFilter(CompareFilter.CompareOp.EQUAL, new RegexStringComparator(".*TOUCHDOWN.*"));
 28         s.setFilter(tdFilter);
 29 
 30         ResultScanner scanner = table.getScanner(s);
 31         try {
 32             for (Result result : scanner) {
 33                 for (KeyValue kv : result.raw()) {
 34                     System.out.println("KV: " + kv + ", Value: " + Bytes.toString(kv.getValue()));
 35                 }
 36             }
 37         } finally {
 38            scanner.close();
 39         }
 40     }
 41 }

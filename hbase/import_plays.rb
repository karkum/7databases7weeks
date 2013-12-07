include Java
import org.apache.hadoop.hbase.client.HTable
import org.apache.hadoop.hbase.client.Put
import javax.xml.stream.XMLStreamConstants

def jbytes( *args )
  args.map { |arg| arg.to_s.to_java_bytes }
end

def parse_row(row)
  map = {}
  values = row.split(',')
  map['gameid'] = values[0]
  map['qtr'] = values[1]
  map['min'] = values[2].nil? ? "" : values[2]
  map['sec'] = values[3].nil? ? "" : values[3]
  map['off'] = values[4].nil? ? "" : values[4]
  map['def'] = values[5].nil? ? "" : values[5]
  map['down'] = values[6].nil? ? "" : values[6]
  map['togo'] = values[7].nil? ? "" : values[7]
  map['ydline'] = values[8].nil? ? "" : values[8]
  map['description'] = (values[1].to_i >= 4 and values[2].to_i == 0 and map['down']=="" and map['togo']=="") ? "Game Over" : values[9]
  map['offscore'] = values[10].nil? ? "" : values[10]
  map['defscore'] = values[11].nil? ? "" : values[11]
  map['season'] = values[12].nil? ? "" : values[12] 
  return map
end

def put_into_hbase(document, play_number)
  table = HTable.new(@hbase.configuration, 'nflplays')
  table.setAutoFlush(false) 
  document.each do |key, value|
    rowkey = document['gameid'].to_java_bytes
    ts = play_number 

    p = Put.new(rowkey, ts) 
    p.add(*jbytes("play", key, value))
    table.put(p)
    
    puts play_number.to_s + ":" + key.to_s + ":" + value.to_s
  end 
  table.flushCommits()
end

count = 1
seen_before = {}
File.open('mine/300.csv', 'r:utf-8').each_line do |row|
  data = parse_row(row.strip!)
  if !seen_before.has_key?(data['gameid'])
    count = 1
    seen_before[data['gameid']] = true
  end
  
  put_into_hbase(data, count)
  count += 1
end
exit

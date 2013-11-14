require 'java'

import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'

def jbytes(*args)
    args.map{ |arg| arg.to_s.to_java_bytes}
end

def put_many(table_name, row, column_values)
    table = HTable.new(@hbase.configuration, table_name)
    p = Put.new(*jbytes(row))

    column_values.map { |key, value|
        column_qualifier = key.split(":")

        column_family = column_qualifier[0]
        column = column_qualifier[1]
        column ||= ""

        p.add(*jbytes(column_family, column, value))
    }   
    table.put(p)
end

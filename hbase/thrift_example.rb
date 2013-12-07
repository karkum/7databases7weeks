$:.push('./gen-rb')
require 'rubygems'
require 'thrift'
require 'Hbase'

socket = Thrift::Socket.new('50.16.158.226', 9090)
transport = Thrift::BufferedTransport.new(socket)
protocol = Thrift::BinaryProtocol.new(transport)
client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)

transport.open()

client.getTableNames().sort.each do |table|
    puts "#{table}"
    client.getColumnDescriptors(table).each do |col, desc|
        puts "  #{desc.name}"
        puts "    maxVersions: #{desc.maxVersions}"
        puts "    bloomFilterType: #{desc.bloomFilterType}"
        puts "    compression: #{desc.compression}"
    end
end

transport.close()

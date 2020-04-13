require_relative 'order_entries'
require_relative 'recharge_calls'
require "csv"
require "date"

class LogProcessor
    SUFFIX = '.log'
    
    def initialize(processing_type)
        @processing_type = processing_type
        if(processing_type == 'orders')
            @order_entries = OrderEntries.new
        else
            @recharge_calls = RechargeCalls.new
        end
    end

    def process_line(line)
        if(@processing_type == 'orders')
            @order_entries.count_entries(line)
        else
            @recharge_calls.parse_line(line)
        end
    end

    def get_files(dir)
        entries = Dir.entries(dir)
        #puts entries
        return entries
    end

    def process_directory(dir)
        files = get_files(dir)
        files.each do |file_name|
            #puts item
            if(file_name[SUFFIX])
                File.foreach(file_name) do |line| 
                    process_line(line)
                #    @log_entries[pl.fields["customer_id"].to_s] = pl.fields                   
                end
            end
        end
        
    end

    def create_csv()
        first = true

        csv_string = CSV.generate do |csv|
            values = @log_entries.values
            values.each do |pl|
                if(first)
                    csv << pl.keys
                    first = false
                end
                csv << pl.values
            end
        end
        puts csv_string

        file_name = 'skips_as_of_' + Date.today.to_s + '.csv'
        open(file_name, 'w') do |f|
            f.puts(csv_string)
        end
    end

    def process_logs()
        process_directory('.')
        if(@processing_type == 'orders')
            @order_entries.print_counts
        else
            @recharge_calls.print_counts
        end
    end
end 

processing_type = 'orders'
processing_type = 'ops'
lp = LogProcessor.new(processing_type)
lp.process_logs()

#lp.process_file("logfile")
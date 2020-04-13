require 'json'

class OrderEntries

    def initialize()
        @daily_orders = {}
    end

    def count_entries(line)
        label = "order\/processed"
        if line.include? label
            log_date = extract_date(line)
            count = @daily_orders[log_date]
            if !count
                @daily_orders[log_date] = 1                
            else
                @daily_orders[log_date] += 1
            end
            #puts count
        end
    end

    def extract_date(line)
        begin
            #parts = date_string.split('ID ')
            regex = /\d{4}-\d{2}-\d{2}/
            log_date = line[regex]
            #puts log_date
        rescue => exception
            puts "\n exception on extract date"
            puts exception.message
            puts date_string
        end
        log_date
    end

    def print_counts
        @daily_orders.each { |key, value| puts "#{key} #{value}" }
    end


end
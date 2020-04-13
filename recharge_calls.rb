require "json"


class RechargeCalls
    attr_reader :fields

    def initialize()
        @counts = Hash.new(0)
    end

    def parse_line(line)
        begin
            #puts line
            if(line.include? "GET ")
                x = line.split('443/')
            #    puts x
                extract_operations(x[1])
            end
        rescue => exception
            puts "\n exception in parse_line"
            puts exception.message
            puts line
        end

    end

    def extract_operations(s)
        #puts(s)
        if(s.include? 'limit')
            x = s.split('?')
            op = x[0]
            t = x[1].split('=')[1]
            k = t.split('&')[0]
            @counts[k] += 1
        elsif(s.include? 'count?')
            #subscriptions/count?customer_id=39633804 ""
            x = s.split('?')
            op = x[0]
            id = x[1].split('=')[1].split(' ')[0]
            @counts[op +'/' + id] += 1
        else
            k = s.split(' ')[0]
            @counts[k] += 1
        end
        #puts("counts[#{k}]: #{@counts[k]}") 


    end

    def extract_date_and_id(date_string)
        begin
            parts = date_string.split('ID ')
            regex = /\d{4}-\d{2}-\d{2}/
            @fields['cancel_date'] = parts[0][regex]
            @fields['subscription_id'] = parts[1].split(']')[0].strip
        rescue => exception
            puts exception.message
            puts date_string
        end
    end

    def print_counts
        ones = 0
        twos = 0
        threes = 0
        @counts.each do |k,v|
            if(v == 1)
                ones += 1
            elsif (v ==2)
                twos += 1
            elsif (v== 3)
                threes += 1
            else
                puts("#{k}:#{v}")
            end
        end
        puts("ones: #{ones}")
        puts("twos: #{twos}")
        puts("threes: #{threes}")
    end


end
require "json"


class LogEntry
    attr_reader :fields

    def initialize()
        @fields = Hash.new
    end

    def parse_line(line)
        begin
            x = line.split('SKIP: ')
            #puts x
            #puts("----------------")
            extract_date_and_id(x[0])
            extract_json(x[1])
            #puts @fields            
        rescue => exception
            puts "\n exception in parse_line"
            puts exception.message
            puts line
        end

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

    def extract_json(json_string)
        j = JSON.parse(json_string)
        @fields["address_id"] = j["address_id"]
        @fields["created_at"] = j["created_at"]
        @fields["customer_id"] = j['customer_id']
        @fields["id"] = j["id"]
        @fields["next_charge_scheduled_at"] = j["next_charge_scheduled_at"]
        @fields["price"] = j["price"]
        @fields["recharge_product_id"] = j["recharge_product_id"]
        @fields["shopify_product_id"] = j["shopify_product_id"]
        @fields["shopify_variant_id"] = j["shopify_variant_id"]
        @fields["sku"] = j["sku"]
        @fields["status"] = j["status"]
        @fields["updated_at"] = j["updated_at"]
        @fields["variant_title"] = j["variant_title"]
        @fields["cancellation_reason"] = j["cancellation_reason"]
        @fields["cancellation_reason_coments"] = j["cancellation_reason_comment"]
        @fields["is_prepaid"] = j["properties"][6]["value"]
        #puts @fields
    end


end
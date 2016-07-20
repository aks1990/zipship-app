class Demo < ActiveRecord::Base
	def self.to_csv
	    attributes = %w{pincode}

	    CSV.generate(headers: true) do |csv|
	    csv << ['pincodes']

	      all.each do |pin|
	        csv << attributes.map{ |attr| pin.send(attr) }
	      end
	    end
  	end
end

class Zip < ActiveRecord::Base
	def self.to_csv
	    attributes = %w{pincode}

	    CSV.generate(headers: false) do |csv|
	    

	      all.each do |pin|
	        csv << attributes.map{ |attr| pin.send(attr) }
	      end
	    end
  	end
end

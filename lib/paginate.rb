class Paginate
	def pages max_page, per_page, page_id
		
		per_page 	  = [max_page, per_page].min
		page_id 	  = page_id.to_i		
		center_page = (per_page/2.to_f).floor

		if page_id < center_page + 1
			from = 0
			to   = per_page

		elsif page_id > max_page - center_page
			from = max_page - per_page
			to = max_page	

		else			
			if per_page/2 == 0
				from = page_id - center_page
				to   = page_id + center_page
			else
			
				if page_id - center_page - 1 < 0
					from = 0
					to   = page_id + center_page + 1
				else
					from = page_id - center_page - 1
					to   = page_id + center_page
				end
				
			end			
		end

		{:from => from, :to => to}

	end
end



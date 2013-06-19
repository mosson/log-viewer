class Paginate
	def pages max_log, per_page
		max_log/per_page.ceil
	end
end



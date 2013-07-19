module ReportsHelper

	def theaders(thead)
		header = ""
		thead.each do |head|
			header += "<th width='150'>" + head.to_s + "</th>" 
		end
		header
	end

	def tbody(rows)
		rows_header = ""
		rows.each do |key, value|
			rows_header += "<tr><td>" + head.to_s + "</td>" 
		end
		rows_header
	end

	def pagination(current, total)
		pagination = ""
		current_class = ""
		start = 1
		if current % 4 == 1
			start = current
		elsif current % 4 == 0
			start = current - 3
		else 
			start = current - ((current % 4) - 1)
		end
		if total > start
			unavailable = current == 1 ? "unavailable" : ""
			pagination += "<li class='arrow left_pagination " + unavailable + "'><a href=''>&laquo;</a></li>"
			(start.to_i..total).each do |pag|
				if pag == (start + 5) && pag< (total - 2)
					pagination += "<li class='unavailable'><a href=''>&hellip;</a></li>"
				elsif pag > (start + 5) && pag < (total - 2)	
					next						 		 	
				else
					current_class = current == pag ? "class='current'" : ""
					pagination += "<li " + current_class + " data-page='" + pag.to_s + "'><a href=''>" + pag.to_s + "</a></li>" 				
				end
			end
			unavailable = current == total ? "unavailable" : ""
			pagination += "<li class='arrow right_pagination " + unavailable + "'><a href=''>&raquo;</a></li>"
		end
		pagination
	end

	def replace_nil(value, replace)
		value.presence || replace
	end
end

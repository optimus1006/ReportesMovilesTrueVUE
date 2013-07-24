module ReportsHelper

	def theaders(thead)
		header = ""
		thead.each do |head|
			header += "<th width='150'>" + head.to_s + "</th>" 
		end
		header
	end

	def tbody(rows, colums)
		rows_body = ""
		if rows.length < 1      
        	rows_body += "<tr>"	
          	rows_body += "<td colspan='" + colums.length.to_s + "'>" + I18n.t('reports.no_results') + "</td>"
        	rows_body += "</tr>"
       	else
			rows.each do |row|
				rows_body += "<tr>" 
				colums.each do |column|
					value = ""
					if column.include? "COUNT"	
				      	value = replace_nil(row[column.to_s], "0")
				    elsif column.include? "RATE"
				      	value = replace_nil(row[column.to_s], "0.0")
				      	value = number_to_percentage(value.to_f, precision: 2) unless value == "0.0"
				    elsif column.include? "SALES"
				      	value = replace_nil(row[column.to_s], "0.0")
				      	value = number_to_currency(value.to_f, precision: 2) unless value == "0.0"
				    elsif column.include? "DATE"
						value = row[column.to_s].strftime('%d/%m/%Y')
					else	
						value = row[column.to_s]				    
				    end
					rows_body += "<td>" + value.to_s + "</td>"
				end
				rows_body += "</tr>" 
			end
		end
		rows_body
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
		if value.nil? || value.to_s.empty?
			return replace
		end
		value
	end
end

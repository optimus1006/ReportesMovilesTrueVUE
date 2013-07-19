module HomeHelper

	def alert(error)
		alert = ""
		unless error.nil?
			alert = '<div data-alert class="alert-box alert round">' + error.to_s + "</div>"
		end
		alert
	end
end

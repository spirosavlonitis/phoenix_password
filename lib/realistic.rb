module Realistic


	def check_five(data)

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{6}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{6}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/^([a-z]{3}[0-9]{2}|[0-9]{3}[a-z]{2}|[0-9]{3}[a-z]{2}|[0-9]{2}[a-z]{3})$/i)
		end
		return true	
	end

	def check_six(data)

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{6}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{6}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/^([a-z]{3}[0-9]{3}|[0-9]{3}[a-z]{3})$/i)
		end
		return true	
	end

	def check_seven(data)
		
		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{7}/i)
		end
		
		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{7}/)
		end
		
		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/([a-z]{4}[0-9]{3}|[a-z]{3}[0-9]{4}|[0-9]{4}[a-z]{3}|[0-9]{3}[a-z]{4})/i)
		end


		return true
	end

	def check_eight(data)


		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{8}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{8}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/([a-z]{4}[0-9]{4}|[0-9]{4}[a-z]{4})/i)
		end
		return true
	end

	def check_nine(data)


		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{9}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{9}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/([a-z]{5}[0-9]{4}|[a-z]{4}[0-9]{5}|[0-9]{5}[a-z]{4}|[0-9]{4}[a-z]{5})/i)
		end

		return true
	end

	def check_ten(data)


		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{10}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{10}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)
		
		if @strictness >=1
			return false if data[:combination].match(/([a-z]{5}[0-9]{5}|[0-9]{5}[a-z]{5})/i)
		end
		
		return true
	end

	def check_eleven(data)

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{11}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{11}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/([a-z]{5}[0-9]{6}|[a-z]{6}[0-9]{5}|[0-9]{5}[a-z]{6}|[0-9]{6}[a-z]{5})/i)
		end

		return true
	end

	def check_twelve(data)


		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{12}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{12}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/([a-z]{6}[0-9]{6}|[0-9]{6}[a-z]{6})/i)
		end
		return true
	end


	def check_thirteen(data)


		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{13}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{13}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/([a-z]{7}[0-9]{6}|[a-z]{6}[0-9]{7}|[0-9]{7}[a-z]{6}|[0-9]{6}[a-z]{7})/i)
		end
		return true
	end

	def check_fourteen(data)
		

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{14}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{14}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)


		if @strictness >=1
			return false if data[:combination].match(/([a-z]{7}[0-9]{7}|[0-9]{7}[a-z]{7})/i)
		end

		return true
	end

	def check_fifteen(data)


		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{15}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{15}/i)
		end

		return false if data[:combination].match(/([a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}|
		[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1}[0-9]{1}[a-z]{1})/)

		if @strictness >=1
			return false if data[:combination].match(/([a-z]{7}[0-9]{8}|[a-z]{8}[0-9]{7}|[0-9]{7}[a-z]{8}|[0-9]{8}[a-z]{7})/i)
		end
		return true
	end

	def rules_pass?(data)
		if data[:cmb_length] == 5
			return check_five(data)
		elsif data[:cmb_length] == 6
			return check_six(data)
		elsif data[:cmb_length] == 7
			return check_seven(data)
		elsif data[:cmb_length] == 8
			return check_eight(data)
		elsif data[:cmb_length] == 9
			return check_nine(data)
		elsif data[:cmb_length] == 10
			return check_ten(data)
		elsif data[:cmb_length] == 11
			return check_eleven(data)
		elsif data[:cmb_length] == 12
			return check_twelve(data)
		elsif data[:cmb_length] == 13
			return check_thirteen(data)
		elsif data[:cmb_length] == 14
			return check_fourteen(data)
		elsif data[:cmb_length] == 15
			return check_fifteen(data)
		else
			return true
		end
	end	
end
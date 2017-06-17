module Realistic

	def gen_rule_pass?(data)
		combination=data[:combination].join()
		alternating=combination.scan(/[0-9]{1}[a-z]{1}/i).length
		alternating_reverse=combination.scan(/[a-z]{1}[0-9]{1}/i).length
		if (data[:cmb_length] % 2 == 0) && (alternating == data[:cmb_length]/2  || alternating_reverse == data[:cmb_length]/2 )
			return false
		elsif (data[:cmb_length] % 2 == 1) && (alternating == (data[:cmb_length]-1)/2 || alternating_reverse == (data[:cmb_length]-1)/2 )
			return false
		end

		return true
	end

	def rules_pass?(data)
		if data[:cmb_length] == 6
			return check_six(data)
		elsif data[:cmb_length] == 7
			return check_seven(data)
		elsif data[:cmb_length] == 8
			return check_eight(data)
		elsif data[:cmb_length] == 9
			return check_nine(data)
		elsif data[:cmb_length] == 10
			return check_ten(data)
		else
			return true
		end

	end

	def check_six(data)
		half_check=data[:combination].match(/^([a-z]{3}[0-9]{3}|[0-9]{3}[a-z]{3})$/i)
		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{6}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{6}/i)
		end

		return true	
	end

	def check_seven(data)
		half_check=data[:combination].match(/([a-z]{4}[0-9]{3}|[a-z]{3}[0-9]{4}|[0-9]{4}[a-z]{3}|[0-9]{3}[a-z]{4})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{7}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{7}/i)
		end
		return true
	end

	def check_eight(data)
		half_check=data[:combination].match(/([a-z]{4}[0-9]{4}|[0-9]{4}[a-z]{4})/i)
		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{8}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{8}/i)
		end
		return true
	end

	def check_nine(data)
		half_check_a=data[:combination].match(/([a-z]{5}[0-9]{4}|[a-z]{4}[0-9]{5}|[0-9]{5}[a-z]{4}|[0-9]{4}[a-z]{5})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{9}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{9}/i)
		end
		return true
	end

	def check_ten(data)
		half_check=data[:combination].match(/([a-z]{5}[0-9]{5}|[0-9]{5}[a-z]{5})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{10}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{10}/i)
		end
		return true
	end

	def check_eleven(data)
		half_check_a=data[:combination].match(/([a-z]{5}[0-9]{6}|[a-z]{6}[0-9]{5}|[0-9]{5}[a-z]{6}|[0-9]{6}[a-z]{5})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{11}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{11}/i)
		end
		return true
	end

	def check_twelve(data)
		half_check=data[:combination].match(/([a-z]{6}[0-9]{6}|[0-9]{6}[a-z]{6})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{12}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{12}/i)
		end
		return true
	end


	def check_thirteen(data)
		half_check_a=data[:combination].match(/([a-z]{7}[0-9]{6}|[a-z]{6}[0-9]{7}|[0-9]{7}[a-z]{6}|[0-9]{6}[a-z]{7})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{13}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{13}/i)
		end
		return true
	end

	def check_fourteen(data)
		half_check=data[:combination].match(/([a-z]{7}[0-9]{7}|[0-9]{7}[a-z]{7})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{14}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{14}/i)
		end
		return true
	end

	def check_fifteen(data)
		half_check_a=data[:combination].match(/([a-z]{7}[0-9]{8}|[a-z]{8}[0-9]{7}|[0-9]{7}[a-z]{8}|[0-9]{8}[a-z]{7})/i)

		return false if half_check

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{15}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{15}/i)
		end
		return true
	end
end
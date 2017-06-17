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

		else
			return true
		end

	end

	def check_six(data)
		half_check_a=data[:combination].match(/[a-z]{3}[0-9]{3}/i)
		half_check_b=data[:combination].match(/[0-9]{3}[a-z]{3}/i)
		return false if half_check_a || half_check_b

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{6}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{6}/i)
		end

		return true	
	end

	def check_seven(data)
		half_check_a=data[:combination].match(/[a-z]{4}[0-9]{3}/i)
		half_check_b=data[:combination].match(/[a-z]{3}[0-9]{4}/i)
		half_check_c=data[:combination].match(/[0-9]{4}[a-z]{3}/i)
		half_check_d=data[:combination].match(/[0-9]{3}[a-z]{4}/i)
		return false if half_check_a || half_check_b || half_check_c || half_check_d

		if @strictness >= 2
			return false if data[:combination].match(/[0-9]{7}/)
		end

		if @strictness >= 3
			return false if data[:combination].match(/[A-Z]{7}/i)
		end
		return true
	end
end
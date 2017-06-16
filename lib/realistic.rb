module Realistic

	def gen_rule_pass?(data)
		combination=data[:combination].join()
		alternating=combination.scan(/[0-9]{1}[a-z]{1}/).length
		alternating_reverse=combination.scan(/[0-9]{1}[a-z]{1}/).length
		if (data[:cmb_length] % 2 == 0) && (alternating == data[:cmb_length]/2  || alternating_reverse == data[:cmb_length]/2 )
			return false
		elsif (data[:cmb_length] % 2 == 1) && (alternating == (data[:cmb_length]-1)/2 || alternating_reverse == (data[:cmb_length]-1)/2 )
			return false
		else
			return true			
		end

	end

	def rules_pass?(data)
		if data[:cmb_length] == 6
		
		elsif data[:cmb_length] == 7
			return check_seven(data)

		else
			return true
		end

	end

	def check_seven(data)
		half_check_a=data[:combination].match(/[a-z]{4}[0-9]{3}/)
		half_check_b=data[:combination].match(/[0-9]{4}[a-z]{3}/)

		return false if half_check_a || half_check_b

		if data[:type] == 'matching'

		else
			
		end

		return true

	end

	def cmb_length_six(data)
		half_check=d

		if @type == 'matching'
		
		else

		end

	end

end
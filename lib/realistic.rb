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
		
	end


	def cmb_length_six(data)
		
		if @type == 'matching'
		
		else

		end

	end

end
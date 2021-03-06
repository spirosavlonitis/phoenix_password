require "phoenix_password/version"
require_relative 'realistic'
require_relative 'file_size'

class PhoenixPassword
	prepend Realistic
	prepend FileSize

	def initialize(data={})
		@rules=data[:rules]
		@strictness=data[:strictness] ? data[:strictness] : 0
		@own_rules=data[:own_rules] if data[:own_rules].is_a?(Array) && data[:own_rules][0].is_a?(Regexp)
		@checkpoint=data[:checkpoint]
		@restore=data[:restore]

		if data[:checkpoint] || data[:restore]
			require 'mysql2'
			@client=Mysql2::Client.new({:host=>'localhost',:username=>'phoenix',
			:password=>'Gordian100!',:database=>'phoenix_password'})
			if data[:checkpoint]
			  @check_fraction=data[:check_fraction] ? data[:check_fraction] : 2
			  @check_cmb=data[:check_cmb]			  
			end

			if data[:restore]
			  @restore_cmb=data[:restore_cmb]
			  @restored=false
			end
		end
	end


	def set_check_point(possible_combinations,characters,cmb_length,combination,chars_used,i)
		if @check_cmb
			if @restore
			       if i == (possible_combinations/(characters.length*@check_fraction))+@i && cmb_length == @check_cmb
				  @client.query("update checkpoint set combination='#{combination.join()}',chars_used='#{chars_used}',i=#{i} where id=1")
				  @client.close
				  if !@piped
				    @fh.close
				    puts "Checkpoint set"
				  end
				  exit
				elsif cmb_length > @check_cmb
				    @client.query("update checkpoint set combination='#{Array.new(cmb_length,characters.first).join()}',chars_used='#{Array.new(cmb_length,0)}',i=0 where id=1")
				    @client.close
					if !@piped
						puts "#{@type} combinations of length #{@check_cmb} finished"
					    puts "Check point set to the begining of #{cmb_length} combinations"
					    puts "Set :restore_cmb=>#{cmb_length}"
					    puts "If planning to use checkpoint set check_cmb=>#{cmb_length}"
					    @fh.close
				    end
				    exit
				end
			else
				if i == possible_combinations/(characters.length*@check_fraction) && cmb_length == @check_cmb
				  @client.query("update checkpoint set combination='#{combination.join()}',chars_used='#{chars_used}',i=#{i} where id=1")
				  @client.close
				  if !@piped
				    @fh.close
				    puts "Checkpoint set"
				  end
				  exit
				end
			end
		else
			if @restore
				if i == (possible_combinations/(characters.length*@check_fraction))+@i
				  @client.query("update checkpoint set combination='#{combination.join()}',chars_used='#{chars_used}',i=#{i} where id=1")
				  @client.close				  
				  if !@piped
				    @fh.close
					puts "Checkpoint set"
				  end
				  exit
				end
			else
				if i == possible_combinations/(characters.length*@check_fraction)
				  @client.query("update checkpoint set combination='#{combination.join()}',chars_used='#{chars_used}',i=#{i} where id=1")
				  @client.close				  
				  if !@piped
				    @fh.close
					puts "Checkpoint set"
				  end
				  exit
				end
			end
		end
	end

	#Added for all
	def add_all_combinations(data)

		combinations=[]
		combination=data[:combination]
		characters=data[:characters]
		if data[:extra_chars].nil? || data[:iteration] == 0
		 	combinations.<<(combination.join())
		 if combination.last != characters.first
			reverse_comb=combination.reverse
		    combinations.<<(reverse_comb.join())

			reverse_comb.pop
			reverse_compare=reverse_comb
			reverse_comb=reverse_comb.join()
			characters.each do |char|
			   next if char == characters.first
 			   combinations.<<("%s%s"%[reverse_comb,char])

			end
		 end

		else
		 combinations << combination.join() if combination.include?(characters.last)
	     if combination.last != characters.first
				reverse_comb=combination.reverse 
			    reverse_comb.pop
			    reverse_compare=reverse_comb
			    reverse_comb=reverse_comb.join
			if reverse_comb.include?(characters.last)
				characters.each do |char|
					combinations.<<("%s%s"%[reverse_comb,char])
				end
			else						
 			    combinations.<<("%s%s"%[reverse_comb,characters.last])
			end
		 end
		end
		return combinations
	end

	def generate_combinations(data)
		characters=data[:characters]
		if !data[:extra_chars].nil?
			characters.push(data[:extra_chars][data[:iteration]-1])  if data[:iteration] != 0
		end
		combination=Array.new(data[:cmb_length],data[:characters].first)
		combination_length=combination.length
		i=0
		possible_combinations=characters.length**combination_length
		chars_used=Array.new(data[:cmb_length],0)

		if @restore && !@restored
			 restore=@client.query("select * from checkpoint where id=1")
			 combination=restore.to_a[0]["combination"].split('')
			 chars_used=restore.to_a[0]["chars_used"]
			 chars_used=chars_used.gsub(/[^0-9,]/,'')
			 chars_used=chars_used.split(',')
			 c=0
			 chars_used.each do |char|
			 	chars_used[c]=char.to_i
			 	c+=1
			 end
			 i=restore.to_a[0]["i"]
			 @i=i
			 @restored=true
		end

		while i < possible_combinations/characters.length
			if @checkpoint
			  set_check_point(possible_combinations,characters,data[:cmb_length],combination,chars_used,i)
			end
			x=1
			change_count=1
			while x < combination_length
				if chars_used[x] == characters.length
					chars_used[x] = 0
				end
				if combination[x] == characters.last && combination[x+1] == characters.last
					change_count +=1
					if change_count == combination_length -1
						chars_used[0] += 1
					end
				end
				x +=1
			end

			y=0
			until y == combination_length
				combination[y]=characters[chars_used[y]]
				y+=1
			end

			if @type == 'all'
				yield(add_all_combinations({:combination=>combination,:extra_chars=>data[:extra_chars],
				:characters=>characters,:cmb_length=>data[:cmb_length]}))
			else
				combinations=add_combinations({:combination=>combination,:extra_chars=>data[:extra_chars],
				:characters=>characters,:cmb_length=>data[:cmb_length],:type=>data[:type]})
				yield(combinations) if combinations.length >= 1
			end


			z=combination_length-1
			while 1 < z
				if  z == combination_length-1
					chars_used[z-1] +=1	if combination[z] == characters.last 
				else
					diff=(combination_length-1)-z
					last_chars=0
					count_diff=1
					while count_diff <= diff
						if combination[z] == characters.last && combination[z+count_diff] == characters.last
							last_chars +=1
						end
						count_diff +=1
					end
					if last_chars == (combination_length-1)-z
						chars_used[z-1] +=1
					end
				end
				z-=1
			end
			chars_used[combination_length-1] +=1
			i+=1
		end
		return characters
	end

	def add_combinations(data)

		combinations=[]
		combination=data[:combination]
		characters=data[:characters]
		if data[:extra_chars].nil? || data[:iteration] == 0
		 if @rules	
		    combinations.<<(combination.join()) if rules_pass?({:combination=>combination.join(),:cmb_length=>data[:cmb_length]})
		 else
		 	combinations.<<(combination.join())
		 end
		 if combination.last != characters.first
			reverse_comb=combination.reverse
		    if @rules	
		        combinations.<<(reverse_comb.join()) if rules_pass?({:combination=>reverse_comb.join(),:cmb_length=>data[:cmb_length]-1})
		    else
				combinations.<<(reverse_comb.join())
		    end
			reverse_comb.pop
			reverse_compare=reverse_comb
			reverse_comb=reverse_comb.join()
	        check_match= matching_check({:combination=>reverse_comb,:match_limit=>data[:match_limit],:cap_limit=>data[:cap_limit]})
			characters.each do |char|
				next if char == characters.first
				if  data[:type] == "unique"
					if @rules
					  combinations.<<("%s%s"%[reverse_comb,char]) if rules_pass?({:combination=>"%s%s"%[reverse_comb,char],:cmb_length=>data[:cmb_length]})
				    else
					  combinations.<<("%s%s"%[reverse_comb,char])
					end
				else
					if check_match
						if @rules
							combinations.<<("%s%s"%[reverse_comb,char]) if rules_pass?({:combination=>"%s%s"%[reverse_comb,char],:cmb_length=>data[:cmb_length]})
						else
							combinations.<<("%s%s"%[reverse_comb,char])
						end
					else							
						if @rules
						  combinations.<<("%s%s"%[reverse_comb,char]) if char == reverse_compare.last && rules_pass?({:combination=>"%s%s"%[reverse_comb,char],:cmb_length=>data[:cmb_length]})
						else
						  combinations.<<("%s%s"%[reverse_comb,char]) if char == reverse_compare.last
						end
					end
				end
			end
		 end

		else
			  	combinations << combination.join() if combination.include?(characters.last)
	     if combination.last != characters.first
				reverse_comb=combination.reverse 
			    reverse_comb.pop
			    reverse_compare=reverse_comb
			    reverse_comb=reverse_comb.join
			if reverse_comb.include?(characters.last)
	        	check_match= matching_check({:combination=>reverse_comb,:match_limit=>data[:match_limit],:cap_limit=>data[:cap_limit]}) if data[:type] == 'matching'
				characters.each do |char|
					if  data[:type] == "unique"
						combinations.<<("%s%s"%[reverse_comb,char])
					elsif check_match
						combinations.<<("%s%s"%[reverse_comb,char])
					else							
					    combinations.<<("%s%s"%[reverse_comb,char]) if char == reverse_compare.last
					end
				end
			else						
			  combinations.<<("%s%s"%[reverse_comb,characters.last])				
			end
		 end
		end
		return combinations
	end
	
	def all_combinations(info)
		data={:characters=>info[:characters],:cmb_length=>info[:cmb_length],:type=>info[:type]}
	    unless info[:extra_chars].nil?
	   	 	 data[:extra_chars]=info[:extra_chars]
	    end

	    create_file(info) if !info[:piped] && @fh.nil?

		char_sum=data[:characters].length
		total_characters=data[:characters].length
		unless data[:extra_chars].nil?
			total_characters=data[:characters].length+data[:extra_chars].length
			data[:iteration]=0
			if info[:skip_first] || !info[:piped]
				data[:iteration] +=1
				char_sum +=1
			end
		end
		
		all=0
		begin
		 generate_combinations(data) do |combinations|
		  combinations.each do |combination|
			 if info[:piped]
				puts combination
			 else
				@fh.puts(combination)
			 end
			 all +=1
		  end
		 end
			data[:iteration]+=1 unless data[:iteration].nil?
			char_sum +=1
		rescue => e
			raise
	    end while char_sum <= total_characters
		return all
	end	
	def matching_combinations(info)
		data={:characters=>info[:characters],:cmb_length=>info[:cmb_length],:type=>info[:type]}
	    unless info[:extra_chars].nil?
	   	 	 data[:extra_chars]=info[:extra_chars]
	    end

	    create_file(info) if !info[:piped] && @fh.nil?

		char_sum=data[:characters].length
		total_characters=data[:characters].length
		unless data[:extra_chars].nil?
			total_characters=data[:characters].length+data[:extra_chars].length
			data[:iteration]=0
			if info[:skip_first] || !info[:piped]
				data[:iteration] +=1
				char_sum +=1
			end
		end
		
		matching=0
		begin
		 generate_combinations(data) do |combinations|
		  combinations.each do |combination|
			if matching_check({:combination=>combination,:match_limit=>info[:match_limit],:cap_limit=>info[:cap_limit]})
				 if info[:piped]
					puts combination
				 else
					@fh.puts(combination)
				 end
			 matching +=1
			end
		  end
		 end
			data[:iteration]+=1 unless data[:iteration].nil?
			char_sum +=1
		rescue => e
			raise
	    end while char_sum <= total_characters
		
		return matching
	end

	def matching_check(info)
		combination=info[:combination]
		if info[:cap_limit]
		  caps=combination.scan(/[A-Z]/)
		  return false if caps.length == 0 || caps.length > info[:cap_limit]
		end
		i=0
		x=0
		u=0
		while i < (combination.length-1)
			if combination[i] == combination[i+1]
  	 	      return true if info[:match_limit].nil?
		 	  if i == 0
		 	     x +=1
		 	  elsif combination[i] == combination[i-1] 	|| combination[i] == combination[i+info[:match_limit]] 
		 	  	 x+=1		 	  			
		 	  end
		 	else 
		 		u +=1
			end
		    if x == info[:match_limit] || u == combination.length-1
			 return false
		    end
			i+=1
		end
		return true
	end

	def unique_combinations(info)
	   data={:characters=>info[:characters],:cmb_length=>info[:cmb_length],:type=>info[:type],:uniqueness_type=>info[:uniqueness_type]}
	   unless info[:extra_chars].nil?
	   		data[:extra_chars]=info[:extra_chars]
	   end

	   create_file(info) if !info[:piped] && @fh.nil?

	   total_characters=data[:characters].length
	   char_sum= data[:characters].length
	   unless data[:extra_chars].nil?
			total_characters=data[:characters].length+data[:extra_chars].length
			data[:iteration]=0
			if info[:skip_first] || !info[:piped]
				data[:iteration]+=1
				char_sum +=1
			end
	   end
	   unique_combs=0
	   uniqueness=info[:uniqueness_type]
	   begin
		generate_combinations(data) do |combinations|
		  combinations.each do |combination|
			 unique_chars=check_uniqueness(combination,uniqueness,info[:cap_limit])
		 	 if unique_chars == combination.length-1
				if info[:piped]
				  puts combination 
				else	
				  @fh.puts(combination)
				end
			    unique_combs= unique_combs+1
			 end
		  end
		end
		data[:iteration] +=1 if !data[:iteration].nil?
		char_sum +=1
		rescue => e
			raise
		end while char_sum <= total_characters
		
		return unique_combs
	end

	def check_uniqueness(combination,uniqueness,cap_limit)
	    if cap_limit
		  caps=combination.scan(/[A-Z]/)
		  return 0 if caps.length == 0 || caps.length > cap_limit
		end
		i=0
		unique_chars=0
		chars_check=[]
		while i < (combination.length-1)
			if combination[i] != combination[i+1]
			  if uniqueness.nil?
			     unique_chars+=1
			  elsif uniqueness == "single"
				   if i == 0
				   	  unique_chars+=1
				   	  chars_check.push(combination[i])
				   elsif !chars_check.include?(combination[i])
				   		chars_check << combination[i]
				   		if !chars_check.include?(combination[i+1])
				   			unique_chars +=1
				   		else
				   			return 0
				   		end
				   end
			  elsif uniqueness == "repeat"
				   	if i == 0
				   	  unique_chars+=1
				   	  chars_check.push(combination[i])
				   	elsif chars_check.include?(combination[i])
				   	   unique_chars+=1
				   	elsif i == (combination.length-2)
				   		#since in last iteration compare against the next character as well
				   		unique_chars +=1 if chars_check.include?(combination[i]) || chars_check.include?(combination[i+1])
				   	else  							   		
				   		chars_check.push(combination[i])
				   	end

				   	return combination.length-1 if i == (combination.length-2) && unique_chars > 1
			  end
			else
			 return 0
			end
			i+=1
		end
		return unique_chars
	end

	def multi_length(data)
		dataB=data.clone

		if @restore_cmb && @restore
			temp_cmbs=data[:cmb_length].clone
			temp_cmbs.each do |n|
				data[:cmb_length].delete(n) if n < @restore_cmb
			end
		end

		i=0
		while i < data[:cmb_length].length
			dataB[:cmb_length] = data[:cmb_length][i]
			dataB[:characters]=data[:characters].clone
			if data[:type] == 'unique'
			   unique_combinations(dataB)
			elsif data[:type] == 'matching'
			   matching_combinations(dataB)
			elsif @type == 'all'
			   all_combinations(dataB)
			end
			i+=1
		end
	end

	def combinations(data)
		@type=data[:type]
		@piped=data[:piped]
		puts "File size estimates are invalid when using rules" if @rules && !data[:piped]
		case data[:type]
	  	 when "matching"
	  	 	if data[:cmb_length].length == 1
	  	 	   data[:cmb_length]=data[:cmb_length][0]
			   matching_combinations(data)
			else
				data[:write_cmbs]=data[:cmb_length].clone
				multi_length(data)
	  	 	end
		 when "unique"
		 	if data[:cmb_length].length == 1
		 		data[:cmb_length]=data[:cmb_length].first
		 		unique_combinations(data)
		 	else
				data[:write_cmbs]=data[:cmb_length].clone
				multi_length(data)
		 	end
		 when "all"
		 	if data[:cmb_length].length == 1
		 		data[:cmb_length]=data[:cmb_length].first
		 		all_combinations(data)
		 	else
				data[:write_cmbs]=data[:cmb_length].clone
				multi_length(data)
		 	end
		 else
		 	puts "Invalid combination type"
		 	exit
		end
		if !@piped
		  @fh.close
		  @client.close if @client
		  puts "File created"
		end
	end
end
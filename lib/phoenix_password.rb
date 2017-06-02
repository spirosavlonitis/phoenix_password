require "phoenix_password/version"

class PhoenixPassword
	def self.generate_combinations(data)
		characters=data[:characters]
		if !data[:extra_chars].nil?
			characters.push(data[:extra_chars][data[:iteration]-1])  if data[:iteration] != 0
		end
		combination=Array.new(data[:cmb_length],data[:characters].first)
		combination_length=combination.length
		i=0
		possible_combinations=characters.length**combination_length
		chars_used=Array.new(data[:cmb_length],0)
		
		while i < possible_combinations/characters.length
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

			combinations=[]
			if data[:extra_chars].nil? || data[:iteration] == 0
				combinations.<<(combination.join())
				if combination.last != characters.first
					reverse_comb=combination.reverse
					combinations.<<(reverse_comb.join())
					reverse_comb.pop
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

			yield(combinations) if combinations.length >= 1

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
	
	def self.matching_combinations(info)
		data={:characters=>info[:characters],:cmb_length=>info[:cmb_length],:type=>info[:type]}
	    unless info[:extra_chars].nil?
	   	 	 data[:extra_chars]=info[:extra_chars]
	    end

		matching_file=create_file(info) if !info[:piped]

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
			if matching_check({:combination=>combination,:match_limit=>info[:match_limit]})
			 if info[:piped]
					puts combination
			 elsif !matching_file.nil?
			 	if data[:extra_chars].nil?
						matching_file.puts(combination)
				elsif data[:iteration] >= 1
					matching_file.puts(combination)
				end
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
		matching_file.close unless matching_file.nil?
		return matching
	end

	def self.matching_check(info)
		combination=info[:combination]
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

	def self.unique_combinations(info)	 
	   data={:characters=>info[:characters],:cmb_length=>info[:cmb_length],:type=>info[:type]}
	   unless info[:extra_chars].nil?
	   		data[:extra_chars]=info[:extra_chars]
	   end

 	   unique_file=create_file(info) unless info[:piped]

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
			 unique_chars=check_uniqueness(combination,uniqueness)
		 	 if unique_chars == combination.length-1
				puts combination if info[:piped]
			  	 unless unique_file.nil?
				   unless data[:extra_chars].nil?
				   	if data[:iteration] != 0
				   	  unique_file.puts(combination)
				  	end
				  else	
					 unique_file.puts(combination)
				  end
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
		
		unless unique_file.nil?
			unique_file.close
		end

		return unique_combs
	end

	def self.check_uniqueness(combination,uniqueness)
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

	def self.get_single_combs(data)
		i=0
		single_combinations=0
		extra_singe=0
		extra_chars=data[:characters].length+data[:extra_chars].length if !data[:extra_chars].nil?
		while i < data[:cmb_length]-1
			if i == 0
				single_combinations=(data[:characters].length-1)*data[:characters].length
				extra_singe=extra_chars*(extra_chars-1) if !extra_chars.nil?
			else
				single_combinations=single_combinations*(data[:characters].length-(i+1))
				extra_singe=extra_singe*(extra_chars-(i+1)) if !extra_chars.nil?
			end
			i+=1
		end
		return extra_singe - single_combinations if !data[:extra_chars].nil?
		return single_combinations
	end

	def self.get_combinations(data)
		if data[:extra_chars].nil?
			base=data[:characters].length
		else
			old_base=data[:characters].length
			old_combinations=old_base**data[:cmb_length]
			x=0
			post_matches=0
			while x < data[:cmb_length]-1
				if x == 0
					post_matches=old_base
				elsif x == 1
					post_matches=(old_base**x)+(1*(old_base-1))
				else
					post_matches=(old_base**x)+(post_matches*(old_base-1))
				end
				x+=1
			end
			old_matches=old_base*post_matches
			base=data[:characters].length+data[:extra_chars].length
		end
		possible_combinations=base**data[:cmb_length]
		previous_matches=0
		i=0

		while i < data[:cmb_length]-1
			if i==0
				previous_matches=base
			elsif i== 1
				previous_matches=(base**i)+(1*(base-1))
			else
				previous_matches=(base**i)+(previous_matches*(base-1))
			end
			i+=1
		end
		matches=base*previous_matches

		if data[:type]=='unique'
			if data[:uniqueness_type].nil?
			   return (possible_combinations-matches)-(old_combinations-old_matches) if !data[:extra_chars].nil?
			   return possible_combinations-matches
			else
			   single_combs=get_single_combs(data)
			   if data[:uniqueness_type]=="single"
				  return single_combs
			   elsif data[:uniqueness_type]=="repeat"
				   return ((possible_combinations-matches)-(old_combinations-old_matches))-single_combs if !data[:extra_chars].nil?
				   return (possible_combinations-matches)-single_combs
			   end
			end
		else
			return matches-old_matches  if !data[:extra_chars].nil?
			return matches
		end
		return 0
	end

	def self.get_above_limit(data)
		if data[:extra_chars].nil?
			base=data[:characters].length
		else
			old_base=data[:characters].length
			previous_matches=0
		    previous_mult=0
		    i=0
		    while i < (data[:cmb_length] -1)
		    	if i == (data[:match_limit]-1)
		    	   previous_matches=old_base
				   old_matches=previous_matches
		    	elsif i == data[:match_limit]
		    		previous_matches=previous_matches+(1*(old_base-1))
		    		previous_mult=1
		    	else
		    		temp_mult=previous_matches
		    		previous_matches=(old_base**(i-1)+previous_mult*(old_base-1))+(previous_matches*(old_base-1))
					previous_mult=temp_mult
		    	end

		    	i+=1
		    end

		    old_matches=old_base*previous_matches if data[:cmb_length] != (data[:match_limit]+1)
			base=data[:characters].length+data[:extra_chars].length
		end

		previous_matches=0
		previous_mult=0
		i=0
		while i < (data[:cmb_length] -1)
			if i == (data[:match_limit]-1)
				previous_matches=base
				return previous_matches if data[:cmb_length] == (data[:match_limit]+i) && data[:extra_chars].nil?
			elsif i == data[:match_limit]
				previous_matches=previous_matches+(1*(base-1))
				previous_mult=1
			else
				temp_mult=previous_matches
				previous_matches=(base**(i-1))+(previous_mult*(base-1))+(previous_matches*(base-1))
				previous_mult=temp_mult*(base-1)

			end
			i+=1
		end
		
		unless data[:extra_chars].nil?
			return base-old_base if data[:cmb_length] == (data[:match_limit]+1)
			return (base*previous_matches)-old_matches
		else
		    return base*previous_matches
		end
	end

	def self.get_size(data)
		bytes=data[:combinations]*(data[:cmb_length]+1)
		kilo_bytes=bytes/1000.0
		mega_bytes=kilo_bytes/1000.0
		giga_bytes=mega_bytes/1000.0
		tera_bytes=giga_bytes/1000.0
		peta_bytes=tera_bytes/1000.0
		all_sizes= {:bytes=>bytes,:kilo=>kilo_bytes,:mega=>mega_bytes,:giga=>giga_bytes,:tera=>tera_bytes,:peta=>peta_bytes}
		return_sizes= {}
		all_sizes.each do |key,value|			
			if kilo_bytes < 1
				return_sizes[key]=value
				break
			end
			return_sizes[key]=value if value > 0.01 && key != :bytes
		end
		yield(return_sizes)
		return return_sizes
	end


	def self.create_file(data)
		    continue=file_info(data)
			case continue
			when /(y|Y)/
				if data[:file_append]
					return File.open("#{data[:file_append]}.txt","a")
				else					
					puts "Creating file"
					print "Enter save file name:"
				    file_name=gets.chomp
				    data[:file_append]=file_name if !data[:file_append].nil?
					return File.open("#{file_name}.txt","w")
				end

			when /(n|N)/
				puts "Goodbye"
				exit
			else
				puts "Invalid option"
				exit
			end	
	end

	def self.file_info(data)
		if data[:file_append].nil? || !data[:file_append]
			if data[:write_cmbs].nil?
				poss_combs=get_combinations(data)
				unless data[:match_limit].nil?
					poss_combs -= get_above_limit(data)
				end
				matching_file_size=get_size({:cmb_length=>data[:cmb_length],:combinations=>poss_combs}){}
			else
				poss_combs=0
				matching_file_size={:bytes=>0,:kilo=>0,:mega=>0,:giga=>0,:tera=>0,:peta=>0}
				dataB=data.clone
				data[:write_cmbs].each do |n|
					dataB[:cmb_length]=n
					current_combs=get_combinations(dataB)
					poss_combs +=current_combs
				    unless data[:match_limit].nil?
					     poss_combs -= get_above_limit(dataB)
					     current_combs -= get_above_limit(dataB)
				    end
					get_size({:cmb_length=>n,:combinations=>current_combs})do |sizes|
						sizes.each do |key,value|
							matching_file_size[key] +=value
						end 
						matching_file_size[:bytes]=0 if matching_file_size[:kilo] >= 1
					end
				end
			end
			puts "Possible  #{data[:type]} combinations #{poss_combs}."
			size_string="File size:"
			matching_file_size.each do |key,value|
				next if value == 0
				size_string += " #{"%.2f"% value}#{key.capitalize}#{'Bytes' if key != :bytes}"
			end
			puts size_string
			puts "Do you wish to continue ?"
			puts "y|Y n|N"
			return gets.chomp

		elsif data[:file_append]
			return "y"
		end
	end

	def self.multi_length_matching(data)
		dataB=data.clone
		i=0
		while i < data[:cmb_length].length
			dataB[:cmb_length] = data[:cmb_length][i]
			dataB[:characters]=data[:characters].clone
			matching_combinations(dataB)
			i+=1
		end
	end

	def self.multi_length_unique(data)
		dataB=data.clone
		i=0
		while i < data[:cmb_length].length
			dataB[:cmb_length] = data[:cmb_length][i]
			dataB[:characters]=data[:characters].clone
			unique_combinations(dataB)
			i+=1
		end
	end

	def self.combinations(data)
		case data[:type]
	  	 when "matching"
	  	 	if data[:cmb_length].length == 1
	  	 	   data[:cmb_length]=data[:cmb_length][0]
			   matching_combinations(data)
			elsif data[:piped]
				multi_length_matching(data)
			else
				data[:file_append]=false
				data[:write_cmbs]=data[:cmb_length].clone
				multi_length_matching(data)
	  	 	end

		 when "unique"
		 	if data[:cmb_length].length == 1
		 		data[:cmb_length]=data[:cmb_length].first
		 		unique_combinations(data)
		 	elsif data[:piped]
		 		multi_length_unique(data)
		 	else
				data[:file_append]=false
				data[:write_cmbs]=data[:cmb_length].clone
				multi_length_unique(data)
		 	end
		 else
		 	puts "Invalid combination type"
		 	exit
		end
	end
end
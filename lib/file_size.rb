module FileSize


	def get_size(data)
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
		yield(return_sizes) if block_given?
		return return_sizes
	end

	def cap_limit_matching(data)
		cap_data={}
			total_chars=data[:characters].join()
			caps_matched= total_chars.scan(/[A-Z]/)
			cap_data[:characters]=[]
			data[:characters].each do |char|
				next if caps_matched.include?(char)
				cap_data[:characters].push(char)
			end
			base=cap_data[:characters].length
			cap_matches=0
			case data[:cmb_length]
			  when 3
				cap_matches += base*2
			  when 4
				  	cap_matches+=get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1})*2
				  	cap_matches+=(base**2)*2
			  else
			  	cap_matches+=get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1})*2			  	
			  	cap_matches+=(get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-2})*base)*(data[:cmb_length]-2)
			end

		if !data[:extra_chars].nil?
			all_chars=data[:characters]+data[:extra_chars]
			new_cap_matches=cap_limit_matching({:cmb_length=>data[:cmb_length],:characters=>all_chars})
			return	new_cap_matches-(cap_matches*caps_matched.length)
		else
  		  return cap_matches*caps_matched.length		
		end

	end

	def cap_limit_matching_l(data)
		cap_data={}		
		total_chars=data[:characters].join()
		caps_matched= total_chars.scan(/[A-Z]/)
		cap_data[:characters]=[]
		data[:characters].each do |char|
			next if caps_matched.include?(char)
			cap_data[:characters].push(char)
		end
		base=cap_data[:characters].length
		cap_matches=0
		no_limit_matches=get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1})
		case data[:cmb_length]
		  when 3
			cap_matches += base*2
		  when 4
			 cap_matches+=(no_limit_matches-get_above_limit({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1,:match_limit=>data[:match_limit]}))*2
			 cap_matches+=(base**2)*2
		  else

		  	#XXA
		  	cap_matches+=(no_limit_matches-get_above_limit({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1,:match_limit=>data[:match_limit]}))*2
		  	no_limit_matches=get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-2})
		  	#XAX
		  	cap_matches+=((no_limit_matches-get_above_limit({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-2,:match_limit=>data[:match_limit]}))*base)*2
		  	x=data[:cmb_length]-4
		  	if x == 1
				cap_matches +=get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-2})*base
		  	elsif x == 2
				grt_half_no_limit=get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-3})
				grt_half_limit =grt_half_no_limit-get_above_limit({:characters=>cap_data[:characters],:match_limit=>data[:match_limit],:cmb_length=>data[:cmb_length]-3})
				cap_matches +=(((grt_half_limit*base**2)+(base*base**3))-(grt_half_no_limit*base))*2
		  	else
		  		#AXX
				i=3
				p=0
				l=0
				begin
					grt_half=get_combinations({:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-(3+l)})
					grt_half_limit =grt_half-get_above_limit({:characters=>cap_data[:characters],:match_limit=>data[:match_limit],:cmb_length=>data[:cmb_length]-(3+l)})
					if i == 3
						if data[:cmb_length] <=8							
								cap_matches +=(((grt_half_limit*base**2)+(base*base**(x+1)))-(grt_half*base))*2
							else
							cap_matches +=((grt_half_limit*((base**2)-base))+(base*base**(x+1)))*2

						end 
					else
						lsr_half=get_combinations({:characters=>cap_data[:characters],:cmb_length=>i-1})
						lsr_half_limit=lsr_half-get_above_limit(:characters=>cap_data[:characters],:match_limit=>data[:match_limit],:cmb_length=>i-1)
						cap_matches +=(((grt_half_limit*(base**(2+p)))+(lsr_half_limit*base**(x+1-p)))-(grt_half*lsr_half))*2
						  	
					end
					p+=1
					l+=1
					i+=1
				end while i < (data[:cmb_length]/2.0).ceil



				if x%2 == 1
					no_limit_matches=get_combinations({:characters=>cap_data[:characters],:cmb_length=>x-(p-1)})
					half_point=(((no_limit_matches-get_above_limit({:characters=>cap_data[:characters],:cmb_length=>x-(p-1),:match_limit=>data[:match_limit]})))*base**(x-(p-1)))*2
					if data[:cmb_length] == 7
 				    	cap_matches+=half_point-((half_point/base))
					else
						half_no_limit=get_combinations(:characters=>cap_data[:characters],:cmb_length=>x-1)							
						half_no_limit_b=get_combinations(:characters=>cap_data[:characters],:cmb_length=>x-2)

						if data[:cmb_length] >= 9 && data[:extra_chars].nil?
							puts "!------Approximately less  than------!"
						end
						cap_matches+=half_point-((half_point/base))
						
					end

				else
					no_limit_matches_a=get_combinations({:characters=>cap_data[:characters],:cmb_length=>(x-l)+1})
					greater_half=(((no_limit_matches_a-get_above_limit({:characters=>cap_data[:characters],:cmb_length=>(x-l)+1,:match_limit=>data[:match_limit]})))*base**(x-l))
					no_limit_matches_b=get_combinations({:characters=>cap_data[:characters],:cmb_length=>(x-l)})
					lesser_half=(((no_limit_matches_b-get_above_limit({:characters=>cap_data[:characters],:cmb_length=>(x-l),:match_limit=>data[:match_limit]})))*base**(x-l+1))
					
					if data[:cmb_length] == 10 && data[:extra_chars].nil?
						puts "!------Approximately less  than------!"
					elsif data[:cmb_length] == 12 && data[:extra_chars].nil?
						puts "!------Approximately more  than------!"
					end
					cap_matches+=((greater_half+lesser_half)-((no_limit_matches_a*no_limit_matches_b)-(no_limit_matches_b*base)))*2
				end

		  	end
			  
		end

		if (cap_data[:characters].length <= 2 || data[:cmb_length] >= 13) && data[:extra_chars].nil?
			puts "!!!----Inaccurate information----!!!"
		end

		if !data[:extra_chars].nil?
			all_chars=data[:characters]+data[:extra_chars]
			new_cap_matches=cap_limit_matching_l({:cmb_length=>data[:cmb_length],:characters=>all_chars,:match_limit=>data[:match_limit]})
			return	new_cap_matches-(cap_matches*caps_matched.length)
		else
    		return cap_matches*caps_matched.length		
		end
	end

	def unique_cap_limit(data)
		cap_data={}
		total_chars=data[:characters].join()
		caps_matched= total_chars.scan(/[A-Z]/)
		cap_data[:characters]=[]
		data[:characters].each do |char|
			next if caps_matched.include?(char)
			cap_data[:characters].push(char)
		end
		base=cap_data[:characters].length
		unique_cap_limit=0
		if data[:uniqueness_type] == 'single'
		  if data[:cmb_length] == 3
			  unique_cap_limit=(((base**2)-(base))*3)
		  else
			  previous_single=get_single_combs(:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1,:type=>"unique")
			  unique_cap_limit=previous_single*data[:cmb_length]
	   	  end
		else
			case data[:cmb_length]
				when 3
					if data[:uniqueness_type].nil?
						unique_cap_limit=((base**2)*3)-(base*2)
					else
						unique_cap_limit=((base**2)*3)-(base*2)-(((base**2)-(base))*3)
					end
				when 4
					previous_unique=get_combinations(:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1,:type=>"unique")
				   if data[:uniqueness_type].nil?
						unique_cap_limit=(previous_unique*2)+((((base**2)-base)*base)*2)
				   else
						previous_single=get_single_combs(:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1,:type=>"unique")
						unique_cap_limit=(previous_unique*2)+((((base**2)-base)*base)*2)-(previous_single*data[:cmb_length])
				   end					
				else
					previous_unique_a=get_combinations(:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1,:type=>"unique")
					previous_unique_b=get_combinations(:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-2,:type=>"unique")
					if data[:uniqueness_type].nil?
						unique_cap_limit=(previous_unique_a*2)+((previous_unique_b*base)*(data[:cmb_length]-2))
					else
						previous_single=get_single_combs(:characters=>cap_data[:characters],:cmb_length=>data[:cmb_length]-1,:type=>"unique")
						unique_cap_limit=(previous_unique_a*2)+((previous_unique_b*base)*(data[:cmb_length]-2))-(previous_single*data[:cmb_length])
					end
			end
		end
			
		if !data[:extra_chars].nil?
			all_chars=data[:characters]+data[:extra_chars]
			new_unique_cap_limit=unique_cap_limit({:cmb_length=>data[:cmb_length],:characters=>all_chars,:uniqueness_type=>data[:uniqueness_type]})
			return	new_unique_cap_limit-(unique_cap_limit*caps_matched.length)
		else
			return unique_cap_limit*caps_matched.length
		end
	end

	def cap_limit_combs(data,x=0)
		if data[:type] == "matching"
			if !data[:match_limit].nil?
			   puts "Combinations and file size may vary when using match_limit" if x == 0
			   cap_limit_matching_l(data)
			else
			   cap_limit_matching(data)			
			end
		else
			unique_cap_limit(data)			
		end
	end

	def get_above_limit(data)
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
		i=1
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
				previous_mult=temp_mult

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

	def get_single_combs(data)
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

	def get_combinations(data)
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
		    possible_combinations=base**data[:cmb_length]
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

	def get_default_strictness(letters,digits,cmb_length)
		combinations=0
		if cmb_length % 2 != 0
            ceiling=(cmb_length/2.0).ceil
            floor=(cmb_length/2.0).floor
		end

		if cmb_length == 6
			combinations+=get_combinations({:characters=>digits,:cmb_length=>(cmb_length/2)})*2
			combinations+=get_combinations({:characters=>letters,:cmb_length=>(cmb_length/2)})*2
		elsif cmb_length == 7
		    combinations+=get_combinations({:characters=>digits,:cmb_length=>ceiling})
		    combinations+=get_combinations({:characters=>digits,:cmb_length=>floor})
		    combinations+=get_combinations({:characters=>letters,:cmb_length=>ceiling})
		    combinations+=get_combinations({:characters=>letters,:cmb_length=>floor})
		elsif cmb_length == 8
			combinations+=get_combinations({:characters=>digits,:cmb_length=>(cmb_length/2)})*2
			combinations+=get_combinations({:characters=>letters,:cmb_length=>(cmb_length/2)})*2
		end
		
		return combinations
	end

	def get_rule_size(data)
		characters=data[:characters].join()
		digits=characters.scan(/[0-9]/)
	
		if data[:cap_limit]
			letters=characters.scan(/[a-z]/i)
		else
			letters=characters.scan(/[A-Z]/i)
		end

		combinations=0
		if data[:extra_chars].nil?
		  
		  if letters.length > 0
		    combinations+=get_default_strictness(letters,digits,data[:cmb_length])		  	
		  end

		  if @strictness >= 2
			  combinations +=get_combinations({:cmb_length=>data[:cmb_length],
			  :characters=>digits})
		  end

		  if @strictness == 3
			 combinations +=get_combinations({:cmb_length=>data[:cmb_length],
			 :characters=>letters,:extra_chars=>data[:extra_chars]})	
		  end
		end
		return combinations
	end

	def file_info(data)
			if data[:write_cmbs].nil?
				poss_combs=get_combinations(data)
				if !data[:match_limit].nil?
					if !data[:cap_limit].nil?
						poss_combs=cap_limit_combs(data)
					else
				  		poss_combs -= get_above_limit(data)
					end
				elsif !data[:cap_limit].nil?
			      poss_combs=cap_limit_combs(data)
				end

				if @rules
					poss_combs -=get_rule_size(data)
				end

				file_size=get_size({:cmb_length=>data[:cmb_length],:combinations=>poss_combs})				
			else
				poss_combs=0
				file_size={:bytes=>0,:kilo=>0,:mega=>0,:giga=>0,:tera=>0,:peta=>0}
				dataB=data.clone
				cmb_count=data[:write_cmbs].length if !data[:cap_limit].nil?
				data[:write_cmbs].each do |n|
					dataB[:cmb_length]=n
				  if data[:cap_limit].nil?
					current_combs=get_combinations(dataB)
					if @rules
						current_combs-=get_rule_size(dataB)
					end
					poss_combs +=current_combs
				    unless data[:match_limit].nil?
					     poss_combs -= get_above_limit(dataB)
					     current_combs -= get_above_limit(dataB)
				    end
				  else
				  	 current_combs=cap_limit_combs(dataB,cmb_count)
				  	 cmb_count -= 1
				  	 poss_combs +=cap_limit_combs(dataB,cmb_count)
				  end
					get_size({:cmb_length=>n,:combinations=>current_combs})do |sizes|
						sizes.each do |key,value|
							file_size[key] +=value
						end 
						file_size[:bytes]=0 if file_size[:kilo] >= 1
					end
				end
			end
			puts "Possible  #{data[:type]} combinations #{poss_combs}."
			size_string="File size:"
			file_size.each do |key,value|
				next if value == 0
				size_string += " #{"%.2f"% value}#{key.capitalize}#{'Bytes' if key != :bytes}"
			end
			puts size_string
			puts "Do you wish to continue ?"
			puts "y|Y n|N"
			return gets.chomp
	end

	def create_file(data)
		    continue=file_info(data)
			case continue
			when /(y|Y)/
					print "Enter file name:"
				    file_name=gets.chomp
				    @fh=File.open("#{file_name}.txt","a")
					puts "Creating file"
			when /(n|N)/
				puts "Goodbye"
				exit
			else
				puts "Invalid option"
				exit
			end	
	end
end
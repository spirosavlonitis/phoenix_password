# PhoenixPassword

The PhoenixPassword generator gem is intended to be used 
in password recovery operations or random password generation
purposes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phoenix_password'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phoenix_password

## Usage
In order to generate combinations simply add the minimum of the required options here is an irb example:

```ruby
irb(main):001:0> require 'phoenix_password'
=> true
irb(main):002:0>  PhoenixPassword.new.combinations({:piped=>true,:type=>'matching',:cmb_length=>[6],:characters=>[0,1,2,3,4,5,6,7,8,9]})
```
001273

001274

001275

.....

## Manual
This is a list of the options available to you and what they do

```ruby
obj_a=PhoenixPassword.new() 
obj_b=PhoenixPassword.new({:rules=>true})
obj_c=PhoenixPassword.new({:rules=>true,:stricness=>2})
obj_d=PhoenixPassword.new({:rules=>true,:stricness=>2,:own_rules=>[/regexp_a/,regexp_b]})
```

You can initialize a PhoenixPassword object in 4 different ways.

**a)No arguments:**
This means that there will be no extra combination restriction rules other than the ones defined in the combinations method.

```ruby
obj_a=PhoenixPassword.new()
```

**b)rules**
By setting rules to true there is an extra combination filter added, namely any combinations that have alternating letter digit value get discarded: 0a0a0a or a0a0a0 etc.

```ruby
obj_b=PhoenixPassword.new({:rules=>true})
```
**c)strictness**

```ruby
obj_b=PhoenixPassword.new({:rules=>true,:stricness=>2})
```
When using rules you can also change the strictness level of combination filtering.By default it is set to 0 meaning no other combinations will be filtered other than what rules filters on its own.

When using a level say 2 you are implementing the filters provided by 0,1 and 2.If you use 3 the you use 0,1,2 and 3
filters.

There are 4 levels in total:
X=digit,A=letter

Level 0:
default filtering 	XAXAXA or AXAXAX

Level 1:
Filters combinations that are half digits or half letters
XXXAAA or AAAXXX.

Level 2:
Filters combinations that have only digits XXXXXX

Level 3:
Filters combinations that have only letters AAAAAA


**d)own_rules**

obj_d=PhoenixPassword.new({:rules=>true,:stricness=>2,:own_rules=>[/regexp_a/,regexp_b]})

If you want to use your own combination filtering rules you must use the own_rules key and add an array with Regexp objects.

The rules that you will add will be implemented after all the rules that are used by the strictness level have been checked.Make sure when using your rules that you don't filter twice things that have been already checked.

```ruby	
:piped=>(true or false)
```
Lets you decide whether you want to pipe the results to an other program
or write them to a file.

```ruby
:cmb_length=>([5] or [5,6])
```
Set the length of the possible combinations to be generated if
there is more than one value first all the combinations with the
starting value are generated and then once done combinations of
the following length are generated till all the values have been used.

```ruby
:characters=>["e","x","m","p","l","e",1]
```
Sets the characters that will be used in the combination generation process.

```ruby
:extra_chars=>["x",1] (Optional)
```
Set extra characters to be used one at a time if the initial characters,minimum value 1 char.
Note that when etxra_chars are used only combinations that include them will be written to file.
	
```ruby
:type=>("matching" or "unique")
```
Sets which type of combinations to be generated.
Matching: Characters repeating them selves any number of times xx or xxx
Unique:Characters are different in every position xz or xzx

```ruby
:match_limit=> 2 (:optional)
```
Set the max matching characters for each combination example:

2 = xxabc, axxbc,abxxc,abcxx

3 = xxxab, axxxb,abxxx

Note that you can set the limit to more than 3 but file size info will
not be accurate.

```ruby
:skip_first=>(true |false) (Optional)
```
Used with extra_chars allows you to skip the first iteration with the
main characters thus starting from the extra characters.Useful if you
want to continue from where you left off.

```ruby
:uniqueness_type=>("repeat"|"singe") (Optional)
```
If not set all possible unique combinations are generated i.e reappearing char xzx,single char xyz
When set to repeat only reappearing character combinations are generated xzx
When set to single only single character appearance combinations are generated xzy.


```ruby
:cap_limit=>1 or more (optional)

```
When used it ensures that each combination generated will contain only the amount of capital letters specified.

**Note that file size and combination estimates  when using match_limit may not be accurate**




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/phoenix_password. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


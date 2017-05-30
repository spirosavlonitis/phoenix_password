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
In order to generate combinations simply add the minimum or the required options
here is an irb example:

```ruby
irb(main):001:0> require 'phoenix_password'
=> true
irb(main):002:0>  PhoenixPassword.combinations({:piped=>true,:characters=>[0,1,2,3,4,5,6,7,8,9],:cmb_length=>[6],:type=>'matching'})
```
001273

001274

001275

.....

## Manual
This is a list of the options available to you and what they do

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


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/phoenix_password. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

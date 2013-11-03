Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  Movie.count.should == movies_table.hashes.count
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
  Movie.find_by_title(title).director.should == director
end

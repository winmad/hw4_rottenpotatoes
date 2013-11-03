class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  class Movie::NoDirectorError < StandardError
  end

  def self.find_with_same_director(id)
    movie = self.find(id)
    director = movie.director
    if director and !director.empty?
      return self.find_all_by_director(director)
    else
      raise Movie::NoDirectorError
    end
  end
end

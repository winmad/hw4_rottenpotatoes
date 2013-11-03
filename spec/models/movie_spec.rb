require 'spec_helper'

describe Movie do

  describe 'find movies with the same director' do

    before :each do
      @movie = mock('Movie', :id => '1')
      @movie.stub(:title).and_return('Star Wars')
    end

    it 'should find movies with the same director successfully, if director info is given' do
      @movie.stub(:director).and_return('George Lucas')
      Movie.should_receive(:find).with('1').and_return(@movie)
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find_all_by_director).with('George Lucas').
        and_return(fake_results)

      Movie.find_with_same_director('1')
    end

    it 'should raise an error, if no director info is given' do
      @movie.stub(:director).and_return('')
      Movie.should_receive(:find).with('1').and_return(@movie)
      @movie.director.should be_empty
      lambda { Movie.find_with_same_director('1') }.should raise_error(Movie::NoDirectorError)
    end

  end

end

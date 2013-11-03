require 'spec_helper'

describe MoviesController do

  describe 'show movie details' do

    it 'should find the movie and show details' do
      movie = mock('Movie', :id => '1')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :show, {:id => '1'}
      response.should render_template('show')
    end

  end

  describe 'list all movies' do

    it 'should list all movies' do
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find_all_by_rating).and_return(fake_results)
      get :index
      response.should render_template('index')
    end

    it 'should list all movies sorted by title' do
      get :index, {:sort => 'title', :ratings => 'G'}
      response.should redirect_to(:sort => 'title', :ratings => 'G')
    end

    it 'should list all movies sorted by release date' do
      get :index, {:sort => 'release_date', :ratings => 'G'}
      response.should redirect_to(:sort => 'release_date', :ratings => 'G')
    end

    it 'should list all movies with specific ratings' do
      get :index, {:ratings => 'G'}
      response.should redirect_to(:ratings => 'G')
    end

  end

  describe 'create a movie' do

    it 'should create a movie successfully' do
      movie = mock('Movie', :title => 'Star Wars', :director => 'George Lucas')
      Movie.should_receive(:create!).and_return(movie)
      post :create, :movie => movie
      response.should redirect_to(movies_path)
    end

  end

  describe 'edit a movie' do

    it 'should find the movie that needs to edit' do
      movie = mock('Movie', :id => '1', :title => 'Star Wars', :director => 'George Lucas')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :edit, :id => '1'
      response.should render_template('edit')
    end

    it 'should save the updated movie information' do
      movie = mock('Movie', :id => '1', :title => 'Star Wars', :director => 'George Lucas')
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.should_receive(:update_attributes!)
      put :update, :id => '1', :movie => movie
      response.should redirect_to(movie_path(movie))
    end

  end

  describe 'delete a movie' do

    it 'should delete a movie successfully' do
      movie = mock('Movie', :id => '1', :title => 'Star Wars', :director => 'George Lucas')
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.should_receive(:destroy)
      delete :destroy, :id => '1'
      response.should redirect_to(movies_path)
    end

  end

  describe 'find movies with the same director' do

    before :each do
      @movie = mock('Movie', :id => '1')
      @movie.stub(:title).and_return('Star Wars')
      @movie.stub(:director).and_return('George Lucas')
    end

    # happy path
    it 'should show movies with the same director' do
      Movie.should_receive(:find).with('1').and_return(@movie)
      fake_results = [mock('Movie') , mock('Movie')]
      Movie.should_receive(:find_with_same_director).with('1').
        and_return(fake_results)
      get :show_movies_with_same_director, {:id => '1'}
      response.should render_template('show_movies_with_same_director')
    end

    # sad path
    it 'should redirect to home page with a warning' do
      Movie.should_receive(:find).with('1').and_return(@movie)
      Movie.stub(:find_with_same_director).and_raise(Movie::NoDirectorError)
      get :show_movies_with_same_director, {:id => '1'}
      response.should redirect_to(movies_path)
    end
  end

end


class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index    
    @movies = Movie.all
    @redirect = false
    @selected_ratings = []
    @selected_ratings_hash = Hash.new
    @all_ratings = Movie.get_all_ratings
    if params.key? :ratings
      @selected_ratings = params[:ratings].keys
      @selected_ratings_hash = params[:ratings]
      @movies = Movie.find(:all, :conditions => { :rating => @selected_ratings })
      session[:selected_ratings_hash]= @selected_ratings_hash
    elsif params.key?:commit
      @selected_ratings = []
      session.delete(:selected_ratings_hash)
    elsif session.key? :selected_ratings_hash
      @selected_ratings_hash = session[:selected_ratings_hash]
      @redirect = true
    end
    
    @title_class = ''
    @release_class = ''

    if params.key? :title_sort
      @movies.sort_by! {|m| m.title }
      @title_class =  'hilite'
    end
    if params.key? :release_sort
      @movies.sort_by! {|m| m.release_date }
      @release_class =  'hilite'
    end
    if @redirect 
      redirect_to movies_path(:ratings => @selected_ratings_hash)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

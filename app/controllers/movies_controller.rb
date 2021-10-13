class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sorting = params[:sort_by]
    if sorting
      session[:sort_by] = sorting
    else
      sorting = session[:sort_by]
    end
    ratings = params[:ratings]
    if ratings
      @ratings_to_show = ratings.keys
      if sorting
        @movies = Movie.with_ratings(@ratings_to_show).order(sorting)
      else
        @movies = Movie.with_ratings @ratings_to_show
      end
    else
      @ratings_to_show = []
      if sorting
        @movies = Movie.all.order(sorting)
      else
        @movies = Movie.all
      end
    end
    if sorting=="title"
      @debug = "yay"
      @sorting = sorting
      @title_display_class = 'hilite bg-warning'
    elsif sorting
      @sorting = sorting
      @date_display_class = 'hilite bg-warning'
    end
    @all_ratings = Movie.all_ratings
    @sort = sorting
    @stored_ratings = {}
    @ratings_to_show.each{|r| @stored_ratings[r]=1}
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

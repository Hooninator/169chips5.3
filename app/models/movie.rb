class Movie < ActiveRecord::Base
  def self.all_ratings
    lst = []
    Movie.all.each do |m|
      if not lst.include? m.rating
        lst.append(m.rating)
      end
    end
    return lst
  end
  
  def self.with_ratings(ratings)
    return Movie.where(rating: ratings)
  end
end

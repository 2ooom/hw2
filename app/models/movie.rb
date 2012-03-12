class Movie < ActiveRecord::Base
  def self.get_all_ratings
    self.all.map{|m| m.rating}.uniq #.find(:all, :select => 'DISTINCT field')
  end
end

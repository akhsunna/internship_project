class BookGanre < ActiveRecord::Base
  belongs_to :ganre
  belongs_to :book
end
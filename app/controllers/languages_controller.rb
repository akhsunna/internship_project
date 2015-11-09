# Controller for languages
class LanguagesController < ApplicationController
  def show
    @language = Language.find(params[:id])
    @books = Book.where(language_id: @language.id)
  end
end

class ProfilesController < ApplicationController
  def show
    @person = Person.find_by_account params[:account]
    unless current_person.blessed?
      @person = nil if @person and (current_person.teams & @person.approved_teams).empty?
    end
    render :unknown unless @person
  end
end
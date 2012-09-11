require 'uuidtools'

class TeamsController < ApplicationController
  def index
    @memberships = current_person.memberships
    @team = Team.new
  end

  def create
    @teams = current_person.teams
    @team = Team.new params[:team].merge creator: current_person
    if @team.save
      redirect_to "/teams/#{@team.slug}"
    else
      render :index
    end
  end

  def add
    with_team do |team|
      person = Person.find_by_email params[:email]
      person = Person.create_for_email params[:email] unless person
      unless person.teams.include? team
        if person == current_person
          Membership.create team: team, person: person
        else
          Membership.create_pending_membership current_person, team, person
        end
      end
      redirect_to "/teams/#{team.slug}"
    end
  end

  def show
    with_team { render :show }
  end

  def avatars
    with_team { render :avatars, layout: 'no_header' }
  end

  def quiz
    with_team do |team|
      @people = team.people.sample 5
      @person = @people.sample
      @facts = @person.facts.sample 3
      render :quiz
    end
  end
private
  def with_team *args
    @team = Team.find_by_slug params[:slug]
    unless current_person.blessed?
      @team = nil unless current_person.teams.include?(@team) or @team.creator == current_person
    end
    if @team
      yield @team
    else
      render :unknown
    end
  end
end
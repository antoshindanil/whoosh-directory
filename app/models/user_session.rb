require 'securerandom'

class UserSession < ApplicationRecord
  TOKEN_LENGTH = 20

  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :data, type: Hash

  cattr_reader :current, instance_reader: false


  before_create do |session|
    session.token = SecureRandom.urlsafe_base64(TOKEN_LENGTH)

    default_expanded_unit_ids = Unit.where(:level.lt => 2, :destroyed_at => nil).pluck(:short_id).compact
    session.data = {
      expanded_units: default_expanded_unit_ids,
    }
  end


  def self.find(token)
    UserSession.where(token: token).first if token.present?
  end


  def self.find_or_create(token)
    find(token) || UserSession.create
  end

end

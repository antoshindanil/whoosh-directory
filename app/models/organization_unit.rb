class OrganizationUnit < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ImportEntity

  field :uuid,        type: String
  field :type,        type: String
  field :title,       type: String
  field :short,       type: String
  field :path,        type: String
  field :parent_uuid, type: String

  has_many   :children, inverse_of: :parent, class_name: 'OrganizationUnit', order: :path.asc
  belongs_to :parent, inverse_of: :children, class_name: 'OrganizationUnit', optional: true

  has_many :unit_employments, inverse_of: :unit, class_name: 'Employment'
  has_many :dept_employments, inverse_of: :dept, class_name: 'Employment'

end

class Employment < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable
  include Importable
  include ImportableEmployment

  field :person_short_id,    type: String
  field :node_short_id,      type: String
  field :parent_node_short_id, type: String
  field :department_short_id,type: String
  field :post_title,         type: String
  field :post_code,          type: String
  field :is_manager,         type: Boolean
  field :is_head,            type: Boolean
  field :office,             type: String
  field :building,           type: String
  field :lunch_begin,        type: String
  field :lunch_end,          type: String
  field :parental_leave,     type: Boolean
  field :vacation_begin,     type: Date
  field :vacation_end,       type: Date
  field :for_person_rank,    type: Integer
  field :in_unit_rank,       type: Integer
  field :alpha_sort,         type: String
  field :destroyed_at,       type: Time

  validates :person_short_id, :post_title, presence: true

  belongs_to :person
  belongs_to :node, optional: true
  belongs_to :parent_node, class_name: 'Node', optional: true
  belongs_to :department, class_name: 'Node', optional: true

  embeds_one :telephones, as: :phonable,  class_name: 'Phones'

  def self.people
    Person.where(destroyed_at: nil).in(short_id: all.map(&:person_short_id))
  end

  index({ destroyed_at: 1, person_short_id: 1 }, {})
  index({ destroyed_at: 1, short_id: 1 }, {})
  index({ person_short_id: 1 }, {})


  def as_json(options = nil)
    result = super.slice(
      'post_title', 'alpha_sort', 'post_code', 'is_head',
      'office', 'building',
      'lunch_begin', 'lunch_end', 'vacation_begin', 'vacation_end',
    ).compact.merge(
      'id'          => short_id,
      'person_id'   => person_short_id,
    )
    result.merge!('node_id' => node_short_id) if node_short_id.present?
    result.merge!('parent_node_id' => parent_node_short_id) if parent_node_short_id.present?
    result.merge!('dept_id' => department_short_id) if department_short_id.present?

    if telephones.present?
      result.merge!('format_phones' => telephones.format_phones_with_type)
    end
    result.merge!('on_vacation' => true) if on_vacation

    result
  end


  def on_vacation
    today = Date.today
    vacation_begin && vacation_end && today >= vacation_begin && today <= vacation_end
  end

end

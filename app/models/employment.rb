class Employment < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps
  include ShortId
  include Searchable
  include FormatPhone

  field :external_id,        type: String
  field :person_external_id, type: String
  field :unit_external_id,   type: String
  field :person_short_id,    type: String
  field :unit_short_id,      type: String
  field :post_title,         type: String
  field :post_code, type: String
  field :office,             type: String
  field :building,           type: String
  field :phones,             type: Array
  field :lunch_begin,        type: String
  field :lunch_end,          type: String
  field :parental_leave,     type: Boolean
  field :vacation_begin,     type: Date
  field :vacation_end,       type: Date
  field :for_person_rank,    type: Integer
  field :in_unit_rank,       type: Integer
  field :destroyed_at,       type: Time

  validates :external_id, :person_external_id, :unit_external_id, :person_short_id, :unit_short_id, :post_title, presence: true

  belongs_to :person
  belongs_to :unit

  index({ destroyed_at: 1, person_short_id: 1 }, {})
  index({ destroyed_at: 1, short_id: 1 }, {})
  index({ person_short_id: 1 }, {})


  def as_json(options = nil)
    result = super.slice(
      'post_title', 'post_code',
      'office', 'building', 'phones',
      'lunch_begin', 'lunch_end',
    ).compact.merge(
      'id'          => short_id,
      'person_id'   => person_short_id,
      'unit_id'     => unit_short_id,
      'format_phones' => format_phones_with_type,
    )
    result.merge!('on_vacation' => true) if on_vacation

    result
  end


  def on_vacation
    today = Date.today
    vacation_begin && vacation_end && today >= vacation_begin && today <= vacation_end
  end

end

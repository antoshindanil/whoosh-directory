module ImportableEmployment
  extend ActiveSupport::Concern

  included do

    def link_node(node)
      self.node_id       = node&.id
      self.node_short_id = node&.short_id
    end


    def link_department_node(node)
      self.department_id       = node&.id
      self.department_short_id = node&.short_id
    end


    def link_parent_node(parent_node)
      self.parent_node_id       = parent_node&.id
      self.parent_node_short_id = parent_node&.short_id
    end


    def link_person(person)
      self.person_id       = person&.id
      self.person_short_id = person&.short_id
    end


    def sort_order
      (is_manager ? 'A' : 'Z') + (is_head ? 'A' : 'Z') + alpha_sort
    end


    # TODO refactor
    # alias_method :importable_flush_to_db, :flush_to_db
    # def flush_to_db(new_data)
      # person&.save! # TODO: save person while demo import
      # importable_flush_to_db(new_data)
    # end

  end
end

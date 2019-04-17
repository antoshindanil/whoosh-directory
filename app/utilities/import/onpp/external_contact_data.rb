module Utilities
  module Import
    module ONPP
      class ExternalContactData

        attr_accessor :external_id,
                      :parent_node_external_id,
                      :first_name,
                      :middle_name,
                      :last_name,
                      :function_title,
                      :location_title,
                      :post_title, :post_code,
                      :birthday,
                      :gender,
                      :office,
                      :building,
                      :telephones,
                      :alpha_sort,
                      :email


        def initialize(source_data, node_id)
          @external_id      = source_data['id'].to_s
          @parent_node_external_id = node_id
          @first_name       = source_data['first_name']
          @middle_name      = source_data['middle_name']
          @last_name        = source_data['last_name']
          @function_title   = source_data['function_title']
          @location_title   = source_data['location_title']
          @gender           = source_data['gender']
          @post_title       = source_data['post_title']
          @post_code        = source_data['post_code']
          @birthday         = source_data['birthday']
          @office           = source_data['office']
          @building         = source_data['building']
          @telephones       = Phones.from_yml(source_data['phones'])
          @email            = source_data['email']
          @alpha_sort       = source_data['function_title'] || source_data['location_title'] ||
                              (source_data['last_name'] + source_data['middle_name'] + source_data['first_name'])
        end


        def attributes
          {
            external_id:      external_id,
            first_name:       first_name,
            middle_name:      middle_name,
            last_name:        last_name,
            function_title:   function_title,
            location_title:   location_title,
            gender:           gender,
            post_title:       post_title,
            post_code:        post_code,
            birthday:         birthday,
            office:           office,
            building:         building,
            email:            email,
            alpha_sort:       alpha_sort,
          }
        end

        def object_attributes
          {
            telephones: {
                attributes: telephones.attributes,
              },
          }
        end

      end
    end
  end
end
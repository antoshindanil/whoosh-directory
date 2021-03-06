require 'nokogiri'
require 'utilities/import/onpp/person_collection'
require 'utilities/import/onpp/node_collection'
require 'utilities/import/onpp/unit_collection'
require 'utilities/import/onpp/employment_collection'
require 'utilities/import/concerns/tuner'
require 'utilities/import/ldap_connection'
require 'yaml'

module Utilities
  module Import
    module ONPP
      class Importer
        include Tuner

        def initialize
          @people      = Utilities::Import::ONPP::PersonCollection.new
          @nodes       = Utilities::Import::ONPP::NodeCollection.new
          @units       = Utilities::Import::ONPP::UnitCollection.new
          @employments = Utilities::Import::ONPP::EmploymentCollection.new
          @contacts    =  Utilities::Import::ONPP::ExternalContactCollection.new
        end


        def import(language:)
          # Mongoid.logger = Logger.new($stdout)
          # Mongo::Logger.logger = Logger.new($stdout)

          load_black_lists

          load_import_data

          import_emails

          @people.delete_without_employment(@employments)

          load_tunes(ENV['STAFF_IMPORT_FINE_TUNING'])

          set_head_flags

          # a time to modify the structure
          replace_pseudo_units
          convert_employee_to_node
          move_nodes

          replace_employments
          assign_root_sort
          # end modifications

          @nodes.build_structure
          @nodes.mark_nodes_as_departments(@employments)
          set_nodes_type

          # assign links between objects
          @employments.link_data_to_people(@people)
          @people.cleanup_excess_employments(@employments)
          @employments.link_data_to_nodes(@nodes)
          @contacts.link_data_to_nodes(@nodes)

          @nodes.change_management_node(@employments) # specific
          @nodes.reset_employments_link
          @employments.link_data_to_nodes(@nodes)

          @nodes.delete_empty_nodes

          @nodes.reset_structure
          @nodes.build_structure

          @nodes.sort_child_nodes
          @nodes.sort_employments(@employments)

          @units.import_from_nodes(@nodes)

          @nodes.set_heads(@employments, @units)
          set_exception_head_ids

          # then, let's read-write db
          fetch_from_db

          drop_stale_objects

          build_new_objects

          import_photos

          link_objects

          flush_to_db
        end


        def fetch_from_db
          @people.fetch_from_db
          @nodes.fetch_from_db
          @units.fetch_from_db
          @employments.fetch_from_db
          @contacts.fetch_from_db
        end


        def drop_stale_objects
          @people.drop_stale_objects
          @nodes.drop_stale_objects
          @units.drop_stale_objects
          @employments.drop_stale_objects
          @contacts.drop_stale_objects
        end


        def build_new_objects
          @people.build_new_objects
          @nodes.build_new_objects
          @units.build_new_objects
          @employments.build_new_objects
          @contacts.build_new_objects
        end


        def flush_to_db
          @people.flush_to_db
          @nodes.flush_to_db
          @units.flush_to_db
          @employments.flush_to_db
          @contacts.flush_to_db
        end


        def import_photos
          @people.import_photos
          @contacts.import_photos
        end


        def link_objects
          @employments.link_node_objects(@nodes)
          @contacts.link_node_objects(@nodes)
          @units.link_node_objects(@nodes)
          @units.link_employment_objects(@employments)

          @nodes.link_node_objects
          @nodes.link_employment_objects(@employments)
          @nodes.link_contact_objects(@contacts)
          @nodes.link_unit_objects(@units)

          @people.link_employments(@employments)
          @employments.link_objects_to_people(@people)
        end


        def load_black_lists
          blacklist_xml_str = IO.read ENV['STAFF_IMPORT_BLACKLIST_FILE_PATH']
          blacklist_doc = ::Nokogiri::XML(blacklist_xml_str, nil, 'UTF-8')

          @nodes.import_black_list(blacklist_doc)
          @employments.import_black_list(blacklist_doc)
        rescue Errno::ENOENT
          puts 'Black list file not found - skip it.'
        end


        def load_import_data
          xml_str = IO.read ENV['STAFF_IMPORT_FILE_PATH']
          doc = ::Nokogiri::XML(xml_str, nil, 'CP1251')

          @nodes.import_from_xml(doc)
          @employments.import(doc, @nodes)
          @people.import(doc, @nodes)

          begin
            yaml_doc = YAML.load_file ENV['STAFF_IMPORT_EXTERNAL_CONTACTS_FILE_PATH']

            @nodes.import_from_yaml(yaml_doc)
            @contacts.import(yaml_doc)
          rescue Errno::ENOENT
            puts "Missing external contacts file: #{ENV['STAFF_IMPORT_EXTERNAL_CONTACTS_FILE_PATH']}"
          rescue TypeError
            puts "No external contacts file name provided - skip it."
          end
        end


        def import_emails
          emails = load_emails_from_ldap
          @people.import_emails(emails)
        end


        def load_emails_from_ldap
          host = ENV['STAFF_IMPORT_LDAP_HOST']
          base = ENV['STAFF_IMPORT_LDAP_USERS_PATH']
          user_name = ENV['STAFF_IMPORT_LDAP_USER']
          user_password = ENV['STAFF_IMPORT_LDAP_PASSWORD']
          id_ldap_attribute = ENV['STAFF_IMPORT_LDAP_USER_ID_ATTRIBUTE']
          email_ldap_attribute = ENV['STAFF_IMPORT_LDAP_EMAIL_ATTRIBUTE']
          begin
            ldap = Utilities::Import::LdapConnection.new(host, base, user_name, user_password)
            emails = ldap.get_emails_as_hash(id_ldap_attribute, email_ldap_attribute)
          rescue Net::LDAP::Error => e
            pp e
            emails = {}
          end

          emails
        end

      end
    end
  end
end

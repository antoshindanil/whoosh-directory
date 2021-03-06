module Staff
  class SearchAPI < Grape::API

    before do
      set_cache_header(1800)
    end

    params {
      requires :q, type: String
      optional :max, type: Integer, default: 20
      optional :skip, type: Integer, default: 0
    }
    get :search do
      search_query = SearchQuery.new(params[:q])

      if search_query.birthday?
        birthday_interval = search_query.birthday_interval

        people = get_birthday_entity(Person, birthday_interval.first)
        employments = Employment.where(destroyed_at: nil).in(person_short_id: people.map(&:short_id))
        external_contacts = get_birthday_entity(ExternalContact, birthday_interval.first)
        results = get_birthday_results(people, external_contacts)

        present :birthday_interval, birthday_interval
        present :birthdays, results
      elsif search_query.common?
        search_result = search_query.get_results(params[:max], params[:skip])
        results_number = search_query.results_count

        present :results, search_result
        present :results_number, results_number

        employments = fetch_search_result_employments(search_result)
        external_contacts = fetch_search_result_external_contacts(search_result)
        people = fetch_search_result_people(search_result)

        present :units, fetch_search_result_unit_extras(search_result, employments)
      end

      present :type,              search_query.type
      present :query,             params[:q]
      present :employments,       employments
      present :people,            people
      present :external_contacts, external_contacts
    end

  end
end

import { clone, reject, sortBy, forEach } from 'lodash'

import {
  LOADED_FAVORITE_PEOPLE
  LOADED_FAVORITE_UNITS
  ADDING_FAVORITE_EMPLOYMENT
  ADDING_FAVORITE_CONTACT
  ADDING_FAVORITE_UNIT
  REMOVING_FAVORITE_EMPLOYMENT
  REMOVING_FAVORITE_CONTACT
  REMOVING_FAVORITE_UNIT
  SHOW_FAVORITE_PEOPLE
  SHOW_FAVORITE_UNITS
  FAVORITE_PEOPLE
  FAVORITE_UNITS
} from '@constants/favorites'


default_state =
  favorite_people: []
  employment_index: {}
  contact_index: {}
  favorite_units: []
  unit_index: {}
  show: 'people'

export default (state = default_state, action) ->
  switch action.type
    when LOADED_FAVORITE_PEOPLE
      new_employment_index = {}
      new_contact_index = {}

      forEach action.favorite_people, (people) ->
        if people.employment_id?
          new_employment_index[people.employment_id] = true
        else if people.contact_id?
          new_contact_index[people.contact_id] = true

      new_state = clone(state)
      new_state.favorite_people = action.favorite_people
      new_state.employment_index = new_employment_index
      new_state.contact_index = new_contact_index
      new_state

    when LOADED_FAVORITE_UNITS
      new_unit_index = {}

      forEach action.favorite_units, (unit) ->
        new_unit_index[unit.unit_id] = true

      new_state = clone(state)
      new_state.favorite_units = action.favorite_units
      new_state.unit_index = new_unit_index
      new_state

    when ADDING_FAVORITE_EMPLOYMENT
      employment = action.employment
      new_favorite =
        alpha_sort    : employment.alpha_sort
        employment_id : employment.id
      new_favorite_people = clone(state.favorite_people)
      new_favorite_people.push new_favorite

      new_employment_index = clone(state.employment_index)
      new_employment_index[employment.id] = true

      new_state = clone(state)
      new_state.favorite_people = sortBy new_favorite_people, (people) -> people.alpha_sort
      new_state.employment_index = new_employment_index
      new_state

    when ADDING_FAVORITE_CONTACT
      contact = action.contact
      new_favorite =
        alpha_sort : contact.alpha_sort
        contact_id : contact.id
      new_favorite_people = clone(state.favorite_people)
      new_favorite_people.push new_favorite

      new_contact_index = clone(state.contact_index)
      new_contact_index[contact.id] = true

      new_state = clone(state)
      new_state.favorite_people = sortBy new_favorite_people, (people) -> people.alpha_sort
      new_state.contact_index = new_contact_index
      new_state

    when ADDING_FAVORITE_UNIT
      unit = action.unit
      new_favorite =
        alpha_sort : unit.alpha_sort
        unit_id    : unit.id
      new_favorite_units = clone(state.favorite_units)
      new_favorite_units.push new_favorite

      new_unit_index = clone(state.unit_index)
      new_unit_index[unit.id] = true

      new_state = clone(state)
      new_state.favorite_units = sortBy new_favorite_units, (unit) -> unit.alpha_sort
      new_state.unit_index = new_unit_index
      new_state

    when REMOVING_FAVORITE_EMPLOYMENT
      new_employment_index = clone(state.employment_index)
      delete new_employment_index[action.employment_id]

      new_state = clone(state)
      new_state.favorite_people = reject(state.favorite_people, (people) -> people.employment_id == action.employment_id)
      new_state.employment_index = new_employment_index
      new_state

    when REMOVING_FAVORITE_CONTACT
      new_contact_index = clone(state.contact_index)
      delete new_contact_index[action.contact_id]

      new_state = clone(state)
      new_state.favorite_people = reject(state.favorite_people, (people) -> people.contact_id == action.contact_id)
      new_state.contact_index = new_contact_index
      new_state

    when REMOVING_FAVORITE_UNIT
      new_unit_index = clone(state.unit_index)
      delete new_unit_index[action.unit_id]

      new_state = clone(state)
      new_state.favorite_units = reject(state.favorite_units, (unit) -> unit.unit_id == action.unit_id)
      new_state.unit_index = new_unit_index
      new_state

    when SHOW_FAVORITE_PEOPLE
      new_state = clone(state)
      new_state.show = FAVORITE_PEOPLE
      new_state

    when SHOW_FAVORITE_UNITS
      new_state = clone(state)
      new_state.show = FAVORITE_UNITS
      new_state

    else
      state

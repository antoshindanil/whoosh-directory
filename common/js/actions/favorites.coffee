import { UserRequest } from '@lib/request'

import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addUnitTitles } from '@actions/unit_titles'
import { addContacts } from '@actions/contacts'

import {
  LOADED_FAVORITE_PEOPLE
  LOADED_FAVORITE_UNITS
  ADDING_FAVORITE_EMPLOYMENT
  ADDING_FAVORITE_UNIT
  REMOVING_FAVORITE_EMPLOYMENT
  REMOVING_FAVORITE_UNIT
  CHANGED_FAVORITE_EMPLOYMENTS
  CHANGED_FAVORITE_UNITS
  SHOW_FAVORITE_PEOPLE
  SHOW_FAVORITE_UNITS
} from '@constants/favorites'


export loadFavoritePeople = ->
  (dispatch, getState) ->
    UserRequest.get(getState().session?.token, '/favorites/people').then (response) ->
      dispatch(addPeople(response.body.people))
      dispatch(addEmployments(response.body.employments))
      dispatch(addContacts(response.body.external_contacts))
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export loadFavoriteUnits = ->
  (dispatch, getState) ->
    UserRequest.get(getState().session?.token, '/favorites/units').then (response) ->
      dispatch(addUnitTitles(response.body.unit_titles))
      dispatch(loadedFavoriteUnits(response.body.favorite_units))

    , (error) ->


export loadedFavoritePeople = (favorite_people) ->
  type: LOADED_FAVORITE_PEOPLE
  favorite_people: favorite_people


export loadedFavoriteUnits = (favorite_units) ->
  type: LOADED_FAVORITE_UNITS
  favorite_units: favorite_units


export addFavoriteEmployment = (employment_id) ->
  (dispatch, getState) ->
    state = getState()
    dispatch(addingFavoriteEmployment(state.employments[employment_id]))
    UserRequest.post(getState().session?.token, "/favorites/people/employments/#{employment_id}").then (response) ->
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export addingFavoriteEmployment = (employment) ->
  type: ADDING_FAVORITE_EMPLOYMENT
  employment: employment


export addFavoriteUnit = (unit_id) ->
  (dispatch, getState) ->
    state = getState()
    dispatch(addingFavoriteUnit(state.unit_titles[unit_id]))
    UserRequest.post(getState().session?.token, "/favorites/units/#{unit_id}").then (response) ->
      dispatch(loadedFavoriteUnits(response.body.favorite_units))

    , (error) ->


export addingFavoriteUnit = (unit) ->
  type: ADDING_FAVORITE_UNIT
  unit: unit


export removeFavoriteEmployment = (employment_id) ->
  (dispatch, getState) ->
    dispatch(removingFavoriteEmployment(employment_id))
    UserRequest.delete(getState().session?.token, "/favorites/people/employments/#{employment_id}").then (response) ->
      dispatch(loadedFavoritePeople(response.body.favorite_people))

    , (error) ->


export removingFavoriteEmployment = (employment_id) ->
  type: REMOVING_FAVORITE_EMPLOYMENT
  employment_id: employment_id


export removeFavoriteUnit = (unit_id) ->
  (dispatch, getState) ->
    dispatch(removingFavoriteUnit(unit_id))
    UserRequest.delete(getState().session?.token, "/favorites/units/#{unit_id}").then (response) ->
      dispatch(loadedFavoriteUnits(response.body.favorite_units))

    , (error) ->


export removingFavoriteUnit = (unit_id) ->
  type: REMOVING_FAVORITE_UNIT
  unit_id: unit_id


export showFavoriteEmployments = ->
  type: SHOW_FAVORITE_PEOPLE


export showFavoriteUnits = ->
  type: SHOW_FAVORITE_UNITS

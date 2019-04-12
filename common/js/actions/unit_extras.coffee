import { Request } from '@lib/request'

import { START_LOAD_UNIT_EXTRA, FINISH_LOAD_UNIT_EXTRA, SET_UNIT_EXTRA_ERROR } from '@constants/unit_extras'

import { addPeople } from '@actions/people'
import { addEmployments } from '@actions/employments'
import { addContacts } from '@actions/contacts'
import { addUnitTitles } from '@actions/unit_titles'


export loadUnitExtra = (unit_id) ->
  (dispatch, getState) ->
    state = getState()
    unless state.unit_extras[unit_id]?
      dispatch(startLoadUnitExtra(unit_id))

      Request.get("/units/#{unit_id}").then (result) ->
        if result.body.people?
          dispatch(addPeople(result.body.people))
        if result.body.employments?
          dispatch(addEmployments(result.body.employments))
        if result.body.external_contacts?
          dispatch(addContacts(result.body.external_contacts))
        if result.body.unit_titles?
          dispatch(addUnitTitles(result.body.unit_titles))

        dispatch(finishLoadUnitExtra(unit_id))

      , (error) ->

export startLoadUnitExtra = (unit_id) ->
  type: START_LOAD_UNIT_EXTRA
  unit_id: unit_id

export finishLoadUnitExtra = (unit_id) ->
  type: FINISH_LOAD_UNIT_EXTRA
  unit_id: unit_id

export setUnitExtraError = (unit_id, error) ->
  type: SET_UNIT_EXTRA_ERROR
  unit_id: unit_id
  error: error
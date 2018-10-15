import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { isArray } from 'lodash';
#import * as UnitActions from '@actions/organization_unit';

div = React.createFactory('div')

import Employee from '@components/staff/Employee'
employee = React.createFactory(Employee)

import OrganizationSubUnit from '@components/staff/OrganizationSubUnit'
sub_unit = React.createFactory(OrganizationSubUnit)


mapStateToProps = (state) ->
  unit_id = state.current.unit_id
  extra = state.unit_extras[unit_id]
  unit_id:    unit_id
  unit_data:  state.units[unit_id]
  unit_extra: extra && extra.extra || {}
  loading:    extra && extra.loading
  loaded:     extra && extra.loaded

mapDispatchToProps = (dispatch) ->
  {}
#  bindActionCreators(UnitActions, dispatch)


class OrganizationUnitInfo extends React.Component
  @propTypes =
    unit_id: PropTypes.integer

  render: ->
    if @props.unit_id?
      div { className: 'organization-unit-scroller plug' },
        div { className: 'organization-unit' },
          if @props.unit_extra.short_title?
            div { className: 'organization-unit__short-title' },
              @props.unit_extra.short_title
          if @props.unit_extra.long_title? and @props.unit_extra.long_title != @props.unit_extra.short_title
            div { className: 'organization-unit__long-title' },
              @props.unit_extra.long_title

          if isArray(@props.unit_extra.employ_ids)
            div { className: 'organization-unit__employees' },
              for employment_id in @props.unit_extra.employ_ids
                employee { key: employment_id, employment_id: employment_id, hide: { unit: true } }

          if isArray(@props.unit_data.child_ids)
            div { className: 'organization-unit__sub-units' },
              for sub_unit_id in @props.unit_data.child_ids
                sub_unit { key: 'sub-unit-' + sub_unit_id, unit_id: sub_unit_id }

    else
      '...'


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationUnitInfo)

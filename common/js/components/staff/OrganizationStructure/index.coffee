import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as UnitActions from '@actions/units'
import { isEmpty } from 'lodash'

div = React.createFactory('div')

import OrganizationUnitNode from '@components/staff/OrganizationUnitNode'
organization_unit = React.createFactory(OrganizationUnitNode)


mapStateToProps = (state) ->
  units: state.units

mapDispatchToProps = (dispatch) ->
  bindActionCreators(UnitActions, dispatch)


class OrganizationStructure extends React.Component

  @propTypes =
    units: PropTypes.object


  getRoots: ->
    roots = (unit.id for _, unit of @props.units when unit.level == 0)
    roots.sort (a, b) ->
      if a.path < b.path
        -1
      else if a.path > b.path
        1
      else
        0
    roots


  render: ->
    div { className: 'organization-structure-scroller soft-shadow plug', id: 'organization-structure-scroller' },
      div { className: 'organization-structure' },
        unless isEmpty(@props.units)
          for root_id in @getRoots()
            organization_unit { key: root_id, unit_id: root_id }


export default connect(mapStateToProps, mapDispatchToProps)(OrganizationStructure)

import React from 'react'
import { connect } from 'react-redux'
import SvgIcon from '@components/common/SvgIcon'
import Silhouette from '@components/contact_info/CommonSilhouette'
import SomeoneButtons from '@components/common/SomeoneButtons'
import Phones from '@components/contact_info/Phones'
import Email from '@components/contact_info/Email'
import OfficeLocation from '@components/contact_info/OfficeLocation'
import LunchBreak from '@components/contact_info/LunchBreak'
import Birthday from '@components/contact_info/Birthday'
import IconedData from '@components/contact_info/IconedData'
import SearchResultUnit from '@components/staff/SearchResultUnit'
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons'
import { reverse, isEmpty } from 'lodash'

import { setCurrentEmploymentId } from '@actions/current'
import { sinkEmployeeInfo, popNodeInfo, popStructure } from '@actions/layout'
import { goToNodeInStructure } from '@actions/nodes'
import { getNodeParents } from '@actions/employments'
import { currentTime, todayDate } from '@lib/datetime'

div = React.createFactory('div')
span = React.createFactory('span')
a = React.createFactory('a')
img = React.createFactory('img')
svg = React.createFactory(SvgIcon)
silhouette = React.createFactory(Silhouette)
buttons = React.createFactory(SomeoneButtons)
phones = React.createFactory(Phones)
email = React.createFactory(Email)
location = React.createFactory(OfficeLocation)
lunch_break = React.createFactory(LunchBreak)
birthday = React.createFactory(Birthday)
iconed_data = React.createFactory(IconedData)
unit = React.createFactory(SearchResultUnit)
employee = React.createFactory(SomeoneWithButtons)

import CloseButton from '@icons/close_button.svg'
import VacationIcon from '@icons/vacation.svg'


mapStateToProps = (state, ownProps) ->
  employment_id = state.current.employment_id
  employment = state.employments[employment_id]

  employment_id: employment_id
  employment: employment
  person: state.people[employment?.person_id]
  dept_id: employment?.dept_id
  dept: state.nodes.tree[employment?.dept_id]
  node_id: employment?.node_id
  node: state.nodes.tree[employment?.node_id]
  parent_node_id: employment?.parent_node_id
  parent_node: state.nodes.tree[employment?.parent_node_id]
  parents: employment? && reverse(getNodeParents(state, employment))


mapDispatchToProps = (dispatch) ->
  unsetCurrentEmployee: ->
    dispatch(sinkEmployeeInfo())
    dispatch(setCurrentEmploymentId(null))

  goToNode: (node_id) ->
    dispatch(goToNodeInStructure(node_id))
    dispatch(popNodeInfo())
    dispatch(popStructure())


class EmployeeInfo extends React.Component

  setCurrentTime: ->
    @setState
      current_time: currentTime()
      current_date: todayDate()


  isOnLunchNow: ->
    if @props.employment?.lunch_begin? and @props.employment?.lunch_end? and @state?.current_time?
      @props.employment.lunch_begin <= @state.current_time < @props.employment.lunch_end


  isBirthday: ->
    if @props.person?.birthday? and @state?.current_date
      @props.person.birthday == @state.current_date


  componentDidMount: ->
    @setCurrentTime()
    @interval = setInterval((() => @setCurrentTime()), 10000)


  componentWillUnmount: ->
    clearInterval(@interval)


  onCloseButtonClick: ->
    @props.unsetCurrentEmployee()


  onDeptClick: (e) ->
    e.preventDefault()
    @props.goToNode(@props.employment.dept_id)


  onUnitClick: (e) ->
    e.preventDefault()
    @props.goToNode(@props.employment.parent_node_id)


  onEmploymentClick: (e) ->
    e.preventDefault()
    @props.goToNode(@props.employment.node_id)


  render: ->
    div { className: 'employee-info-container soft-shadow plug' },
      div { className: 'employee-info__close-button', onClick: @onCloseButtonClick.bind(this) },
        svg { className: 'employee-info__close-button-cross', svg: CloseButton }

      div { className: 'employee-info-scroller' },

        if @props.employment? and @props.person?

          div { className: 'employee-info' },
            div { className: 'employee-info__head' },
              div { className: 'employee-info__name' },
                @props.person.last_name + ' ' + @props.person.first_name + ' ' + @props.person.middle_name

            if @props.node?
              a { className: 'employee-info__post-title-link', onClick: @onEmploymentClick.bind(this), href: '/' },
                span { className: 'employee-info__post-title' },
                  @props.employment.post_title
            else
              div { className: 'employee-info__post-title' },
                @props.employment.post_title

            if @props.dept_id? and @props.dept_id != @props.parent_node_id and @props.dept?
              a { className: 'employee-info__unit-title-link', onClick: @onDeptClick.bind(this), href: '/' },
                span { className: 'employee-info__unit-long-title' },
                  @props.dept.t

            if @props.parent_node?
              a { className: 'employee-info__unit-title-link', onClick: @onUnitClick.bind(this), href: '/' },
                span { className: 'employee-info__unit-long-title' },
                  @props.parent_node.t

            div { className: 'employee-info__two-columns' },
              div { className: 'employee-info__photo' },
                if @props.person.photo.large.url
                  img { src: process.env.PHOTO_BASE_URL + @props.person.photo.large.url, className: 'employee-info__photo-large' }
                else
                  silhouette { className: 'employee-info__avatar', gender: @props.person.gender }

              div { className: 'employee-info__data' },
                buttons { employment_id: @props.employment_id }

                phones { format_phones: @props.employment.format_phones, className: 'employee-info__iconed-data employee-info__phones' }

                email { email: @props.person.email, className: 'employee-info__iconed-data employee-info__email' }

                location { building: @props.employment.building, office: @props.employment.office, className: 'employee-info__iconed-data employee-info__location' }

                lunch_break { lunch_begin: @props.employment.lunch_begin, lunch_end: @props.employment.lunch_end, highlighted: ! @props.employment.on_vacation and @isOnLunchNow(), className: 'employee-info__iconed-data employee-info__lunch-break' }

                birthday { birthday_formatted: @props.person.birthday_formatted, highlighted: @isBirthday(), className: 'employee-info__iconed-data employee-info__birthday' }

                if @props.employment.on_vacation
                  iconed_data { className: 'employee-info__iconed-data employee-info__vacation', icon: VacationIcon, align_icon: 'middle' },
                    'В отпуске'

            unless isEmpty(@props.parents)
              div { className: 'employee-info__structure' },
                div { className: 'employee-info__structure-title' },
                  'Оргструктура'

                div { className: 'employee-info__structure-units' },
                  for parent in @props.parents
                    if parent.unit?
                      div { key: parent.unit.id, className: 'list-item hair-border' },
                        unit unit_id: parent.unit.id, className: 'employee-info__structure-unit'
                        if parent.head?
                          employee key: parent.head.id, employment_id: parent.head.id, hide: { unit: true }, className: 'employee-info__structure-employment'

                    else if parent.employment?
                      div { key: parent.employment.id, className: 'list-item hair-border' },
                        employee key: parent.employment.id, employment_id: parent.employment.id, hide: { unit: true }, className: 'employee-info__structure-employment'


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo)

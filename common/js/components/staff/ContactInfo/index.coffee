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

import { setCurrentContactId } from '@actions/current'
import { sinkEmployeeInfo, popNodeInfo, popStructure } from '@actions/layout'
import { goToNodeInStructure } from '@actions/nodes'
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

import CloseButton from '@icons/close_button.svg'
import VacationIcon from '@icons/vacation.svg'


mapStateToProps = (state, ownProps) ->
  contact_id = state.current.contact_id
  contact = state.contacts[contact_id]

  contact_id: contact_id
  contact: contact
  node_id: contact?.node_id
  node: state.nodes.tree[contact?.node_id]

mapDispatchToProps = (dispatch) ->
  unsetCurrentContact: ->
    dispatch(sinkEmployeeInfo())
    dispatch(setCurrentContactId(null))

  goToNode: (node_id) ->
    dispatch(goToNodeInStructure(node_id))
    dispatch(popNodeInfo())
    dispatch(popStructure())


class EmployeeInfo extends React.Component

  isOnLunchNow: ->
    if @props.contact?.lunch_begin? and @props.contact?.lunch_end? and @state?.current_time?
      @props.contact.lunch_begin <= @state.current_time < @props.contact.lunch_end


  isBirthday: ->
    if @props.person?.birthday? and @state?.current_date
      @props.person.birthday == @state.current_date


  componentDidMount: ->
    @setCurrentTime()
    @interval = setInterval((() => @setCurrentTime()), 10000)


  componentWillUnmount: ->
    clearInterval(@interval)


  setCurrentTime: ->
    @setState
      current_time: currentTime()
      current_date: todayDate()


  onCloseButtonClick: ->
    @props.unsetCurrentContact()


  onNodeClick: (e) ->
    e.preventDefault()
    @props.goToNode(@props.node_id)


  render: ->
    div { className: 'employee-info-container soft-shadow plug' },
      div { className: 'employee-info__close-button', onClick: @onCloseButtonClick.bind(this) },
        svg { className: 'employee-info__close-button-cross', svg: CloseButton }

      div { className: 'employee-info-scroller' },

        if @props.contact
          div { className: 'employee-info contact-info' },

            div { className: 'employee-info__head contact-info__head' },

              div { className: 'employee-info__name contact-info__name' },
                if @props.contact.last_name
                  @props.contact.last_name + ' ' + @props.contact.first_name + ' ' + @props.contact.middle_name
                else if @props.contact.function_title
                  @props.contact.function_title
                else if @props.contact.location_title
                  @props.contact.location_title

            div { className: 'employee-info__post-title' },
              @props.contact.post_title

            if @props.node?
              a { className: 'employee-info__unit_title', onClick: @onNodeClick.bind(this), href: '/' },
                span { className: 'employee-info__unit-long-title' },
                  @props.node.t

            div { className: 'employee-info__two-columns' },

              if @props.contact.photo.large.url? or @props.contact.gender?
                div { className: 'employee-info__photo' },
                  if @props.contact.photo.large.url?
                    img { src: process.env.PHOTO_BASE_URL + @props.contact.photo.large.url, className: 'employee-info__photo-large' }
                  else if @props.contact.gender?
                    silhouette { className: 'employee-info__avatar', gender: @props.contact.gender }
              else if @props.contact.gender?
                silhouette { className: 'employee-info__avatar', gender: @props.contact.gender }

              div { className: 'employee-info__data' },

                buttons { contact_id: @props.contact_id }

                phones { format_phones: @props.contact.format_phones, className: 'employee-info__iconed-data employee-info__phones' }

                email { email: @props.contact.email, className: 'employee-info__iconed-data employee-info__email' }

                location { building: @props.contact.building, office: @props.contact.office, className: 'employee-info__iconed-data employee-info__location' }

                lunch_break { lunch_begin: @props.contact.lunch_begin, lunch_end: @props.contact.lunch_end, highlighted: ! @props.contact.on_vacation and @isOnLunchNow(), className: 'employee-info__iconed-data employee-info__lunch-break' }

                birthday { birthday_formatted: @props.contact.birthday_formatted, className: 'employee-info__iconed-data employee-info__birthday' }

                if @props.contact.on_vacation
                  iconed_data { className: 'employee-info__iconed-data employee-info__vacation', icon: VacationIcon, align_icon: 'middle' },
                    'В отпуске'


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo)

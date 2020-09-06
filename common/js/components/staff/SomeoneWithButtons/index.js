/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { clone } from 'lodash';

import SvgIcon from '@components/common/SvgIcon';

import {
  addEmploymentToCall,
  addContactToCall,
  checkEmploymentToCall,
  checkContactToCall
} from '@actions/to_call';
import {
  addFavoriteEmployment,
  addFavoriteContact,
  removeFavoriteEmployment,
  removeFavoriteContact
} from '@actions/favorites';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

import Employee from '@components/staff/Employee';
const employee = React.createFactory(Employee);

import Contact from '@components/staff/Contact';
const contact = React.createFactory(Contact);

import ToCallIcon from '@icons/call.svg';
import StarIcon from '@icons/star.svg';

const mapStateToProps = function(state, ownProps) {
  if (ownProps.employment_id != null) {
    return {
      is_to_call: __guard__(
        state.to_call != null
          ? state.to_call.unchecked_employment_index
          : undefined,
        x => x[ownProps.employment_id]
      ),
      is_favorite: state.favorites.employment_index[ownProps.employment_id]
    };
  } else if (ownProps.contact_id != null) {
    return {
      is_to_call: __guard__(
        state.to_call != null
          ? state.to_call.unchecked_contact_index
          : undefined,
        x1 => x1[ownProps.contact_id]
      ),
      is_favorite: state.favorites.contact_index[ownProps.contact_id]
    };
  } else {
    return {};
  }
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  addToCall() {
    if (ownProps.employment_id != null) {
      return dispatch(addEmploymentToCall(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(addContactToCall(ownProps.contact_id));
    }
  },

  checkToCall() {
    if (ownProps.employment_id != null) {
      return dispatch(checkEmploymentToCall(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(checkContactToCall(ownProps.contact_id));
    }
  },

  favorite() {
    if (ownProps.employment_id != null) {
      return dispatch(addFavoriteEmployment(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(addFavoriteContact(ownProps.contact_id));
    }
  },

  unfavorite() {
    if (ownProps.employment_id != null) {
      return dispatch(removeFavoriteEmployment(ownProps.employment_id));
    } else if (ownProps.contact_id != null) {
      return dispatch(removeFavoriteContact(ownProps.contact_id));
    }
  }
});

class SomeoneWithButtons extends React.Component {
  onAddToCall() {
    if (this.props.is_to_call) {
      return this.props.checkToCall();
    } else {
      return this.props.addToCall();
    }
  }

  onFavorite() {
    if (this.props.is_favorite) {
      return this.props.unfavorite();
    } else {
      return this.props.favorite();
    }
  }

  render() {
    if (this.props.employment_id == null && this.props.contact_id == null) {
      return '';
    }

    const child_props = clone(this.props);
    delete child_props.key;

    const class_names = {
      'employee-with-buttons': true,
      'employee-buttons-container': true,
      'employee-with-buttons_is-to-call-scheduled': this.props.is_to_call,
      'employee-with-buttons_is-favorite': this.props.is_favorite
    };
    class_names[this.props.className] = true;

    return div(
      { className: classNames(class_names) },

      (() => {
        if (this.props.employment_id != null) {
          child_props.className = 'employee-with-buttons__employee';
          return employee(child_props);
        } else if (this.props.contact_id != null) {
          child_props.className = 'employee-with-buttons__contact';
          return contact(child_props);
        }
      })(),

      div(
        {
          className:
            'employee-with-buttons__buttons employee-buttons-container__buttons'
        },
        div(
          {
            className:
              'employee-with-buttons__button employee-with-buttons__to-call employee-buttons-container__button',
            onClick: this.onAddToCall.bind(this)
          },
          svg({
            className: 'medium-icon employee-with-buttons__icon',
            svg: ToCallIcon
          })
        ),

        div(
          {
            className:
              'employee-with-buttons__button employee-with-buttons__favorite employee-buttons-container__button',
            onClick: this.onFavorite.bind(this)
          },
          svg({
            className: 'medium-icon employee-with-buttons__icon',
            svg: StarIcon
          })
        )
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SomeoneWithButtons);

function __guard__(value, transform) {
  return typeof value !== 'undefined' && value !== null
    ? transform(value)
    : undefined;
}

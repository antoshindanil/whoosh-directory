/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';

import CommonAvatar from '@components/staff/CommonAvatar';

import { goToNodeInStructure } from '@actions/nodes';
import { setHighlightedUnitId } from '@actions/current';
import { popNodeInfo, popStructure } from '@actions/layout';

const div = React.createFactory('div');
const img = React.createFactory('img');
const avatar = React.createFactory(CommonAvatar);


const mapStateToProps = function(state, ownProps) {
  const node = state.nodes.data[ownProps.node_id];
  const employment = state.employments[node != null ? node.employment_id : undefined];

  return {
    node,
    tree_node: state.nodes.tree[ownProps.node_id],
    employment,
    person: state.people[employment != null ? employment.person_id : undefined],
    unit: state.units[node != null ? node.unit_id : undefined]
  };
};


const mapDispatchToProps = function(dispatch, ownProps) {
  return {
    click() {
      dispatch(goToNodeInStructure(this.node.id));
      dispatch(popNodeInfo());
      return dispatch(popStructure());
    }
  };
};


class NodeLink extends React.Component {
  static initClass() {
  
    this.propTypes =
      {node_id: PropTypes.integer};
  }


  onUnitClick() {
    return this.props.click();
  }


  render() {
    const class_names =
      {'node-link' : true};
    class_names[this.props.className] = true;

    return div({ className: classNames(class_names), onClick: this.onUnitClick.bind(this) },
      (() => {
        if (this.props.unit != null) {
          return [
            (this.props.unit.short_title != null) ?
              div({ className: 'node-link__unit-short-title', key: 'short' },
                this.props.unit.short_title) : undefined,

            (this.props.unit.long_title != null) ?
              div({ className: 'node-link__unit-long-title', key: 'long' },
                this.props.unit.long_title) : undefined
          ];

        } else if (this.props.employment != null) {

          const photo = this.props.person != null ? this.props.person.photo : undefined;

          return div({ className: 'node-link__employee-link' },
            div({ className: 'node-link__employee-photo' },
              (__guard__(photo != null ? photo.thumb39 : undefined, x => x.url) != null) ?
                img({ src: process.env.PHOTO_BASE_URL + photo.thumb39.url, className: 'node-link__employee-thumb39' })
                :
                avatar({ className: 'node-link__avatar', gender: (this.props.person != null ? this.props.person.gender : undefined), post_code: this.props.employment.post_code })),

            div({ className: 'node-link__employment-post-title' },
              this.props.employment.post_title)
          );
        }
      })()
    );
  }
}
NodeLink.initClass();


export default connect(mapStateToProps, mapDispatchToProps)(NodeLink);

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
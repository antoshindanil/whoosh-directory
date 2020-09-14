import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as UnitActions from '@actions/units';
import { isEmpty } from 'lodash';

const div = React.createFactory('div');

import Node from '@components/staff/Node';
const node = React.createFactory(Node);

const mapStateToProps = state => ({
  root_ids: state.nodes.root_ids
});

const mapDispatchToProps = dispatch =>
  bindActionCreators(UnitActions, dispatch);

class OrganizationStructure extends React.Component {
  static initClass() {
    this.propTypes = { root_ids: PropTypes.array };
  }

  render() {
    return div(
      {
        className: 'organization-structure-scroller soft-shadow plug',
        id: 'organization-structure-scroller'
      },
      div(
        { className: 'organization-structure' },
        this.props.root_ids.map(root_id =>
          node({ key: root_id, node_id: root_id })
        )
      )
    );
  }
}
OrganizationStructure.initClass();

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(OrganizationStructure);

/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { isEmpty } from 'lodash';

import { loadMissingNodeData } from '@actions/nodes';


const requested_node_ids = {};


const loadNode = function(store, node_id) {
  if (requested_node_ids[node_id] == null) {
    const state = store.getState();
    if (!isEmpty(state.nodes.tree)) {
      requested_node_ids[node_id] = true;
      return store.dispatch(loadMissingNodeData(node_id));
    }
  }
};


export default store => store.subscribe(function() {
  const state = store.getState();

  const node_id = state.nodes.current_id;

  if (node_id != null) {
    return loadNode(store, node_id);
  }
});

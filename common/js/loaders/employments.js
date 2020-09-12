import { isEmpty } from 'lodash';

import { getNodeParentIds, loadEmployments } from '@actions/employments';
import { loadMissingNodeData } from '@actions/nodes';

const requested_employment_ids = {};
const requested_hierarchy_employment_ids = {};

export default store =>
  store.subscribe(() => {
    const state = store.getState();

    const employment_id =
      state.current != null ? state.current.employment_id : undefined;
    const employment = state.employments[employment_id];

    if (employment_id) {
      if (employment) {
        if (!isEmpty(state.nodes.tree)) {
          if (requested_hierarchy_employment_ids[employment_id] == null) {
            requested_hierarchy_employment_ids[employment_id] = true;

            const parent_ids = getNodeParentIds(state, employment);
            return store.dispatch(loadMissingNodeData(parent_ids));
          }
        }
      } else {
        if (requested_employment_ids[employment_id] == null) {
          requested_employment_ids[employment_id] = true;
          return store.dispatch(loadEmployments([employment_id]));
        }
      }
    }
  });

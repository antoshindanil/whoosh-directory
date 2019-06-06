import { isArray, isEmpty, reject } from 'lodash'

import { Request, UserRequest } from '@lib/request'

import {
  ADD_NODE_DATA,
  ADD_NODE_TREE,
  COLLAPSE_NODE,
  EXPAND_NODE,
  LOADED_NODE_IDS,
  SCROLL_TO_NODE,
  SCROLLED_TO_NODE,
  SET_CURRENT_NODE,
  SET_EXPANDED_NODES
} from '@constants/nodes'

import { addUnits } from '@actions/units'
import { addEmployments } from '@actions/employments'
import { addPeople } from '@actions/people'
import { addContacts } from '@actions/contacts'


export loadNodeTree = ->
  (dispatch) ->
    Request.get('/nodes').then (result) ->
      dispatch(addNodeTree(result.body.nodes, result.body.root_ids))
    , (error) ->


export addNodeTree = (nodes, root_ids) ->
  type: ADD_NODE_TREE
  nodes: nodes
  root_ids: root_ids


filterLoadedNodeIds = (state, node_ids) ->
  reject node_ids, (node_id) ->
    state.nodes.loaded[node_id]


export loadMissingNodeData = (node_ids) ->
  (dispatch, getState) ->
    state = getState()
    node_ids = [node_ids] unless isArray(node_ids)

    missing_node_ids = filterLoadedNodeIds(state, node_ids)

    if missing_node_ids.length > 0
      Request.get('/nodes/' + missing_node_ids.join(',')).then (result) ->
        dispatch(addNodes(result.body.nodes))
        dispatch(addUnits(result.body.units))
        dispatch(addEmployments(result.body.employments))
        dispatch(addPeople(result.body.people))
        dispatch(addContacts(result.body.contacts))
      , (error) ->


export addNodes = (nodes) ->
  type: ADD_NODE_DATA
  nodes: nodes


export loadedNodeIds = (nodes) ->
  type: LOADED_NODE_IDS
  node_ids: node_ids


export loadExpandedNodes = ->
  (dispatch, getState) ->
    UserRequest.get(getState, 'expanded_nodes').then (result) ->
      dispatch(setExpandedNodes(result.body.expanded_nodes))

    , (error) ->


export setExpandedNodes = (node_ids) ->
  type: SET_EXPANDED_NODES
  node_ids: node_ids


export collapseNode = (node_id) ->
  type: COLLAPSE_NODE
  node_id: node_id


export saveCollapsedNode = (node_id) ->
  (dispatch, getState) ->
    node_ids = [node_id] unless isArray(node_id)
    UserRequest.delete(getState, 'expanded_nodes/' + node_ids.join(',')).then()


export expandNodes = (node_id) ->
  type: EXPAND_NODE
  node_id: node_id

export expandNode = expandNodes


export saveExpandedNodes = (node_ids) ->
  (dispatch, getState) ->
    node_ids = [node_ids] unless isArray(node_ids)
    UserRequest.post(getState, 'expanded_nodes/' + node_ids.join(',')).then()

export saveExpandedNode = saveExpandedNodes


export setCurrentNodeId = (node_id) ->
  type: SET_CURRENT_NODE
  node_id: node_id


export scrollToNode = (node_id) ->
  type: SCROLL_TO_NODE
  node_id: node_id


export scrolledToNode = (node_id) ->
  type: SCROLLED_TO_NODE
  node_id: node_id


export openFullNodePath = (node_id) ->
  (dispatch, getState) ->
    node = getState().nodes.tree[node_id]

    unless isEmpty(node?.path)
      dispatch(expandNodes(node.path))
      dispatch(saveExpandedNodes(node.path))


export goToNodeInStructure = (node_id) ->
  (dispatch) ->
    dispatch(openFullNodePath(node_id))
    dispatch(setCurrentNodeId(node_id))
    dispatch(scrollToNode(node_id))

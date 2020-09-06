/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import classNames from 'classnames';
import SvgIcon from '@components/common/SvgIcon';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

class IconedData extends React.Component {

  render() {
    const classes = {
      'iconed-data' : true,
      'iconed-data_icon-align-top' : this.props.align_icon === 'top',
      'iconed-data_icon-align-middle' : this.props.align_icon === 'middle',
      'iconed-data_clickable' : !!this.props.onClick
    };
    classes[this.props.className] = true;

    return div({ className: classNames(classes), onClick: this.props.onClick },
      svg({ className: 'big-icon iconed-data__icon', svg: this.props.icon }),
      div({ className: 'iconed-data__container' },
        div({ className: 'iconed-data__data' },
          this.props.children)
      )
    );
  }
}


export default IconedData;

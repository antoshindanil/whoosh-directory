// cache the main layout template with lodash
import { template } from 'lodash';
import { Helmet } from 'react-helmet';

const { NODE_ENV } = process.env;
const env = NODE_ENV || 'development';
const compile = template(require('@templates/layouts/application.html'));

export default function render(html, initialState = {}, bundles = []) {
  if (env === 'development') {
    global.ISOTools.refresh();
  }

  const assets = global.ISOTools.assets();
  const polyJs = assets.javascript.polyfill;
  const appJs = assets.javascript.app;
  const vendorJs = assets.javascript.vendor;
  const helmet = Helmet.renderStatic();
  const appCss = assets.styles.app;
  const vendorCss = assets.styles.vendor;
  const chunkCss = bundles.filter(bundle => bundle.file.match(/.css/));
  const chunkJs = bundles.filter(bundle => bundle.file.match(/.js/));

  return compile({
    html,
    helmet,
    polyJs,
    appCss,
    appJs,
    vendorJs,
    vendorCss,
    chunkCss,
    chunkJs,
    initialState
  });
}

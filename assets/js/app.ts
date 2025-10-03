import '../css/app.css';

import 'phoenix_html';

import * as phoenix from 'phoenix';
import {LiveSocket} from 'phoenix_live_view';

interface Hook {
  mounted?(): void;
  destroyed?(): void;
}

const Hooks: Record<string, Hook> = {};

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute('content');

const liveSocket = new LiveSocket('/live', phoenix.Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken} // eslint-disable-line camelcase
});

liveSocket.connect();

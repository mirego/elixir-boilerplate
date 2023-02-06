import 'simple-css-reset/reset.css';
import '../css/app.css';

import {Socket} from 'phoenix';
import {LiveSocket} from 'phoenix_live_view';

const FLASH_TTL = 8000;
const Hooks = {};

Hooks.Flash = {
  mounted() {
    const hide = () =>
      liveSocket.execJS(this.el, this.el.getAttribute('phx-click'));
    this.timer = setTimeout(() => hide(), FLASH_TTL);
    this.el.addEventListener('mouseover', () => {
      clearTimeout(this.timer);
      this.timer = setTimeout(() => hide(), FLASH_TTL);
    });
  },
  destroyed() {
    clearTimeout(this.timer);
  }
};

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content');

const liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken} // eslint-disable-line camelcase
});

liveSocket.connect();

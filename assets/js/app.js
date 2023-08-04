// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html';

// Show progress bar on live navigation and form submits
import topbar from 'topbar';

const DELAY_IN_MILISECONDS = 200;

topbar.config({barColors: {0: '#29d'}, shadowColor: 'rgba(0, 0, 0, .3)'});
window.addEventListener('phx:page-loading-start', (_info) =>
  topbar.delayedShow(DELAY_IN_MILISECONDS)
);
window.addEventListener('phx:page-loading-stop', (_info) => topbar.hide());

// Establish Phoenix Socket and LiveView configuration.
import {Socket} from 'phoenix';
import {LiveSocket} from 'phoenix_live_view';

const FLASH_TTL = 8000;
const Hooks = {};

Hooks.Flash = {
  mounted() {
    this.timer = setTimeout(() => this._hide(), FLASH_TTL);

    this.el.addEventListener('mouseover', () => {
      clearTimeout(this.timer);
      this.timer = setTimeout(() => this._hide(), FLASH_TTL);
    });
  },

  destroyed() {
    clearTimeout(this.timer);
  },

  _hide() {
    liveSocket.execJS(this.el, this.el.getAttribute('phx-click'));
  }
};

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken} // eslint-disable-line camelcase
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

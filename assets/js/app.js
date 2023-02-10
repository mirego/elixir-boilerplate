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

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, {
  // eslint-disable-next-line camelcase
  params: {_csrf_token: csrfToken}
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

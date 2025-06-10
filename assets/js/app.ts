import '../css/app.css';

import {Socket} from 'phoenix';
import {LiveSocket} from 'phoenix_live_view';

interface Hook {
  mounted?(): void;
  destroyed?(): void;
}

interface FlashHook extends Hook {
  el: HTMLElement;
  timer: ReturnType<typeof setTimeout>;
  FLASH_TTL: number;
  _hide(): void;
}

const Hooks: Record<string, Hook> = {};

Hooks.Flash = {
  el: null as unknown as HTMLElement,
  timer: null as unknown as ReturnType<typeof setTimeout>,
  FLASH_TTL: 8000,

  mounted(this: FlashHook) {
    this.timer = setTimeout(() => this._hide(), this.FLASH_TTL);

    this.el.addEventListener('mouseover', () => {
      clearTimeout(this.timer);
      this.timer = setTimeout(() => this._hide(), this.FLASH_TTL);
    });
  },

  destroyed() {
    clearTimeout(this.timer);
  },

  _hide() {
    liveSocket.execJS(this.el, this.el.getAttribute('phx-click'));
  }
} as FlashHook;

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute('content');

const liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken} // eslint-disable-line camelcase
});

liveSocket.connect();

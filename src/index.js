import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import loadingGif from '../public/images/loading.gif';

// load our assets and start a service worker
Main.fullscreen({images: {loading: loadingGif}});
registerServiceWorker();

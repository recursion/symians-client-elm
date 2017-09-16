import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import loadingGif from '../public/images/loading.gif';
Main.fullscreen({images: {loading: loadingGif}});

registerServiceWorker();

import { Main } from './Main.elm';
import loadingGif from '../public/images/loading.gif';
require('./styles.css');
Main.fullscreen({images: {loading: loadingGif}});

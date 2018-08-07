import nextReduxSaga from 'next-redux-saga';
import withRedux from 'next-redux-wrapper';

import { configureStore } from './ConfigureStore';

export const WithReduxSaga = (opts = {}) => BaseComponent =>
  withRedux({ createStore: configureStore, ...opts })(nextReduxSaga(BaseComponent));

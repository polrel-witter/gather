import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { ThemeProvider } from "styled-components";
import light from "@tlon/indigo-light";
import { Reset } from "@tlon/indigo-react";
import { createContext, useContext } from 'react'
import { createStore, useStore } from 'zustand'
import { transitions, positions, Provider as AlertProvider } from 'react-alert'
import AlertTemplate from 'react-alert-template-mui'

// optional configuration
const options = {
  // you can also just use 'bottom center'
  position: positions.BOTTOM_CENTER,
  timeout: 3000,
  offset: '30px',
  // you can also just use 'scale'
  transition: transitions.SCALE
}

// const StoreContext = createContext();

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
		<ThemeProvider theme={light}>
      <Reset theme={light} />
       <AlertProvider template={AlertTemplate} {...options}>
         <App />
       </AlertProvider>
    </ThemeProvider>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
// reportWebVitals();

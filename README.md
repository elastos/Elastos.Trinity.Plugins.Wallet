# elastos-trinity-plugins-wallet

This plugin defines a global `cordova.wallet` object, which provides an API for wallet library.

Although in the global scope, it is not available until after the `deviceready` event.

```js
document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
    console.log(wallet);
}
```
---

## Installation

    The plugins field of dapp manifest.json adds Wallet values, such as "plugins": ["XXXX", "Wallet", "XXXX"]

## Supported Platforms

- Android
- iOS
<p align="center">
  <h1 align="center">Atlantic Web3</h1>
</p>

<p align="center">
  <a href="https://twitter.com/flutterfiredev">
    <img src="https://img.shields.io/twitter/follow/flutterfiredev.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter&style=flat-square" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Maintained with Melos" />
  </a>
  <a href="https://api.securityscorecards.dev/projects/github.com/firebase/flutterfire">
    <img src="https://api.securityscorecards.dev/projects/github.com/firebase/flutterfire/badge" alt="OSSF scorecard" />
  </a>
</p>


---

### Introduccion

Atlantic Web3 es un set de [Flutter plugins](https://flutter.io/platform-plugins/) habilitados para ser usados con una
aplicacion Flutter, el objetivo es proveer un conjunto de herramientas que sirvan para crear e interacturar con 
distintas redes Blockchain basadas en web3, asi es posible crear aplicaciones que puedan usar contratos inteligentes


### Tabla de Contenidos

- [Que es Flutter?](#que-es-flutter)
- [Que es Solidity?](#que-es-solidity)
- [Que es un Contrato Inteligente?](#que-es-un-contrato-inteligente)
- [Lista de Plugins](#lista-de-plugins)
- [Issues](#issues)
- [Contributing](#contributing)

### Que es Flutter?

[Flutter](https://flutter.dev) is Google’s UI toolkit for building beautiful, natively compiled applications for mobile,
web, and desktop from a single codebase. Flutter is used by developers and organizations around the world, and is free
and open source.

### Que es Solidity?

Solidity es un lenguaje de programación orientado a objetos y de alto nivel para implementar contratos. Los contratos
inteligentes son programas que rigen el comportamiento de las cuentas dentro de la Máquina Virtual Ethereum (EVM).

Solidity es un lenguaje de llaves diseñado para apuntar a la Máquina Virtual Ethereum (EVM). Está influenciado por C ++,
Python y JavaScript. Puede encontrar más detalles sobre en qué idiomas se ha inspirado Solidity en la sección de
influencias lingüísticas.

### Que es un Contrato Inteligente?

Los contratos inteligentes son acuerdos entre dos o más agentes en donde una vez definidas las condiciones, las
consecuencias se ejecutan de manera automática sin la necesidad de intermediarios.

---

### Lista de Plugins

| Name                   | pub.dev                                                                                                                                             | Firebase Product                                                                                                                                                             | Documentation                                                     | View Source                                                                                                                     | Android | iOS | Web | MacOS |
|------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------:|:---------:|:-----:|:-----:|:-------:|
| Atlantic BIP 32        | [![Analytics pub.dev badge](https://img.shields.io/pub/v/firebase_analytics.svg)](https://pub.dev/packages/firebase_analytics)                      | [🔗](https://firebase.google.com/products/analytics)                 | [📖](https://firebase.flutter.dev/docs/analytics/overview)        | [`atlantic_bip32`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_analytics)                 | ✔       | ✔   | ✔   | β     |
| Atlantic BIP 39        | [![Authentication pub.dev badge](https://img.shields.io/pub/v/firebase_auth.svg)](https://pub.dev/packages/firebase_auth)                           | [🔗](https://firebase.google.com/products/auth)                      | [📖](https://firebase.flutter.dev/docs/auth/overview)             | [`atlantic_bip39`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_auth)                           | ✔       | ✔   | ✔   | β     |
| Atlantic Web3          | [![Cloud Firestore pub.dev badge](https://img.shields.io/pub/v/cloud_firestore.svg)](https://pub.dev/packages/cloud_firestore)                      | [🔗](https://firebase.google.com/products/firestore)                 | [📖](https://firebase.flutter.dev/docs/firestore/overview)        | [`atlantic_web3`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/cloud_firestore)                       | ✔       | ✔   | ✔   | β     |
| Atlantic Web3 Core     | [![Cloud Functions pub.dev badge](https://img.shields.io/pub/v/cloud_functions.svg)](https://pub.dev/packages/cloud_functions)                      | [🔗](https://firebase.google.com/products/functions)                 | [📖](https://firebase.flutter.dev/docs/functions/overview)        | [`atlantic_web3_core`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/cloud_functions)                       | ✔       | ✔   | ✔   | β     |
| Atlantic Web3 ETH      | [![Cloud Messaging pub.dev badge](https://img.shields.io/pub/v/firebase_messaging.svg)](https://pub.dev/packages/firebase_messaging)                | [🔗](https://firebase.google.com/products/cloud-messaging)           | [📖](https://firebase.flutter.dev/docs/messaging/overview)        | [`atlantic_web3_eth`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_messaging)                 | ✔       | ✔   | ✔   | β     |
| Atlantic Web3 ABI      | [![Cloud Storage pub.dev badge](https://img.shields.io/pub/v/firebase_storage.svg)](https://pub.dev/packages/firebase_storage)                      | [🔗](https://firebase.google.com/products/storage)                   | [📖](https://firebase.flutter.dev/docs/storage/overview)          | [`atlantic_web3_eth_abi`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_storage)                     | ✔       | ✔   | ✔   | β     |
| Atlantic Web3 Accounts | [![Core pub.dev badge](https://img.shields.io/pub/v/firebase_core.svg)](https://pub.dev/packages/firebase_core)                                     | [🔗](https://firebase.google.com)                                    | [📖](https://firebase.flutter.dev/docs/core/usage)                | [`atlantic_web3_eth_accounts`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_core)                           | ✔       | ✔   | ✔   | β     |
| Atlantic Web3 Contract | [![Crashlytics pub.dev badge](https://img.shields.io/pub/v/firebase_crashlytics.svg)](https://pub.dev/packages/firebase_crashlytics)                | [🔗](https://firebase.google.com/products/crashlytics)               | [📖](https://firebase.flutter.dev/docs/crashlytics/overview)      | [`atlantic_web3_eth_contract`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_crashlytics)             | ✔       | ✔   | N/A | β     |
| Atlantic Web3 ENS      | [![Dynamic Links pub.dev badge](https://img.shields.io/pub/v/firebase_dynamic_links.svg)](https://pub.dev/packages/firebase_dynamic_links)          | [🔗](https://firebase.google.com/products/dynamic-links)             | [📖](https://firebase.flutter.dev/docs/dynamic-links/overview)    | [`atlantic_web3_eth_ens`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_dynamic_links)         | ✔       | ✔   | N/A | N/A   |
| Atlantic Web3 IBAN     | [![In-App Messaging pub.dev badge](https://img.shields.io/pub/v/firebase_in_app_messaging.svg)](https://pub.dev/packages/firebase_in_app_messaging) | [🔗](https://firebase.google.com/products/in-app-messaging)          | [📖](https://firebase.flutter.dev/docs/in-app-messaging/overview) | [`atlantic_web3_eth_iban`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_in_app_messaging)   | ✔       | ✔   | N/A | N/A   |
| Atlantic Web3 Personal | [![Installations pub.dev badge](https://img.shields.io/pub/v/firebase_app_installations.svg)](https://pub.dev/packages/firebase_app_installations)  | [🔗](https://firebase.google.com/docs/projects/manage-installations) | [📖](https://firebase.flutter.dev/docs/installations/overview)    | [`atlantic_web3_eth_personal`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_app_installations) | ✔       | ✔   | ✔   | β     |
| Atlantic Web3 Net      | [![Performance Monitoring pub.dev badge](https://img.shields.io/pub/v/firebase_performance.svg)](https://pub.dev/packages/firebase_performance)     | [🔗](https://firebase.google.com/products/performance)               | [📖](https://firebase.flutter.dev/docs/performance/overview)      | [`atlantic_web3_net`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_performance)             | ✔       | ✔   | ✔   | N/A   |
| Atlantic Provider HTTP | [![Realtime Database pub.dev badge](https://img.shields.io/pub/v/firebase_database.svg)](https://pub.dev/packages/firebase_database)                | [🔗](https://firebase.google.com/products/database)                  | [📖](https://firebase.flutter.dev/docs/database/overview)         | [`atlantic_web3_providers_http`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_database)                   | ✔       | ✔   | ✔   | β     |
| Atlantic Provider IPC  | [![Remote Config pub.dev badge](https://img.shields.io/pub/v/firebase_remote_config.svg)](https://pub.dev/packages/firebase_remote_config)          | [🔗](https://firebase.google.com/products/remote-config)             | [📖](https://firebase.flutter.dev/docs/remote-config/overview)    | [`atlantic_web3_providers_ipc`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_remote_config)         | ✔       | ✔   | ✔   | β     |
| Atlantic Provider WS   | [![Remote Config pub.dev badge](https://img.shields.io/pub/v/firebase_remote_config.svg)](https://pub.dev/packages/firebase_remote_config)          | [🔗](https://firebase.google.com/products/remote-config)             | [📖](https://firebase.flutter.dev/docs/remote-config/overview)    | [`atlantic_web3_providers_ws`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_remote_config)         | ✔       | ✔   | ✔   | β     |
| Atlantic Web3 Utils    | [![Remote Config pub.dev badge](https://img.shields.io/pub/v/firebase_remote_config.svg)](https://pub.dev/packages/firebase_remote_config)          | [🔗](https://firebase.google.com/products/remote-config)             | [📖](https://firebase.flutter.dev/docs/remote-config/overview)    | [`atlantic_web3_utils`](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_remote_config)         | ✔       | ✔   | ✔   | β     |


### Issues

Please file FlutterFire specific issues, bugs, or feature requests in
our [issue tracker](https://github.com/firebase/flutterfire/issues/new/choose).

Plugin issues that are not specific to FlutterFire can be filed in
the [Flutter issue tracker](https://github.com/flutter/flutter/issues/new).

### Contributing

If you wish to contribute a change to any of the existing plugins in this repo, please review
our [contribution guide](https://github.com/firebase/flutterfire/blob/master/CONTRIBUTING.md)
and open a [pull request](https://github.com/firebase/flutterfire/pulls).

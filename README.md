# docker-hsm

![](https://media.giphy.com/media/IrWD6XLtH5jaw/giphy.gif)

A simple little Dockerfile that wraps SoftHSM using PKCS11-proxy in order
to test failures in network connected HSMs (and also to move signing operations
completely out of the calling process).

**This is not safe. It will not protect your keys. Don't use it.**


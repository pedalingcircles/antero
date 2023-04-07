# antero
Home sensor network


## Troubleshooting tips

If you get the following message output when building your Dockerfile 

```
- err: docker-credential-desktop resolves to executable in current directory (./docker-credential-desktop), out: 
```

Then make sure the `~/.docker/config.json` file doesn't have 

```json
"credsStore" : "desktop"
```

## References

https://github.com/ARM-software/Tool-Solutions/tree/main/docker/tensorflow-aarch64

https://hub.docker.com/r/linaro/tensorflow-arm-neoverse-n1/

https://community.arm.com/arm-community-blogs/b/tools-software-ides-blog/posts/aarch64-docker-images-for-tensorflow-and-pytorch

https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tools/tf_sig_build_dockerfiles

https://schultz-christian.medium.com/how-to-run-tensorflow-in-docker-on-an-apple-silicon-mac-c56f3127b696

https://github.com/apple/tensorflow_macos

https://catchzeng.medium.com/deep-learning-tensorflow-jupyterlab-vscode-on-apple-silicon-m1-based-mac-c48881c49c22

https://github.com/keras-team/keras-cv/blob/master/.devcontainer/devcontainer.json

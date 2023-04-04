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
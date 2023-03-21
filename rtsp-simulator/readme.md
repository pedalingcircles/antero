# Setup an RTSP simulated streamer

The following will setup a way to simulate an RTSP stream locally.
a docker container. It uses the [rtsp-simple-server](https://github.com/aler9/rtsp-simple-server#installation), now called MEDIAMTX.

## Build Docker file

Build this Docker file that has FFMPEG added to it. 

`
docker build -t antero/rtspsimulator:1.0 .
`

Run the container on the local machine

`
docker run --rm -it -e RTSP_PROTOCOLS=tcp -p 8554:8554 -p 1935:1935 -p 8888:8888 -p 8889:8889 antero/rtspsimulator:1.0
`

In WSL (or Windows or Mac locally) run

`
ffmpeg -re -stream_loop -1 -i ./Doorbell-3-20-2023.mp4 -c copy -f rtsp rtsp://localhost:8554/mystream
`

> The _Doorbell-3-20-2023.mp4_ file is a sample video file used to simulate the feed.

Test the feed by using VLC and selecting Media > Open Network Stream... and posting _rtsp://localhost:8554/mystream_ as the network URL.
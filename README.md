## rainbow-video

This script akes a video file and outputs a mosaic of frame captures which have been ordered according to hue. This composite image is output into a folder named after the video file.  
How cool it looks depends on the characteristics of the input file. The more saturated and varied colours, the better!

#### Dependencies
* [ffmpeg](https://ffmpeg.org/)
* [imagemagick](https://www.imagemagick.org/script/index.php)
* [python-slugify](https://github.com/un33k/python-slugify)
* [Colour Thief](https://github.com/fengsp/color-thief-py)

#### To use:
* Mke file executable: `chmod +x makerainbow.sh`  
* Run script: `./makerainbow.sh input_video`

#### Example

英雄 aka _Hero_ (Zhang Yimou, CN 2002)
![Hero (2002) image mosaic](./images/hero-ying-xiong-2002_montage_750w.jpg "Hero (2002) image mosaic")

#### ⚠ Caveats & to-dos
* Script should have more error handling
* Blend of Bash and Python - refactor to Python at some stage.

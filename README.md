# ExifReader

Inspired by an episode of [ATP](https://atp.fm) and by this [blog post](https://alexwlchan.net/2020/10/how-do-i-use-my-iphone-cameras/) by Alex Chan I decided to write a simple app to find out which lenses I use the most on my iPhone.


When you run the app it will ask to access the library and will scan for pictures, collect the EXIF data and at the end show you a table with the aggregated data of LensModel.
The slider on the top let you specify a limit, the pictures are in order of date so you get the most recent ones. 

Currently is working if you have the pictures on your device. If you only keep thumbnails on device exif data is not available in my tests.

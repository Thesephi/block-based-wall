# Block-based Wall
A masonry-like gallery logic written in AS 3.0

![test](https://media.giphy.com/media/B7wZyZkHR4yli/giphy.gif)

This is an implementation of a **grid-based, block-based, masonry-like gallery logic**, which takes in an array of items (rectangular blocks of dimension _X by Y_) and arranges them into a canvas of defined area (dynamically adjustable) in such a way that **no 2 blocks can overlap each other** no matter their dimensions and orders in the supplied array; meanwhile, **all the spaces should be optimally utilised** (no redundant row).

The testbed example supplies a collection of default gallery blocks (with dimension _1x1_), then adds in a few blocks of custom dimensions, and finally places them all on a responsive canvas, which, when resized or clicked on, will rearrange the said blocks in a new, random order.

**[A larger demo video can be found here.](https://media.giphy.com/media/B7wZyZkHR4yli/giphy-hd.mp4)** Kudos to Giphy for the awesome service!

## How to compile

- ####Using Adobe Flex SDK

  Supposed you already have **mxmlc** in your **$PATH** environment, compiling the testbed is as simple as:

  ```mxmlc BlockBasedWallTest.as```

  or if you want to specify the output filename:

  ```mxmlc BlockBasedWallTest.as -o /path/to/my/file.swf```

  If you need an instruction on how to install mxmlc, a quick Google search would help a lot, but to make things easier, [here's the link](http://flex.apache.org/download-source.html) to the page where you can download the latest Adobe Flex SDK.

- ####Using Adobe Flash CC / CS

  Adobe Flash users can easily specify ```BlockBasedWallTest.as``` as the **Document Class** of the ```.fla``` file and compile using ```Ctrl + Enter``` on Windows or ```CMD + Enter``` on Mac OS.

## Other notices
1. Please be aware that this is just a **logical implementation**, which means it's not a full-fledged gallery and of course cannot (yet) be used in real-life front-end projects, but I do hope it'll play some nice tutorials and probably some sort of pseudo-code to building such a flavor of gallery in a language of your choice.

2. This code was written in 2012 (ugh so yesterday) so it may not be the best implementation out there; hence, I'd welcome any feedback / bug report.

3. Releasing this source code to the public domain is a part of my initiative in **"maintaining the utilisation of the ActionScript language"**. It's not to stress that AS (or any other language for that matter) should be used in any particular situation, it's just there to let it known to the world that _**we can build things with ActionScript, and it's fun**_.

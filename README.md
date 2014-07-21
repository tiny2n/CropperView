CropperView
=============

It is Cropper View Control.

You can support multiple rect areas.
You can move each of corners.
You can move each of croppers.
You can crop.


### Installation
Add the files to your project manually by dragging the CropperView directory into your Xcode project.


### Usage

```
// Import the class
#import "CropperView.h"

...

// ---------------------------------------------------
// ex) get CropperView in UIViewController or UIView or ...
// ---------------------------------------------------
    // add UIViewController
    CropperView * cropperView = [[CropperView alloc] initWithFrame:self.view.bounds];
    [cropperView addCropper:CGRectMake(10, 10, 100, 100)];    // <- add rect {{10, 10}, {100, 100}}
    [cropperView addCropper:CGRectMake(130, 130, 100, 100)];  // <- if you want multily rect, add rect
    [self.view addSubview:cropperView];
    
...

// ---------------------------------------------------
// ex) crop image by Rect of CopperView
// ---------------------------------------------------
    UIImage * image = [cropperView cropAtIndex:0]; // as multiple Cropper Mode, get image object with particular index
    // or
    NSArray * images = [cropperView crop]; // get image list Cropper's (all image)
    
...

```

![DropAlert](https://github.com/tiny2n/CropperView/blob/master/Screenshot.png)


License
-------------------------------------------------------
The MIT License (MIT)

Copyright (c) 2014 JoongKwan Choi

JKLib

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


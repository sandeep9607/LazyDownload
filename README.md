# LazyDownload

This project is post loading of users, json parsing, image loading and caching in memory, tableview animation, pull to refresh.


### Manual Installing

put LaziImageLoading folter inside your project


## How to use
To download image and maintain cache
```
ImageView.setImage(with: URL(string: (post!.user?.profileImage!.small)!),
                    placeholder: #imageLiteral(resourceName: "noImage"),  progress: nil, completion: nil)
```
Here you can also see the progree of image download. completion block to handle something.

Here is downloader to download image as well as data like JSON,pdf,zip

```
        Downloader.default.download(URL, progress: nil, completion: { data in
          // write your code here...
        })
```


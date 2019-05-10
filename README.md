# exifmonk
Sort images and rename directories based on their contained images and its exif data

# Usage

`./exifmonkdir.sh "my' directöry"`

will analyze the directory and rename it accordingly to:

`20190530_my_directoery`

# Features/Process

- if all pictures were taken on the same day this date is used for a new directory name
- old dates which are already in the directory name will be removed
- special characters (e.g. whitespaces) are replaced or removed (can be configured in the `CONFIG` file)
- the new directory name is the cleaned old one and the date attached as a prefix

# Installation

You just need the `CONFIG` and `.sh` files in the main directory. You also need ImageMagick installed (`identify` is used for the exif extraction).

# History and Why?

I had to sort a lot of my pictures and pictures taken by different people and shared in a non profit organization.
I observed myself doing the same task again and again:

1. Go to one folder in an arbitrary folder structure
2. Check if the folder already conforms to a predefined pattern including the date as a prefix, e.g. 20190530_name_of_event
3. Check if images in the folder contain exif data and all images were shot on the same date (or daterange)
4. Change the foldername to the predfined patter, add the date prefix and move the folder to a predefined structure, e.g. folder 2019 contains directories with images shot in 2019
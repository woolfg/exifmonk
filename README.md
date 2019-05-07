# exifmonk
Sort images and rename directories based on their contained images and its exif data

# Usage

`./exifmonk.sh "my' directöry"`

will analyze the directory and rename it accordingly to:

`20190530_my_directoery`

# History and Why?

I had to sort a lot of my pictures and pictures taken by different people and shared in a non profit organization.
I observed myself doing the same task again and again:

1. Go to one folder in an arbitrary folder structure
2. Check if the folder already conforms to a predefined pattern including the date as a prefix, e.g. 20190530_name_of_event
3. Check if images in the folder contain exif data and all images were shot on the same date (or daterange)
4. Change the foldername to the predfined patter, add the date prefix and move the folder to a predefined structure, e.g. folder 2019 contains directories with images shot in 2019
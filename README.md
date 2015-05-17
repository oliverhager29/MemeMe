# MemeMe
IOS application for creating and sharing a Meme.
A Meme consists of an image (taken with the camera or selected from the photo album) and a top/bottom text. This Meme can be shared (share image action). The shared Memes are saved and can be viewed in a collection/table view, can be deleted and edit. New Memes can be added. a Meme image can be also crop to a rectangle (side length is smallest side length of the original image).

Check list:
1. Application has Meme editor, sent Memes page and Meme detail page
2. Code conforms to styleguide, is commented and encapsulates code into functions.
3. App allows pick image from album or take an image with the camera (if supported by device). The share button gets enabled after an image has been selected.
4. Image scales as aspect fit
5. Both Meme text fields are provided in the specified style (bold, all caps, white with black outline and shrink to fit). The text field empties content when selected and also shift above the on screen keyboard. After hitting the return button the on screen keyboard and the text field shifts down.
6. Share button with builtin icon is offered in the Edit Meme page and after sharing (also if cancelled) the Memed image is generated as screen shot and stored as Meme object.
7. The Sent Memes shows all sent Memes as either table or collection view. The table/collection can be set into an edit mode that allows the deletion of a Meme. Further a Meme can be added (goes back to the Edit page).
8. If a Meme is selected then a detai page is shown that also the deletion and modification of the Meme. Further a back link is offered to see all sent Memes. Additionally there is a tab bar to navigate to the table/collection view directly.
9. As addon a crop to rectangle is offered in the Meme editor page (enabled if an image is present).

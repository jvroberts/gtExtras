#' Use webshot to save a gt table as a PNG
#' @description Takes existing HTML content, typically additional HTML including a gt table as a PNG via the `{webshot}` package.
#' @param data HTML content to be saved temporarily to disk
#' @param filename The name of the file, should end in `.png`
#' @param path An optional path
#' @param ... Additional arguments to `webshot::webshot()`
#' @param zoom A number specifying the zoom factor. A zoom factor of 2 will result in twice as many pixels vertically and horizontally. Note that using 2 is not exactly the same as taking a screenshot on a HiDPI (Retina) device: it is like increasing the zoom to 200 doubling the height and width of the browser window.
#' @param expand A numeric vector specifying how many pixels to expand the clipping rectangle by. If one number, the rectangle will be expanded by that many pixels on all sides. If four numbers, they specify the top, right, bottom, and left, in that order.
#'
#' @return Prints the HTML content to the RStudio viewer and saves a `.png` file to disk
#' @importFrom webshot webshot
#' @importFrom htmltools browsable
#' @export
#' @family Utilities
#' @section Function ID:
#' 2-14
#'
gtsave_extra <- function(data,
                         filename,
                         path = NULL,
                         ...,
                         zoom = 2,
                         expand = 5) {

  filename <- gt:::gtsave_filename(path = path, filename = filename)

  # Create a temporary file with the `html` extension
  tempfile_ <- tempfile(fileext = ".html")

  # Reverse slashes on Windows filesystems
  tempfile_ <-
    tempfile_ %>%
    gt:::tidy_gsub("\\\\", "/")

  # Save gt table as HTML using the `gt_save_html()` function
  gt:::gt_save_html(
    data = data,
    filename = tempfile_,
    path = NULL
  )
  # Save the image in the working directory
  webshot::webshot(
    url = paste0("file:///", tempfile_),
    file = filename,
    zoom = zoom,
    expand = expand,
    ...
  )

  htmltools::browsable(data)
}
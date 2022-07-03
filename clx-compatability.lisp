

(in-package :xlib)

#+nil
(defun pixmap-p (object)
  (typep object 'pixmap))

#+nil
(defun image-z-p (object)
  (typep object 'image-z))

#+nil
(export 'xlib::image-z-p :xlib)

#+nil
(defun pixmap-plist (pixmap)
  (xlib:drawable-plist pixmap))

#+nil
(defun (setf pixmap-plist) (value window)
  (setf (drawable-plist window) value))

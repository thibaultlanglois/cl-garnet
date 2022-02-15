;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: DEMO-PIXMAP; Base: 10 -*-

;;; The Garnet User Interface Development Environment.
;;;
;;; This code was written as part of the Garnet project at Carnegie
;;; Mellon University, and has been placed in the public domain.  If
;;; you are using this code or any part of Garnet, please contact
;;; garnet@cs.cmu.edu to be put on the mailing list.


(in-package :demo-pixmap)

(eval-when (:load-toplevel :compile-toplevel)
  (defparameter *demos-controller-is-running* t)
  #+nil
  (unless (find-package :demos-controller)
    (make-package :demos-controller)
    (setq *demos-controller-is-running* nil))
  #+nil
  (unless *demos-controller-is-running* 
    )
  )

(fmakunbound 'demos-controller:message)
(defun message (format &rest args)
  (apply #'format (cons t (cons format args))))


(unless (get :garnet-modules :text-buttons)
  (common-lisp-user::garnet-load "gadgets:text-buttons-loader"))
(unless (get :garnet-modules :scrolling-labeled-box)
  (common-lisp-user::garnet-load "gadgets:scrolling-labeled-box-loader"))
;; (unless (get :garnet-modules :ps)
;;    (common-lisp-user::garnet-load "ps:ps-loader"))

(declaim (special COLOR-PROP CHANGER W A FEED-RECT
		  MY-SQUARE FEED-RECT COLOR-SELECTION-WINDOW COLOR-SELECTION-AGGREGATE COLOR-BOX
		  MY-WHITE-FILL COLOR-BOXES LABEL-TEXTS COLOR-PROP
		  PIXMAP-WINDOW PIXMAP-AGGREGATE READ-SAVE CHANGER))

(defvar the-array)
(defvar *pm*) (defvar *pixmap-window*) (defvar *w*)
(defvar *input-file-name-box*)
(defvar *output-file-name-box*)
(defvar *square* 6)
(defvar *square-size* (1- *square*))

(defun My-Point-To-Rank (gob x y)
  (declare (ignore gob))
  (values (floor y *square*) (floor x *square*)))

(create-instance 'my-square opal:rectangle
  (:filling-style (o-formula (gvl :item-values)))
  (:line-style nil)
  (:left (o-formula (* *square* (gvl :rank2))))
  (:top (o-formula (* *square* (gvl :rank1))))
  (:width *square-size*)
  (:height *square-size*))

(defun change-rectangle-color (dum xy)
  (declare (ignore dum))
  (let ((pixarray (g-value *pm* :pixarray))
	(selected-obj (g-value color-prop :feedback :obj-over)))
    (when selected-obj
      (let ((newfill  (g-value selected-obj :filling-style)))
	(opal:do-in-clip-rect (x y the-array xy)
	  (setf (aref pixarray x y)
                (g-value newfill :foreground-color :colormap-index))
	  (opal:change-item the-array newfill x y))
	(opal:update *pixmap-window* t)))))

(defun find-fill-style (index)
  (do ((styles (g-value opal:filling-style :is-a-inv) (cdr styles)))
      ((or (null styles)
	   (and (eq (g-value (car styles) :fill-style) :solid)
	        (eq (g-value (car styles) :foreground-color :colormap-index) index)))
       (or (car styles)
	   (create-instance nil opal:filling-style
	      (:foreground-color (create-instance nil opal:color (:colormap-index index))))))))

(defun Do-Read (filename)
  (if (probe-file filename)
      (progn
	(message "~%Reading ~A..." filename)
	(s-value *pm* :image (opal:read-xpm-file filename))
	(let* ((pixarray (g-value *pm* :pixarray))
	       (dimensions (array-dimensions pixarray)))
	  (unless (equal dimensions (g-value the-array :array-length))
	    (s-value changer :window nil)
	    (opal:remove-component a feed-rect)
	    (opal:destroy *w*)
	    (setq the-array
		  (create-instance nil opal:virtual-aggregate
		    (:item-prototype my-square)
		    (:point-to-rank #'my-point-to-rank)
		    (:item-array (make-array dimensions :initial-element opal:white-fill))))
	    (setq *w*
		  (create-instance 'w inter:interactor-window
		    (:title "Virtual aggregate window")
		    (:left 320) (:top 5)
		    (:width (g-value the-array :width))
		    (:height (g-value the-array :height))
		    (:aggregate (create-instance 'a opal:aggregate))))
	    (opal:add-component a feed-rect)
	    (opal:update *w*)
	    (s-value changer :window *w*)
	    (s-value changer :start-where (list :in the-array))
	    (opal:add-component (g-value *w* :aggregate) the-array))
	  (dotimes (j (second dimensions))
	    (dotimes (i (first dimensions))
	      (opal:change-item the-array (find-fill-style (aref pixarray i j)) i j)))
	  (opal:update *w*)
	  (opal:update *pixmap-window*)
	  (message " Done~%")))
      (message "File ~A does not exist.~%" filename)))


(defun Do-Go (&key dont-enter-main-event-loop double-buffered-p)
  (setq the-array
    (create-instance nil opal:virtual-aggregate
      (:item-prototype my-square)
      (:point-to-rank #'my-point-to-rank)
      (:item-array (make-array (list 32 32)
			       :initial-element opal:black-fill))))
  (create-instance 'w inter:interactor-window
    (:double-buffered-p double-buffered-p)
    (:title "Virtual aggregate window")
    (:left 320) (:top 40)
    (:width  192)
    (:height 192)
    (:aggregate (create-instance 'a opal:aggregate)))
  (setq *w* w)
  (opal:add-component a the-array)
  (opal:add-component a
     (create-instance 'feed-rect opal:rectangle
        (:fast-redraw-p t)
        (:draw-function :xor)
        (:left (formula '(first (gvl :box))))
        (:top (formula '(second (gvl :box))))
        (:width (formula '(third (gvl :box))))
        (:height (formula '(fourth (gvl :box))))
        (:visible NIL)
        (:box '(0 0 0 0))
       (:line-style opal:dashed-line)))
  ;; Color selection window
  (progn
    (create-instance 'color-selection-window inter:interactor-window
      (:aggregate (create-instance 'color-selection-aggregate opal:aggregate))
      (:title "Color Selection")
      (:width 182) (:height 330)
      (:left 5)
      (:top 270))
    (create-instance 'color-box opal:rectangle
      (:left 30)
      (:width 55)
      (:height 20)
      (:line-style opal:default-line-style))
    (create-instance 'my-white-fill opal:filling-style
      (:foreground-color opal:white))
    (create-instance 'color-boxes opal:aggregadget
      (:parts `(
                (:WHITE-BOX ,COLOR-BOX
                            (:FILLING-STYLE ,my-white-fill)
                            (:TOP 40))
                (:BLACK-BOX ,COLOR-BOX
                            (:FILLING-STYLE ,OPAL:BLACK-FILL)
                            (:TOP 70))
                (:RED-BOX ,COLOR-BOX
                          (:FILLING-STYLE ,OPAL:RED-FILL)
                          (:TOP 100))
                (:GREEN-BOX ,COLOR-BOX
                            (:FILLING-STYLE ,OPAL:GREEN-FILL)
                            (:TOP 130))
                (:BLUE-BOX ,COLOR-BOX
                           (:FILLING-STYLE ,OPAL:BLUE-FILL)
                           (:TOP 160))
                (:YELLOW-BOX ,COLOR-BOX
                             (:FILLING-STYLE ,OPAL:YELLOW-FILL)
                             (:TOP 190))
                (:PURPLE-BOX ,COLOR-BOX
                             (:FILLING-STYLE ,OPAL:PURPLE-FILL)
                             (:TOP 220))
                (:CYAN-BOX ,COLOR-BOX
                           (:FILLING-STYLE ,OPAL:CYAN-FILL)
                           (:TOP 250))
                (:ORANGE-BOX ,COLOR-BOX
                             (:FILLING-STYLE ,OPAL:ORANGE-FILL)
                             (:TOP 280))
                )))
    (create-instance 'label-texts opal:aggregadget
      (:parts `(
                (:COLOR-SELECTION ,OPAL:MULTI-TEXT
                                  (:STRING "Color-Selection")
                                  (:FONT ,(create-instance nil OPAL:FONT
                                            (:SIZE :LARGE)
                                            (:FACE :BOLD)))
                                  (:LEFT 10)
                                  (:TOP 15))
                (:WHITE-LABEL ,OPAL:MULTI-TEXT
                              (:STRING "White")
                              (:LEFT 100)
                              (:TOP 42))
                (:BLACK-LABEL ,OPAL:MULTI-TEXT
                              (:STRING "Black")
                              (:LEFT 100)
                              (:TOP 72))
                (:RED-LABEL ,OPAL:MULTI-TEXT
                            (:STRING "Red")
                            (:LEFT 100)
                            (:TOP 102))
                (:GREEN-LABEL ,OPAL:MULTI-TEXT
                              (:STRING "Green")
                              (:LEFT 100)
                              (:TOP 132))
                (:BLUE-LABEL ,OPAL:MULTI-TEXT
                             (:STRING "Blue")
                             (:LEFT 100)
                             (:TOP 162))
                (:YELLOW-LABEL ,OPAL:MULTI-TEXT
                               (:STRING "Yellow")
                               (:LEFT 100)
                               (:TOP 192))
                (:PURPLE-LABEL ,OPAL:MULTI-TEXT
                               (:STRING "Purple")
                               (:LEFT 100)
                               (:TOP 222))
                (:CYAN-LABEL ,OPAL:MULTI-TEXT
                             (:STRING "Cyan")
                             (:LEFT 100)
                             (:TOP 252))
                (:ORANGE-LABEL ,OPAL:MULTI-TEXT
                               (:STRING "Orange")
                               (:LEFT 100)
                               (:TOP 282)))))
    (create-instance 'COLOR-PROP OPAL:AGGREGADGET
      (:WINDOW-TITLE "Color Properties")
      (:WINDOW-LEFT 0)
      (:WINDOW-TOP 0)
      (:WINDOW-WIDTH 550)
      (:WINDOW-HEIGHT 330)
      (:LEFT 0)
      (:TOP 0)
      (:WIDTH (o-formula (GVL :WINDOW :WIDTH) 450))
      (:HEIGHT (o-formula (GVL :WINDOW :HEIGHT) 330))
      (:parts `(
                (:colors ,color-boxes)
                (:labels ,label-texts)
                (:i-feedback ,opal:rectangle
                             (:constant (:line-style :filling-style :draw-function))
                             (:obj-over NIL)
                             (:visible ,(o-formula (gvl :obj-over)))
                             (:left ,(o-formula (- (gvl :obj-over :left) 3)))
                             (:top ,(o-formula (- (gvl :obj-over :top) 3)))
                             (:width ,(o-formula (+ (gvl :obj-over :width) 6)))
                             (:height ,(o-formula (+ (gvl :obj-over :height) 6)))
                             (:fast-redraw-p T)
                             (:line-style ,opal:dashed-line)
                             (:draw-function :xor))
                (:feedback ,opal:rectangle
                           (:constant (:line-style :filling-style :draw-function))
                           (:obj-over NIL)
                           (:visible ,(o-formula (gvl :obj-over)))
                           (:left ,(o-formula (- (gvl :obj-over :left) 3)))
                           (:top ,(o-formula (- (gvl :obj-over :top) 3)))
                           (:width ,(o-formula (+ (gvl :obj-over :width) 6)))
                           (:height ,(o-formula (+ (gvl :obj-over :height) 6)))
                           (:fast-redraw-p T)
                           (:line-style ,opal:line-2)
                           (:draw-function :xor))))
      (:interactors `(
                      (:press ,inter:menu-interactor
                              (:constant (:start-where :feedback-obj :final-feedback-obj))
                              (:start-where
                               ,(o-formula (list :element-of (gvl :operates-on :colors))))
                              (:feedback-obj ,(o-formula (gvl :operates-on :i-feedback)))
                              (:final-feedback-obj ,(o-formula (gvl :operates-on :feedback)))
                              (:window ,(o-formula (gvl :operates-on :window)))))))    
    (opal:add-component color-selection-aggregate color-prop))
  ;; pixmap window
  (progn
    (setq *pm*
          (create-instance nil opal:pixmap
            (:image (opal:create-pixmap-image 32 32 opal:black))
            (:left 10)
            (:top 10)))
    (create-instance 'pixmap-window inter:interactor-window
      (:aggregate (create-instance 'pixmap-aggregate opal:aggregate))
      (:title "pixmap")
      (:width 700) (:height 510)
      (:left 200)
      (:top 40))
    (opal:add-component pixmap-aggregate *pm*)
    (setq *pixmap-window* pixmap-window)
    (create-instance 'READ-SAVE garnet-gadgets::text-button-panel
      (:items (list "Read" "Save" "PS" "Quit"))
      (:final-feedback-p NIL)
      (:direction :horizontal)
      (:selection-function
       #'(lambda (dummy string)
	   (declare (ignore dummy))
	   (cond ((equal string "Read")
		  (Do-Read (g-value *input-file-name-box* :value)))
		 ((equal string "Save")
		  (message
		   "Saving into ~A... "
		   (g-value *output-file-name-box* :value))
		  (opal::write-xpm-file
		   *pm*
		   (g-value *output-file-name-box* :value))
		  (message "Done~%"))
		 ((equal string "PS")
		  (s-value read-save :visible nil)
		  (s-value *output-file-name-box* :visible nil)
		  (s-value *input-file-name-box* :visible nil)
		  (opal:update *pixmap-window*)
		  (opal:make-ps-file *pixmap-window*
				     (g-value *output-file-name-box* :value))
		  (s-value read-save :visible T)
		  (s-value *output-file-name-box* :visible T)
		  (s-value *input-file-name-box* :visible T)
		  (opal:update *pixmap-window*))
		 ((equal string "Quit")
		  (Do-stop)))))
      (:left 10) (:top (o-formula (+ (gv *pm* :height) 10))))
    (setq *input-file-name-box*
          (create-instance NIL garnet-gadgets:scrolling-labeled-box
            (:left 10)
            (:top (o-formula (+ (gv read-save :top) (gv read-save :height) 10)))
            (:width 550)
            (:value "/home/tl/PointCentral/Garnet/cat-eye-pixels.xpm"
                    ;; (namestring (merge-pathnames "eye.xpm" common-lisp-user::Garnet-Pixmap-Pathname))
                    )
            (:label-string "Input file:")))
    (setq *output-file-name-box*
          (create-instance NIL garnet-gadgets:scrolling-labeled-box
            (:left 10)
            (:top (o-formula (+ (gv *input-file-name-box* :top)
                                (gv *input-file-name-box* :height)
                                10)))
            (:width 550)
            (:value "foo.xpm")
            (:label-string "Output file:")))
    (opal:add-components pixmap-aggregate read-save *input-file-name-box* *output-file-name-box*))
  (create-instance 'CHANGER inter:two-point-interactor
     (:start-event :leftdown)
     (:continuous T)
     (:start-where `(:in ,the-array))
     (:window w)
     (:feedback-obj feed-rect)
     (:final-function #'Change-rectangle-color))
  (opal:update w)
  (opal:update color-selection-window)
  (opal:update pixmap-window)
  (format t "~%Click and drag with left button to change pixel color~%")
  (format t "to be the color indicated in the color property gadget.~%")
  (unless dont-enter-main-event-loop #-cmu (inter:main-event-loop)))


(defun Do-Stop ()
  (format t "Destroying ~A ~A ~A~%" w pixmap-window color-selection-window)
  (opal:destroy w)
  (opal:destroy pixmap-window)
  (opal:destroy color-selection-window)
  (format t "done.~%~A~%" *demos-controller-is-running*)
  (format t "~A" (sb-thread:list-all-threads))
  (unless *demos-controller-is-running*
    (print 'quit-lisp)
    (sb-ext:exit))
  ;;for demo-controller
  (if (fboundp 'Common-Lisp-User::Garnet-Note-Quitted)
      (Common-Lisp-User::Garnet-Note-Quitted "DEMO-PIXMAP"))
  
  )


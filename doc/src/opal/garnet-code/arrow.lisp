;;; -*- Mode: Lisp; Package: ARROW -*-
;;;
;;;  Illustration of the components of an arrowhead.
;;;
;;;  START: (arrow:do-go)
;;;  QUIT:  (arrow:do-stop)
;;;
;;;  Designed by Brad A. Myers
;;;  Written by Andrew Mickish

(in-package "arrow" :use '("kr" "lisp"))

(export '(do-go do-stop))

(defparameter vp nil)
(defparameter top-agg nil)
(defparameter *font* (create-instance nil opal:font-from-file
			(:filename "/usr/andrew/x11fonts/times10.snf")))
(defparameter *line-style* (create-instance nil opal:line-style
			      (:line-thickness 30)))

(defun do-go ()

  (setf vp (create-instance nil inter:interactor-window
	      (:left 600) (:top 10) (:width 400) (:height 400)))

  (s-value vp :aggregate
	   (setf top-agg (create-instance nil opal:aggregate
			    (:overlapping nil))))

  (create-instance 'arrow-agg opal:aggregadget
     (:angle (/ pi 3.0))
     (:x1 20)(:y1 280)(:x2 200)(:y2 75)
     (:length 125)(:diameter 175)
     (:parts
      `((:shaft opal:line
		(:x1 ,(formula '(gvl :parent :x1)))
		(:y1 ,(formula '(gvl :parent :y1)))
		(:x2 ,(formula '(gvl :parent :head :connect-x)))
		(:y2 ,(formula '(gvl :parent :head :connect-y)))
		(:line-style ,opal:dashed-line))
	(:head opal:arrowhead
	       (:from-x ,(formula '(gvl :parent :x1)))
	       (:from-y ,(formula '(gvl :parent :y1)))
	       (:head-x ,(formula '(gvl :parent :x2)))
	       (:head-y ,(formula '(gvl :parent :y2)))
	       (:line-style ,*line-style*)
	       (:length ,(formula `(gvl :parent :length)))
	       (:diameter ,(formula `(gvl :parent :diameter)))
	       (:open-p t)))))


  (create-instance 'tiny-arrowhead opal:arrowhead
     (:draw-function :xor)
     (:from-x 150) (:from-y 150) (:head-x 200) (:head-y 200)
     (:length 6) (:diameter 9))

  (create-instance 'dot-circle opal:circle
      (:draw-function :xor)
      (:left 250)(:top 250)(:height 8)(:width 8)
      (:filling-style (opal:halftone 100)))

  (create-instance 'pointer-agg opal:aggregadget
     (:x1 150)(:y1 150)(:x2 200)(:y2 200)
     (:parts
      `((:shaft opal:line
		(:draw-function :xor)
		(:x1 ,(formula `(gvl :parent :x1)))
		(:y1 ,(formula `(gvl :parent :y1)))
		(:x2 ,(formula `(gvl :parent :x2)))
		(:y2 ,(formula `(gvl :parent :y2))))
	(:right-arrowhead tiny-arrowhead
		 (:from-x ,(formula `(gvl :parent :x1)))
		 (:from-y ,(formula `(gvl :parent :y1)))
		 (:head-x ,(formula `(gvl :parent :x2)))
		 (:head-y ,(formula `(gvl :parent :y2))))
	(:left-arrowhead tiny-arrowhead
		 (:from-x ,(formula `(gvl :parent :x2)))
		 (:from-y ,(formula `(gvl :parent :y2)))
		 (:head-x ,(formula `(gvl :parent :x1)))
		 (:head-y ,(formula `(gvl :parent :y1)))))))


  (create-instance 'cross-bar-agg opal:aggregadget
     (:coords (formula `(get-points (gvl :parent :arrow :head))))
     (:x1 (formula `(first (gvl :coords))))
     (:y1 (formula `(second (gvl :coords))))
     (:x2 (formula `(third (gvl :coords))))
     (:y2 (formula `(fourth (gvl :coords))))
     (:parts
      `((:pointer pointer-agg
		  (:x1 ,(formula `(+ 4 (gvl :parent :x1))))
		  (:y1 ,(formula `(+ 4 (gvl :parent :y1))))
		  (:x2 ,(formula `(- (gvl :parent :x2) 4)))
		  (:y2 ,(formula `(- (gvl :parent :y2) 4))))
	(:left-dot dot-circle
		   (:left ,(formula `(- (gvl :parent :x1) 4)))
		   (:top ,(formula `(- (gvl :parent :y1) 2))))
	(:right-dot dot-circle
		    (:left ,(formula `(- (gvl :parent :x2) 4)))
		    (:top ,(formula `(- (gvl :parent :y2) 4))))
	(:diam-text opal:text
		    (:string ":diameter")
		    (:left ,(formula `(- (gvl :parent :parent :arrow :head
					     :connect-x) 12)))
		    (:top ,(formula `(+ (gvl :parent :parent :arrow :head
					    :connect-y) 33)))
		    (:font ,*font*)))))


  (create-instance 'length-agg opal:aggregadget
     (:x1 (formula `(gvl :parent :arrow :x2)))
     (:y1 (formula `(gvl :parent :arrow :y2)))
     (:x2 (formula `(gvl :parent :arrow :head :connect-x)))
     (:y2 (formula `(gvl :parent :arrow :head :connect-y)))
     (:parts
      `((:pointer pointer-agg
		  (:x1 ,(formula `(- (gvl :parent :x1) 4)))
		  (:y1 ,(formula `(+ (gvl :parent :y1) 4)))
		  (:x2 ,(formula `(+ (gvl :parent :x2) 4)))
		  (:y2 ,(formula `(- (gvl :parent :y2) 4))))
	(:top-dot dot-circle
		  (:left ,(formula `(- (gvl :parent :x1) 4)))
		  (:top ,(formula `(- (gvl :parent :y1) 4))))
	(:bot-dot dot-circle
		  (:left ,(formula `(- (gvl :parent :x2) 4)))
		  (:top ,(formula `(- (gvl :parent :y2) 4))))
	(:length-text opal:text
		      (:string ":length")
		      (:left ,(formula `(- (floor (+ (gvl :parent :x1)
						     (gvl :parent :x2))
						  2)
					   45)))
		      (:top ,(formula `(floor (+ (gvl :parent :y1)
						 (gvl :parent :y2))
					      2)))
		      (:font ,*font*)))))


  (create-instance 'thickness-agg opal:aggregadget
     (:coords (formula `(get-points (gvl :parent :arrow :head))))
     (:x (formula `(third (gvl :coords))))
     (:y (formula `(fourth (gvl :coords))))
     (:parts
      `((:pointer pointer-agg
		(:x1 ,(formula `(- (gvl :parent :x) 15)))
		(:y1 ,(formula `(+ (gvl :parent :y) 8)))
		(:x2 ,(formula `(+ (gvl :parent :x) 15)))
		(:y2 ,(formula `(+ (gvl :parent :y) 8))))
	(:thick-text opal:text
		     (:string ":thickness")
		     (:left ,(formula `(- (gvl :parent :x) 20)))
		     (:top ,(formula `(+ (gvl :parent :y) 15)))
		     (:font ,*font*)))))

  (create-instance 'from-agg opal:aggregadget
     (:left (formula `(gvl :parent :arrow :x1)))
     (:top (formula `(gvl :parent :arrow :y1)))
     (:parts
      `((:from-text opal:text
		    (:string "(:from-x, :from-y)")
		    (:left ,(formula `(+ (gvl :parent :left) 2)))
		    (:top ,(formula `(+ (gvl :parent :top) 4)))
		    (:font ,*font*))
	(:dot dot-circle
	      (:left ,(formula `(- (gvl :parent :left) 4)))
	      (:top ,(formula `(- (gvl :parent :top) 4)))))))


  (create-instance 'connect-agg opal:aggregadget
     (:left (formula `(- (gvl :parent :arrow :head :connect-x) 90)))
     (:top (formula `(- (gvl :parent :arrow :head :connect-y) 17)))
     (:parts
      `((:top-text opal:text
		   (:string "(:connect-x,")
		   (:left ,(formula `(gvl :parent :left)))
		   (:top ,(formula `(gvl :parent :top)))
		   (:font ,*font*))
	(:bot-text opal:text
		   (:string ":connect-y)")
		   (:left ,(formula `(+ 20 (gvl :parent :left))))
		   (:top ,(formula `(+ 12 (gvl :parent :top))))
		   (:font ,*font*)))))

  (create-instance 'head-text opal:text
     (:string "(:head-x, :head-y)")
     (:left (formula `(+ 20 (gvl :parent :arrow :x2))))
     (:top (formula `(- (gvl :parent :arrow :y2) 7)))
     (:font *font*))


  (create-instance 'arrow-ex opal:aggregadget
     (:x1 50) (:y1 300)
     (:x2 (formula `(+ (gvl :x1) 30)))
     (:y2 (formula `(gvl :y1)))
     (:length 10)
     (:diameter 15)
     (:line-style opal:line-1)
     (:open-p nil)
     (:parts
      `((:head opal:arrowhead
	       (:from-x ,(formula '(gvl :parent :x1)))
	       (:from-y ,(formula '(gvl :parent :y1)))
	       (:head-x ,(formula '(gvl :parent :x2)))
	       (:head-y ,(formula '(gvl :parent :y2)))
	       (:line-style ,(formula `(gvl :parent :line-style)))
	       (:filling-style ,(formula `(gvl :parent :filling-style)))
	       (:length ,(formula `(gvl :parent :length)))
	       (:diameter ,(formula `(gvl :parent :diameter)))
	       (:open-p ,(formula `(gvl :parent :open-p)))))))


  (create-instance 'arrow-set opal:aggregadget
     (:x1 (formula `(gvl :parent :arrow :x1)))
     (:y1 (formula `(+ 70 (gvl :parent :arrow :y1))))
     (:inc-by 50)
     (:parts
      `((:arrow1 arrow-ex
		 (:x1 ,(formula `(gvl :parent :x1)))
		 (:y1 ,(formula `(gvl :parent :y1)))
		 (:open-p t))
	(:arrow2 arrow-ex
		 (:x1 ,(formula `(+ (gvl :parent :x1)
				    (gvl :parent :inc-by))))
		 (:y1 ,(formula `(gvl :parent :y1)))
		 (:open-p nil))
	(:arrow3 arrow-ex
		 (:x1 ,(formula `(+ (gvl :parent :x1)
				    (* 2 (gvl :parent :inc-by)))))
		 (:y1 ,(formula `(gvl :parent :y1)))
		 (:open-p t)
		 (:filling-style ,opal:light-gray-fill))
	(:arrow4 arrow-ex
		 (:x1 ,(formula `(+ (gvl :parent :x1)
				    (* 3 (gvl :parent :inc-by)))))
		 (:y1 ,(formula `(gvl :parent :y1)))
		 (:open-p nil)
		 (:filling-style ,opal:light-gray-fill))
	(:arrow5 opal:arrowhead
		 (:from-x ,(formula `(+ (gvl :parent :x1)
				    (* 4 (gvl :parent :inc-by)))))
		 (:from-y ,(formula `(gvl :parent :y1)))
		 (:head-x ,(formula `(+ (gvl :from-x) 30)))
		 (:head-y ,(formula `(gvl :from-y)))
		 (:length 12)
		 (:diameter 15)
		 (:open-p t)
		 (:line-style nil)
		 (:filling-style ,opal:light-gray-fill)))))

  (create-instance 'unit opal:aggregadget
     (:parts
      `((:arrow arrow-agg)
	(:cross-bar cross-bar-agg)
	(:length-bar length-agg)
	(:thick-bar thickness-agg)
	(:from from-agg)
	(:connect connect-agg)
	(:head head-text)
	(:set arrow-set))))

  (opal:add-components top-agg (create-instance nil unit))

  (opal:update vp)

  )

;; ** STOP **
(defun do-stop ()
  (opal:destroy vp))

(format t "Enter (arrow:do-go) to begin.~%")
(format t "Enter (arrow:do-stop) to quit.~%")


(defun get-points (arrow-head)
  (let* ((head-x (g-value arrow-head :head-x))
	 (head-y (g-value arrow-head :head-y))
	 (from-x (g-value arrow-head :from-x))
	 (from-y (g-value arrow-head :from-y))
	 (length (g-value arrow-head :length))
	 (diameter (g-value arrow-head :diameter))

	 (radius (/ diameter 2))
	 (dx (- from-x head-x))
	 (dy (- from-y head-y))
	 (ftlength (sqrt (+ (* dx dx) (* dy dy))))

	 (ux (/ dx ftlength))
	 (uy (/ dy ftlength))

	 (bx (+ head-x (* length ux)))
	 (by (+ head-y (* length uy)))
	 (ax (round (- bx (* radius uy))))
	 (ay (round (+ by (* radius ux))))
	 (cx (round (+ bx (* radius uy))))
	 (cy (round (- by (* radius ux)))))
    (list ax ay cx cy)))

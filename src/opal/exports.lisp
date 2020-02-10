
(in-package "OPAL")

(defvar *debug-opal-mode* nil)
(setf (get :garnet-modules :opal) T)

;;; Import some stuff from GEM that used to be in OPAL.
(eval-when (:execute :load-toplevel :compile-toplevel)
  (import '(gem:Display-Info
	    gem:Make-Display-Info gem:Copy-Display-Info
	    gem:Display-Info-Display gem:Display-Info-Screen gem:Display-Info-Root-Window
	    gem:Display-Info-Line-Style-GC gem:Display-Info-Filling-Style-GC

	    gem:*Small-Font-Point-Size* gem:*Medium-Font-Point-Size*
	    gem:*Large-Font-Point-Size* gem:*Very-Large-Font-Point-Size*
	    gem:default-font-from-file)
	  (find-package "OPAL")))

(eval-when (:execute :load-toplevel :compile-toplevel)
  (export '(*debug-opal-mode* bottom right center-x center-y
	    *garnet-windows*
	    ADD-CHAR
	    ADD-OBJECT
	    BETWEEN-MARKS-P
	    CHANGE-COLOR-OF-SELECTION
	    CHANGE-FONT-OF-SELECTION
	    CONCATENATE-TEXT
	    COPY-SELECTED-TEXT
	    Class
	    Clean-Up.Lisp
	    Colors
	    DELETE-CHAR
	    DELETE-PREV-CHAR
	    DELETE-PREV-WORD
	    DELETE-SELECTION
	    DELETE-SUBSTRING
	    DELETE-WORD
	    EMPTY-TEXT-P
	    FETCH-NEXT-CHAR
	    FETCH-PREV-CHAR
	    From
	    From
	    From
	    From
	    GET-CURSOR-LINE-CHAR-POSITION
	    GET-OBJECTS
	    GET-SELECTION-LINE-CHAR-POSITION
	    GET-STRING
	    GET-TEXT
	    GO-TO-BEGINNING-OF-LINE
	    GO-TO-BEGINNING-OF-TEXT
	    GO-TO-END-OF-LINE
	    GO-TO-END-OF-TEXT
	    GO-TO-NEXT-CHAR
	    GO-TO-NEXT-LINE
	    GO-TO-NEXT-WORD
	    GO-TO-PREV-CHAR
	    GO-TO-PREV-LINE
	    GO-TO-PREV-WORD
	    Get-X-Cut-Buffer
	    IMHO
	    INSERT-MARK
	    INSERT-STRING
	    INSERT-TEXT
	    KILL-REST-OF-LINE
	    MARK
	    MULTIFONT-TEXT
	    Multifont
	    NOTICE-RESIZE-OBJECT
	    PURE-LIST-TO-TEXT
	    SEARCH-BACKWARDS-FOR-MARK
	    SEARCH-FOR-MARK
	    SET-CURSOR-TO-LINE-CHAR-POSITION
	    SET-CURSOR-TO-X-Y-POSITION
	    SET-CURSOR-VISIBLE
	    SET-SELECTION-TO-LINE-CHAR-POSITION
	    SET-SELECTION-TO-X-Y-POSITION
	    SET-TEXT
	    Set-X-Cut-Buffer
	    aggregate
	    gv-bottom
	    gv-bottom-is-top-of
	    gv-center-x
	    gv-center-x-is-center-of
	    gv-center-y
	    gv-center-y-is-center-of
	    gv-right
	    gv-right-is-left-of
	    halftone
	    halftone-darker
	    halftone-image
	    halftone-image-darker
	    halftone-image-lighter
	    halftone-lighter
	    hourglass-cursor
	    hourglass-cursor-mask
	    hourglass-pair
	    iconify-window
	    initialize
	    kill-main-event-loop-process
	    launch-main-event-loop-process
	    left-side
	    light-gray-fill
	    line
	    line-0
	    line-1
	    line-2
	    line-4
	    line-8
	    line-style
	    lower-window
	    main-event-loop-process-running-p
	    make-filling-style
	    make-image get-garnet-bitmap directory-p
	    motif-blue
	    motif-blue-fill
	    motif-gray
	    motif-gray-fill
	    motif-green
	    motif-green-fill
	    motif-light-blue
	    motif-light-blue-fill
	    motif-light-gray
	    motif-light-gray-fill
	    motif-light-green
	    motif-light-green-fill
	    motif-light-orange
	    motif-light-orange-fill
	    motif-orange
	    motif-orange-fill
	    move-component
	    move-cursor-down-one-line
	    move-cursor-to-beginning-of-line
	    move-cursor-to-end-of-line
	    move-cursor-up-one-line
	    multi-text
	    multipoint
	    names
	    no-fill
	    no-line
	    open-and-close.lisp
	    orange
	    orange-fill
	    orange-line
	    oval
	    pixmap write-xpm-file read-xpm-file
	    point-in-gob
	    point-to-component
	    point-to-leaf
	    point-to-rank
	    polygon
	    polyline
	    process.lisp
	    purple
	    purple-fill
	    purple-line
	    q-abs
	    q-max
	    q-min
	    raise-window
	    read-image
	    recalculate-virtual-aggregate-bboxes
	    reconnect-garnet
	    rectangle
	    red
	    red-fill
	    red-line
	    remove-all-components
	    remove-component
	    remove-components
	    remove-item
	    reset-cursor
	    restore-cursors
	    right-side
	    rotate
	    roundtangle
	    running-main-event-loop-process-elsewhere-p
	    set-bounding-box
	    set-center
	    set-position
	    set-size
	    should
	    string-height
	    string-width
	    stuff.
	    text
	    that
	    thin-line
	    top-side
	    update
	    update-all
	    view-object
	    virtual-aggregate
	    virtual-aggregates.lisp
	    white
	    white-fill
	    white-line
	    with-cursor
	    with-hourglass-cursor
	    write-image
	    yellow
	    yellow-fill
	    yellow-line
	    zoom-window
            time-to-string
	    clip-and-map
	    drawable-to-window)))

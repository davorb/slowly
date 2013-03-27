
(in-package #:slowly)


(defclass tile ()
  ((x :accessor xcoord 
      :initarg :x)
   (y :accessor ycoord 
      :initarg :y)
   (type :accessor type
         :initform :empty
         :initarg :type)
   (color :accessor tile-color
          :initform :white)))

(defgeneric tile-to-string (tile)
  (:documentation "Returns what the tile will be represented 
as on the screen"))

(defgeneric tile-color (tile)
  (:documentation "Returns what color the tile should be
painted with"))

(defmacro deftile (type output color)
  `(defmethod tile-to-string ((tile ,type))
     (identity ,output))
  `(defmethod tile-color ((tile ,type))
     

(defclass wall-tile (tile) ())
(deftile wall-tile "#")

(defclass floor-tile (tile) ())
(deftile floor-tile ".")

(defclass empty-tile (tile) ())
(deftile empty-tile " ")
